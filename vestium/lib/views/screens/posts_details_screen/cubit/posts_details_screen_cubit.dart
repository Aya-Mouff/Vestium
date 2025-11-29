import 'package:bloc/bloc.dart';
import '../../../../data/dummy/dummy-data-loader.dart';
import 'posts_details_screen_state.dart';

class PostsDetailsCubit extends Cubit<PostsDetailsState> {
  PostsDetailsCubit() : super(PostsDetailsInitial());

  Future<void> loadPosts({
    required int userId,
    required int postId,
    required int currentUserId,
  }) async {
    emit(PostsDetailsLoading());

    final data = await DummyDataLoader.loadDummyData();

    // Convert posts to Map<String, dynamic> and ensure IDs are int
    final posts = (data['posts'] as List)
        .map((p) {
          final map = Map<String, dynamic>.from(p);
          map['userId'] = int.tryParse(map['userId'].toString()) ?? 0;
          map['id'] = int.tryParse(map['id'].toString()) ?? 0;
          map['likesCount'] = map['likesCount'] is int
              ? map['likesCount']
              : int.tryParse(map['likesCount'].toString()) ?? 0;
          map['commentsCount'] = map['commentsCount'] is int
              ? map['commentsCount']
              : int.tryParse(map['commentsCount'].toString()) ?? 0;
          map['likedBy'] = (map['likedBy'] as List?)?.map((e) => int.tryParse(e.toString()) ?? 0).toList() ?? [];
          return map;
        })
        .where((p) => p['userId'] == userId)
        .toList();

    final initialIndex =
        posts.indexWhere((p) => p['id'] == postId);

    emit(PostsDetailsLoaded(posts: posts, initialIndex: initialIndex));
  }

  void toggleLike(int postIndex, int currentUserId) async {
    if (state is! PostsDetailsLoaded) return;

    final loadedState = state as PostsDetailsLoaded;
    final post = Map<String, dynamic>.from(loadedState.posts[postIndex]);
    final likedBy = List<int>.from(post['likedBy'] ?? []);

    if (likedBy.contains(currentUserId)) {
      likedBy.remove(currentUserId);
      post['likesCount'] = (post['likesCount'] as int) - 1;
    } else {
      likedBy.add(currentUserId);
      post['likesCount'] = (post['likesCount'] as int) + 1;
    }

    post['likedBy'] = likedBy;

    await _updatePostLikeInDatabase(post);

    final posts = List<Map<String, dynamic>>.from(loadedState.posts);
    posts[postIndex] = post;

    emit(PostsDetailsLoaded(posts: posts, initialIndex: loadedState.initialIndex));
  }

  Future<void> _updatePostLikeInDatabase(Map<String, dynamic> post) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
