import 'package:bloc/bloc.dart';
import 'my_profile_screen_state.dart';
import '../../../../data/dummy/dummy-data-loader.dart';


class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit() : super(MyProfileInitial());

  Future<void> loadUserData(int userId) async {
    if (userId == -1) {
      emit(MyProfileAccessDenied());
      return;
    }

    emit(MyProfileLoading());

    try {
      final data = await DummyDataLoader.loadDummyData();
      final users = data['users'] as List<dynamic>;
      final outfitsData = data['outfits'] as List<dynamic>;
      final postsData = data['posts'] as List<dynamic>;

      final current = users.firstWhere((u) => u['id'].toString() == userId.toString());
      final userOutfits = outfitsData.where((o) => o['userId'].toString() == userId.toString()).toList();
      final userPosts = postsData.where((p) => p['userId'].toString() == userId.toString()).toList();

      final categoriesFromUserOutfits = userOutfits
          .map<String>((o) => o['category']?.toString() ?? 'Uncategorized')
          .toSet()
          .toList();

      emit(MyProfileLoaded(
        currentUser: current,
        outfits: userOutfits,
        filteredOutfits: List.from(userOutfits),
        posts: userPosts,
        userOutfitCategories: categoriesFromUserOutfits.isNotEmpty
            ? categoriesFromUserOutfits
            : List<String>.from(current['customOutfitCategories'] ?? []),
        selectedCategory: 'All',
        showOutfits: false,
      ));
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
