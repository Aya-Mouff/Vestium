import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/dummy/dummy-data-loader.dart';
import '../../../../repo/user_repo.dart';
import 'home_screen_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepo userRepo = UserRepo();

  HomeCubit() : super(HomeLoading()) {
    loadPosts();
  }

  /// Load user data from database by userId
  Future<void> loadUserData(int userId) async {
    try {
      final user = await userRepo.getById(userId);
      if (user != null) {
        emit(HomeUserLoaded(user: user));
      } else {
        emit(HomeError(message: 'User not found'));
      }
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> loadPosts() async {
    try {
      emit(HomeLoading());
      await Future.delayed(const Duration(milliseconds: 700));
      final data = await DummyDataLoader.loadDummyData();

      final posts = (data['posts'] as List).map((p) {
        final map = Map<String, dynamic>.from(p);
        return {
          ...map,
          'userId': int.tryParse(map['userId'].toString()) ?? 0,
          'id': int.tryParse(map['id'].toString()) ?? 0,
          'likedBy': List<int>.from(map['likedBy'] ?? []),
          'likesCount': int.tryParse(map['likesCount'].toString()) ?? 0,
        };
      }).toList();

      emit(HomeLoaded(posts: posts));
    } catch (e) {
      emit(HomeError(message: "Failed to load posts"));
    }
  }

  void toggleLike(int postIndex, int currentUserId) {
    if (state is! HomeLoaded) return;

    final loadedState = state as HomeLoaded;
    final posts = List<Map<String, dynamic>>.from(loadedState.posts);

    final post = Map<String, dynamic>.from(posts[postIndex]);
    final likedBy = List<int>.from(post['likedBy'] ?? []);

    if (likedBy.contains(currentUserId)) {
      likedBy.remove(currentUserId);
      post['likesCount'] = (post['likesCount'] as int) - 1;
    } else {
      likedBy.add(currentUserId);
      post['likesCount'] = (post['likesCount'] as int) + 1;
    }

    post['likedBy'] = likedBy;
    posts[postIndex] = post;

    emit(HomeLoaded(posts: posts));
  }
}
