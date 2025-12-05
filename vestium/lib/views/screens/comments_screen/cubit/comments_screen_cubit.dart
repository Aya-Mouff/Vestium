import 'package:flutter_bloc/flutter_bloc.dart';
import 'comments_screen_state.dart';
import '../../../../repo/comment_repo.dart';
import '../../../../repo/user_repo.dart';
import '../../../../databases/db_models.dart';
import '../../../../databases/services/user_profile_service.dart';

import 'dart:io';

class CommentsScreenCubit extends Cubit<CommentsScreenState> {
  final int postId;
  final int userId;
  final CommentRepo _commentRepo = CommentRepo();
  final UserRepo _userRepo = UserRepo();

  CommentsScreenCubit({required this.postId, required this.userId})
      : super(CommentsLoading());

  Future<void> loadComments() async {
    emit(CommentsLoading());

    try {
      // 1. Get all comments for this post, ordered by date (oldest to newest)
      final List<CommentModel> comments = await _commentRepo.getByPostId(postId);
      
      // Sort comments by date (earliest first)
      comments.sort((a, b) {
        final dateA = DateTime.parse(a.date ?? '2000-01-01');
        final dateB = DateTime.parse(b.date ?? '2000-01-01');
        return dateA.compareTo(dateB);
      });

      // 2. Get user data for all comment authors
      final Map<int, dynamic> usersMap = {};
      for (final comment in comments) {
        if (comment.userId != null && !usersMap.containsKey(comment.userId)) {
          final user = await _userRepo.getById(comment.userId!);
          if (user != null) {
            // Get valid profile image path
            final profileImagePath = await _getValidProfileImagePath(user.userId!, user.pfp);
            final userWithImage = user.copyWith(pfp: profileImagePath);
            
            usersMap[comment.userId!] = {
              'id': userWithImage.userId,
              'username': userWithImage.username ?? 'Unknown',
              'fullName': userWithImage.fullName ?? 'Unknown User',
              'profileImage': userWithImage.pfp ?? 'assets/images/icons/person.jpg',
              'bio': userWithImage.bio ?? '',
            };
          }
        }
      }

      // 3. Get current user data
      dynamic currentUser;
      if (userId != -1) {
        final user = await _userRepo.getById(userId);
        if (user != null) {
          final profileImagePath = await _getValidProfileImagePath(userId, user.pfp);
          final userWithImage = user.copyWith(pfp: profileImagePath);
          
          currentUser = {
            'id': userWithImage.userId,
            'username': userWithImage.username ?? 'Unknown',
            'fullName': userWithImage.fullName ?? 'Unknown User',
            'profileImage': userWithImage.pfp ?? 'assets/images/icons/person.jpg',
            'bio': userWithImage.bio ?? '',
          };
        }
      }

      // 4. Convert comments to format expected by UI
      final List<Map<String, dynamic>> parsedComments = comments.map((comment) {
        return {
          'id': comment.commentId,
          'userId': comment.userId,
          'text': comment.content ?? '',
          'createdAt': comment.date ?? DateTime.now().toIso8601String(),
        };
      }).toList();

      emit(
        CommentsLoaded(
          comments: parsedComments,
          currentUser: currentUser,
          usersMap: usersMap,
          userId: userId,
        ),
      );
    } catch (e) {
      // Fallback to empty state if error occurs
      emit(
        CommentsLoaded(
          comments: [],
          currentUser: null,
          usersMap: {},
          userId: userId,
        ),
      );
    }
  }

  Future<void> addComment(String text) async {
    if (text.trim().isEmpty) return;
    if (state is! CommentsLoaded) return;

    final s = state as CommentsLoaded;

    try {
      // 1. Create new comment in database
      final newComment = CommentModel(
        postId: postId,
        userId: userId,
        content: text.trim(),
        date: DateTime.now().toIso8601String(),
      );

      // 2. Insert into database
      await _commentRepo.insert(newComment);

      // 3. Get the newly created comment (we might need the ID)
      final allComments = await _commentRepo.getByPostId(postId);
      
      // 4. Get the latest comment (should be the one we just added)
      CommentModel? latestComment;
      if (allComments.isNotEmpty) {
        allComments.sort((a, b) {
          final dateA = DateTime.parse(a.date ?? '2000-01-01');
          final dateB = DateTime.parse(b.date ?? '2000-01-01');
          return dateB.compareTo(dateA); // Newest first
        });
        latestComment = allComments.first;
      }

      // 5. Add user data for new comment if not already in map
      final updatedUsersMap = Map<int, dynamic>.from(s.usersMap);
      if (latestComment?.userId != null && !updatedUsersMap.containsKey(latestComment!.userId)) {
        final user = await _userRepo.getById(latestComment.userId!);
        if (user != null) {
          final profileImagePath = await _getValidProfileImagePath(latestComment.userId!, user.pfp);
          final userWithImage = user.copyWith(pfp: profileImagePath);
          
          updatedUsersMap[latestComment.userId!] = {
            'id': userWithImage.userId,
            'username': userWithImage.username ?? 'Unknown',
            'fullName': userWithImage.fullName ?? 'Unknown User',
            'profileImage': userWithImage.pfp ?? 'assets/images/icons/person.jpg',
            'bio': userWithImage.bio ?? '',
          };
        }
      }

      // 6. Convert all comments to UI format, sorted by date
      allComments.sort((a, b) {
        final dateA = DateTime.parse(a.date ?? '2000-01-01');
        final dateB = DateTime.parse(b.date ?? '2000-01-01');
        return dateA.compareTo(dateB); // Oldest first for display
      });

      final parsedComments = allComments.map((comment) {
        return {
          'id': comment.commentId,
          'userId': comment.userId,
          'text': comment.content ?? '',
          'createdAt': comment.date ?? DateTime.now().toIso8601String(),
        };
      }).toList();

      emit(
        s.copyWith(
          comments: parsedComments,
          usersMap: updatedUsersMap,
        ),
      );
    } catch (e) {
      // You might want to show an error message here
      print('Error adding comment: $e');
    }
  }

  /// Helper method to get valid profile image path
  Future<String> _getValidProfileImagePath(int userId, String? pfpPath) async {
    if (pfpPath != null && pfpPath.isNotEmpty) {
      if (pfpPath.startsWith('assets/')) {
        return pfpPath;
      }
      
      final file = File(pfpPath);
      final fileExists = await file.exists();
      if (fileExists) {
        return pfpPath;
      }
    }
    
    final userProfilePath = await UserProfileService.getUserProfileImagePath(userId);
    if (userProfilePath != null) {
      return userProfilePath;
    }
    
    return 'assets/images/icons/person.jpg';
  }
}