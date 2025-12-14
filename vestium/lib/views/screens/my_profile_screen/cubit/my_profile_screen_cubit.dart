import 'package:bloc/bloc.dart';
import 'my_profile_screen_state.dart';
import '../../../../repo/user_repo.dart';
import '../../../../repo/outfit_repo.dart';
import '../../../../repo/post_repo.dart';
import '../../../../repo/follow_repo.dart';
import '../../../../databases/services/outfit_category_service.dart';
import '../../../../databases/services/user_profile_service.dart';
import '../../../../databases/services/outfit_image_service.dart';
import '../../../../databases/services/post_image_service.dart';
import 'dart:io';

class MyProfileCubit extends Cubit<MyProfileState> {
  final UserRepo userRepo = UserRepo();
  final OutfitRepo outfitRepo = OutfitRepo();
  final PostRepo postRepo = PostRepo();
  final FollowRepo followRepo = FollowRepo();
  final OutfitCategoryService outfitCategoryService = OutfitCategoryService();

  MyProfileCubit() : super(MyProfileInitial());

  Future<void> loadUserData(int userId) async {
    if (userId == -1) {
      emit(MyProfileAccessDenied());
      return;
    }

    emit(MyProfileLoading());

    try {
      // Fetch user from database
      final user = await userRepo.getById(userId);
      if (user == null) {
        emit(MyProfileError(message: 'User not found'));
        return;
      }

      // Get followers and following counts
      final followersCount = await followRepo.getFollowersCount(userId);
      final followingCount = await followRepo.getFollowingCount(userId);

      // Get user's outfits
      final userOutfits = await outfitRepo.getByUserId(userId);

      // Get user's posts
      final userPosts = await postRepo.getByUserId(userId);

      // Collect outfit categories actually used by this user's outfits
      final userOutfitCategories = <String>{'All'}; // Start with 'All'

      for (final outfit in userOutfits) {
        if (outfit.outfitId != null) {
          final outfitCategories =
              await outfitCategoryService.getCategoriesForOutfit(outfit.outfitId!);

          if (outfitCategories.isNotEmpty) {
            for (final category in outfitCategories) {
              if (category.categoryName != null &&
                  category.categoryName!.isNotEmpty) {
                userOutfitCategories.add(category.categoryName!);
              }
            }
          } else {
            userOutfitCategories.add('Uncategorized');
          }
        }
      }

      // Get the valid profile image path
      final profileImagePath =
          await _getValidProfileImagePath(userId, user.pfp);

      // Convert User model to Map for compatibility with existing UI
      final currentUserMap = {
        'id': user.userId,
        'username': user.username ?? 'Unknown User',
        'fullName': user.fullName ?? 'Unknown',
        'bio': user.bio ?? '',
        'pfp': profileImagePath,
        'followersCount': followersCount,
        'followingCount': followingCount,
        'customOutfitCategories': userOutfitCategories.toList(),
      };

      // Convert outfits to format expected by UI
      final outfitsList =
          await Future.wait(userOutfits.map((outfit) async {
        // Categories for this outfit
        List<String> outfitCategoryNames = [];
        if (outfit.outfitId != null) {
          final outfitCategories =
              await outfitCategoryService.getCategoriesForOutfit(
                  outfit.outfitId!);
          outfitCategoryNames = outfitCategories
              .map((cat) => cat.categoryName ?? 'Uncategorized')
              .where((name) => name.isNotEmpty)
              .toList();
        }

        if (outfitCategoryNames.isEmpty) {
          outfitCategoryNames = ['Uncategorized'];
        }

        // Outfit image path
        final outfitImagePath =
            await OutfitImageService.getOutfitImagePath(outfit.outfitId ?? -1);

        return {
          'id': outfit.outfitId,
          'userId': outfit.userId,
          'name': outfit.outfitName ?? 'Unnamed Outfit',
          'description': outfit.description ?? '',
          'categories': outfitCategoryNames,
          'category':
              outfitCategoryNames.isNotEmpty ? outfitCategoryNames.first : 'Uncategorized',
          'season': outfit.season ?? '',
          'date': outfit.date ?? '',
          'imageUrl': outfitImagePath ??
              'assets/images/dummyData/floral-summer-dress.png',
          'imagePath': outfitImagePath,
        };
      }));

      // Convert posts to format expected by UI
      final postsList =
          await Future.wait(userPosts.map((post) async {
        final postImagePath =
            await PostImageService.getPostImagePath(post.postId ?? -1);

        return {
          'id': post.postId,
          'outfitId': post.outfitId,
          'caption': post.caption ?? '',
          'date': post.date ?? '',
          'imageUrl': postImagePath ??
              post.imagePath ??
              'assets/images/dummyData/floral-summer-dress.png',
          'imagePath': postImagePath ?? post.imagePath,
        };
      }));

      // Categories list with 'All' first
      final categoriesList = userOutfitCategories.toList()
        ..sort((a, b) => a == 'All'
            ? -1
            : b == 'All'
                ? 1
                : a.compareTo(b));

      emit(
        MyProfileLoaded(
          currentUser: currentUserMap,
          outfits: outfitsList,
          filteredOutfits: List.from(outfitsList),
          posts: postsList,
          userOutfitCategories: categoriesList,
          selectedCategory: 'All',
          showOutfits: false,
        ),
      );
    } catch (e) {
      print('Error loading user data: $e');
      emit(MyProfileError(message: e.toString()));
    }
  }

  /// Helper method to get the valid profile image path
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

    final userProfilePath =
        await UserProfileService.getUserProfileImagePath(userId);
    if (userProfilePath != null) {
      return userProfilePath;
    }

    return 'assets/images/icons/person.jpg';
  }

  void toggleView(bool showOutfits) {
    if (state is MyProfileLoaded) {
      final s = state as MyProfileLoaded;
      emit(s.copyWith(showOutfits: showOutfits));
    }
  }

  void filterOutfits(String category) {
    if (state is MyProfileLoaded) {
      final s = state as MyProfileLoaded;
      final filtered = category == 'All'
          ? List.from(s.outfits)
          : s.outfits.where((o) {
              final categories = o['categories'] as List<String>;
              return categories.contains(category);
            }).toList();
      emit(s.copyWith(filteredOutfits: filtered, selectedCategory: category));
    }
  }
}
