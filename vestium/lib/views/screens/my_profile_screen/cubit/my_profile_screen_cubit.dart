import 'package:bloc/bloc.dart';
import 'my_profile_screen_state.dart';
import '../../../../data/dummy/dummy-data-loader.dart';
import '../../../../repo/user_repo.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final UserRepo userRepo = UserRepo();

  MyProfileCubit() : super(MyProfileInitial());

  Future<void> loadUserData(int userId) async {
    if (userId == -1) {
      emit(MyProfileAccessDenied());
      return;
    }

    emit(MyProfileLoading());

    try {
      // Fetch user from database using userId
      final user = await userRepo.getById(userId);
      if (user == null) {
        emit(MyProfileError(message: 'User not found'));
        return;
      }

      // Convert User model to Map for compatibility with existing UI
      final currentUserMap = {
        'id': user.userId,
        'username': user.username ?? 'Unknown User',
        'fullName': user.fullName ?? 'Unknown',
        'bio': user.bio ?? '',
        'pfp': user.pfp ?? '',
        'followersCount': 0,
        'followingCount': 0,
        'customOutfitCategories': [],
      };

      // Load dummy outfits and posts (in real app, fetch from database)
      final data = await DummyDataLoader.loadDummyData();
      final outfitsData = data['outfits'] as List<dynamic>;
      final postsData = data['posts'] as List<dynamic>;

      final userOutfits = outfitsData
          .where((o) => o['userId'].toString() == userId.toString())
          .toList();
      final userPosts = postsData
          .where((p) => p['userId'].toString() == userId.toString())
          .toList();

      final categoriesFromUserOutfits = userOutfits
          .map<String>((o) => o['category']?.toString() ?? 'Uncategorized')
          .toSet()
          .toList();

      emit(
        MyProfileLoaded(
          currentUser: currentUserMap,
          outfits: userOutfits,
          filteredOutfits: List.from(userOutfits),
          posts: userPosts,
          userOutfitCategories: categoriesFromUserOutfits.isNotEmpty
              ? categoriesFromUserOutfits
              : [],
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
