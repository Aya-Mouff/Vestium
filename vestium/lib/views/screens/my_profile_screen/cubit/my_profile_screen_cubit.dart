import 'package:bloc/bloc.dart';
import 'my_profile_screen_state.dart';
import '../../../../repo/user_repo.dart';
import '../../../../repo/outfit_repo.dart';
import '../../../../repo/post_repo.dart';
import '../../../../repo/follow_repo.dart';
import '../../../../repo/outfit_category_repo.dart';
import '../../../../databases/db_models.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final UserRepo userRepo = UserRepo();
  final OutfitRepo outfitRepo = OutfitRepo();
  final PostRepo postRepo = PostRepo();
  final FollowRepo followRepo = FollowRepo();
  final OutfitCategoryRepo outfitCategoryRepo = OutfitCategoryRepo();

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
      
      // Get all outfit categories to find which ones the user has
      final allCategories = await outfitCategoryRepo.getAll();
      final userOutfitCategories = <String>[];
      
      // Extract unique categories from user's outfits
      for (final outfit in userOutfits) {
        if (outfit.categoryId != null) {
          final category = allCategories.firstWhere(
            (cat) => cat.categoryId == outfit.categoryId,
            orElse: () => OutfitCategory(categoryName: 'Uncategorized'),
          );
          final categoryName = category.categoryName ?? 'Uncategorized';
          if (!userOutfitCategories.contains(categoryName)) {
            userOutfitCategories.add(categoryName);
          }
        } else {
          // Add 'Uncategorized' if outfit has no category
          if (!userOutfitCategories.contains('Uncategorized')) {
            userOutfitCategories.add('Uncategorized');
          }
        }
      }

      // Convert User model to Map for compatibility with existing UI
      final currentUserMap = {
        'id': user.userId,
        'username': user.username ?? 'Unknown User',
        'fullName': user.fullName ?? 'Unknown',
        'bio': user.bio ?? '',
        'pfp': user.pfp ?? '',
        'followersCount': followersCount,
        'followingCount': followingCount,
        'customOutfitCategories': userOutfitCategories,
      };

      // Convert outfits to format expected by UI
      final outfitsList = userOutfits.map((outfit) {
        final category = allCategories.firstWhere(
          (cat) => cat.categoryId == outfit.categoryId,
          orElse: () => OutfitCategory(categoryName: 'Uncategorized'),
        );
        
        return {
          'id': outfit.outfitId,
          'userId': outfit.userId,
          'name': outfit.outfitName ?? 'Unnamed Outfit',
          'description': outfit.description ?? '',
          'category': category.categoryName ?? 'Uncategorized',
          'categoryId': outfit.categoryId,
          'season': outfit.season ?? '',
          'date': outfit.date ?? '',
          'imageUrl': 'assets/images/placeholder_outfit.png',
        };
      }).toList();

      // Convert posts to format expected by UI
      final postsList = userPosts.map((post) {
        return {
          'id': post.postId,
          'outfitId': post.outfitId,
          'caption': post.caption ?? '',
          'date': post.date ?? '',
          'imageUrl': post.imagePath ?? 'assets/images/placeholder_post.png',
        };
      }).toList();

      // Ensure 'All' is not in the categories list (it's handled separately in FilterChips)
      final categoriesWithoutAll = userOutfitCategories.where((cat) => cat != 'All').toList();

      emit(
        MyProfileLoaded(
          currentUser: currentUserMap,
          outfits: outfitsList,
          filteredOutfits: List.from(outfitsList),
          posts: postsList,
          userOutfitCategories: categoriesWithoutAll,
          selectedCategory: 'All',
          showOutfits: false,
        ),
      );
    } catch (e) {
      emit(MyProfileError(message: e.toString()));
    }
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
          : s.outfits.where((o) => o['category'] == category).toList();
      emit(s.copyWith(filteredOutfits: filtered, selectedCategory: category));
    }
  }
}