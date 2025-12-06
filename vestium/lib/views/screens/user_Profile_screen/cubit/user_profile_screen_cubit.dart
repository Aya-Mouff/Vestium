// user_profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../repo/user_repo.dart';
import '../../../../repo/post_repo.dart';
import '../../../../repo/follow_repo.dart';
import '../../../../databases/db_models.dart';
import 'user_profile_screen_state.dart';
import 'package:flutter/material.dart';
import '../../../../databases/services/user_profile_service.dart';
import '../../../../databases/services/post_image_service.dart';
import 'dart:io';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserRepo _userRepo;
  final PostRepo _postRepo;
  final FollowRepo _followRepo;
  final int currentUserId;

  UserProfileCubit({
    required UserRepo userRepo,
    required PostRepo postRepo,
    required FollowRepo followRepo,
    required this.currentUserId,
  })  : _userRepo = userRepo,
        _postRepo = postRepo,
        _followRepo = followRepo,
        super(UserProfileInitial());

  Future<void> loadProfile(int userId) async {
    emit(UserProfileLoading());

    try {
      // 1. Get user
      final User? user = await _userRepo.getById(userId);
      if (user == null) {
        emit(UserProfileError('User not found'));
        return;
      }

      // 2. Get user's posts
      final List<PostModel> posts = await _postRepo.getByUserId(userId);

      // 3. Check if current user is following this user
      bool isFollowing = false;
      if (currentUserId != -1 && currentUserId != userId) {
        final allFollows = await _followRepo.getAll();
        isFollowing = allFollows.any((f) => 
            f.followerId == currentUserId && f.followingId == userId);
      }

      // 4. Get followers and following counts using new methods
      final followersCount = await _followRepo.getFollowersCount(userId);
      final followingCount = await _followRepo.getFollowingCount(userId);

      // 5. Get the valid profile image path using UserProfileService
      final profileImagePath = await _getValidProfileImagePath(userId, user.pfp);

      // 6. Get post image paths using PostImageService
      final postsWithImages = await Future.wait(posts.map((post) async {
        final postImagePath = await PostImageService.getPostImagePath(post.postId ?? -1);
        // Use copyWith to update the imagePath
        return post.copyWith(
          imagePath: postImagePath ?? post.imagePath,
        );
      }));

      // 7. Create updated user with correct profile image path
      final updatedUser = user.copyWith(pfp: profileImagePath);

      emit(UserProfileLoaded(
        user: updatedUser,
        posts: postsWithImages,
        isFollowing: isFollowing,
        followersCount: followersCount,
        followingCount: followingCount,
      ));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  /// Helper method to get the valid profile image path
  Future<String> _getValidProfileImagePath(int userId, String? pfpPath) async {
    // If a path is provided in the database, check if it's valid
    if (pfpPath != null && pfpPath.isNotEmpty) {
      // Check if it's an asset path
      if (pfpPath.startsWith('assets/')) {
        return pfpPath;
      }
      
      // Check if it's a file path that exists
      final file = File(pfpPath);
      final fileExists = await file.exists();
      if (fileExists) {
        return pfpPath;
      }
    }
    
    // If no valid path in database, check user_profiles directory
    final userProfilePath = await UserProfileService.getUserProfileImagePath(userId);
    if (userProfilePath != null) {
      return userProfilePath;
    }
    
    // Fallback to default asset
    return 'assets/images/icons/person.jpg';
  }

  Future<void> toggleFollow(BuildContext context) async {
    if (currentUserId == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must log in to follow users."),
        ),
      );
      return;
    }

    if (state is UserProfileLoaded) {
      final current = state as UserProfileLoaded;
      
      // Don't allow following yourself
      if (current.user.userId == currentUserId) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You cannot follow yourself."),
          ),
        );
        return;
      }

      try {
        if (current.isFollowing) {
          // Unfollow
          await _followRepo.delete(current.user.userId!, currentUserId);
          
          // Update counts
          final newFollowersCount = await _followRepo.getFollowersCount(current.user.userId!);
          
          emit(current.copyWith(
            isFollowing: false,
            followersCount: newFollowersCount,
          ));
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Unfollowed ${current.user.username}"),
            ),
          );
        } else {
          // Follow
          final follow = FollowingFollower(
            followingId: current.user.userId!,
            followerId: currentUserId,
            date: DateTime.now().toIso8601String(),
          );
          await _followRepo.insert(follow);
          
          // Update counts
          final newFollowersCount = await _followRepo.getFollowersCount(current.user.userId!);
          
          emit(current.copyWith(
            isFollowing: true,
            followersCount: newFollowersCount,
          ));
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("You are now following ${current.user.username}"),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
          ),
        );
      }
    }
  }

  // Get list of followers
  Future<List<User>> getFollowers(int userId) async {
    return await _followRepo.getFollowers(userId);
  }

  // Get list of following
  Future<List<User>> getFollowing(int userId) async {
    return await _followRepo.getFollowing(userId);
  }

  // Refresh profile with updated counts
  Future<void> refreshProfile() async {
    if (state is UserProfileLoaded) {
      final current = state as UserProfileLoaded;
      await loadProfile(current.user.userId!);
    }
  }

  // Update user profile (keep existing counts)
  Future<void> updateProfile({
    String? username,
    String? fullName,
    String? bio,
    String? pfp,
  }) async {
    if (state is! UserProfileLoaded) return;

    final current = state as UserProfileLoaded;
    
    try {
      // If updating profile picture, save it using UserProfileService
      String? updatedPfp = pfp;
      if (pfp != null && !pfp.startsWith('assets/')) {
        // This is a new profile image file, save it
        updatedPfp = await UserProfileService.updateUserProfileImage(
          current.user.userId!, 
          pfp,
        );
      }
      
      final updatedUser = await _userRepo.updateUserPartial(
        userId: current.user.userId!,
        username: username,
        fullName: fullName,
        bio: bio,
        pfp: updatedPfp ?? pfp,
      );
      
      // Keep the existing counts
      emit(current.copyWith(user: updatedUser));
    } catch (e) {
      emit(UserProfileError('Failed to update profile: ${e.toString()}'));
    }
  }

  // Update permissions
  Future<void> updatePermissions({
    bool? cameraPermission,
    bool? galleryPermission,
  }) async {
    if (state is! UserProfileLoaded) return;

    final current = state as UserProfileLoaded;
    
    try {
      final updatedUser = await _userRepo.updateUserPartial(
        userId: current.user.userId!,
        cameraPermission: cameraPermission == true ? 1 : 0,
        galleryPermission: galleryPermission == true ? 1 : 0,
      );
      
      emit(current.copyWith(user: updatedUser));
    } catch (e) {
      emit(UserProfileError('Failed to update permissions: ${e.toString()}'));
    }
  }

  // Create a new post
  Future<void> createPost({
    required String imagePath,
    String? caption,
    int? outfitId,
  }) async {
    if (state is! UserProfileLoaded) return;

    final current = state as UserProfileLoaded;
    
    try {
      // Save the post image using PostImageService
      final savedImagePath = await PostImageService.savePostImage(
        imagePath, 
        userId: current.user.userId,
      );
      
      final newPost = PostModel(
        outfitId: outfitId,
        imagePath: savedImagePath, // Use the saved path
        caption: caption,
        date: DateTime.now().toIso8601String(),
      );

      await _postRepo.insert(newPost);
      
      // Refresh posts list
      final updatedPosts = await _postRepo.getByUserId(current.user.userId!);
      
      // Get updated post image paths using copyWith
      final postsWithImages = await Future.wait(updatedPosts.map((post) async {
        final postImagePath = await PostImageService.getPostImagePath(post.postId ?? -1);
        return post.copyWith(
          imagePath: postImagePath ?? post.imagePath,
        );
      }));
      
      emit(current.copyWith(posts: postsWithImages));
    } catch (e) {
      emit(UserProfileError('Failed to create post: ${e.toString()}'));
    }
  }

  // Delete a post
  Future<void> deletePost(int postId) async {
    if (state is! UserProfileLoaded) return;

    final current = state as UserProfileLoaded;
    
    try {
      // Delete the post image from storage
      await PostImageService.deletePostImageById(postId);
      
      // Delete from database
      await _postRepo.delete(postId);
      
      // Refresh posts list
      final updatedPosts = await _postRepo.getByUserId(current.user.userId!);
      
      // Get updated post image paths using copyWith
      final postsWithImages = await Future.wait(updatedPosts.map((post) async {
        final postImagePath = await PostImageService.getPostImagePath(post.postId ?? -1);
        return post.copyWith(
          imagePath: postImagePath ?? post.imagePath,
        );
      }));
      
      emit(current.copyWith(posts: postsWithImages));
    } catch (e) {
      emit(UserProfileError('Failed to delete post: ${e.toString()}'));
    }
  }
}