import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_posts_screen_state.dart';
import '../../../../data/dummy/dummy-data-loader.dart';

class MyPostsScreenCubit extends Cubit<MyPostsScreenState> {
  MyPostsScreenCubit() : super(MyPostsInitial());

  // Load all posts from a specific user based on the clicked post
  Future<void> loadUserPosts(String postId) async {
    emit(MyPostsLoading());

    try {
      final data = await DummyDataLoader.loadDummyData();
      final allPosts = List<Map<String, dynamic>>.from(data['posts']);

      final clickedPostIndex = allPosts.indexWhere((post) => post['id'] == postId);

      if (clickedPostIndex == -1) {
        emit(const MyPostsError('Post not found'));
        return;
      }

      final clickedPost = allPosts[clickedPostIndex];
      final username = clickedPost['username'];

      final userPosts = allPosts
          .where((post) => post['username'] == username)
          .toList();

      final focusedIndex = userPosts.indexWhere((post) => post['id'] == postId);

      final likedPostIds = await _loadLikedPostsFromDatabase();

      emit(MyPostsLoaded(
        posts: userPosts,
        focusedPostIndex: focusedIndex,
        likedPostIds: likedPostIds,
      ));
    } catch (e) {
      emit(MyPostsError('Failed to load posts: $e'));
    }
  }

  // Toggle like status for a post
  Future<void> toggleLike(String postId) async {
    final currentState = state;
    if (currentState is! MyPostsLoaded) return;

    final isCurrentlyLiked = currentState.likedPostIds.contains(postId);
    
    // Optimistically update UI
    final updatedLikedPosts = Set<String>.from(currentState.likedPostIds);
    final posts = List<Map<String, dynamic>>.from(currentState.posts);

    final postIndex = posts.indexWhere((post) => post['id'] == postId);
    if (postIndex == -1) return;

    final post = Map<String, dynamic>.from(posts[postIndex]);

    if (isCurrentlyLiked) {
      updatedLikedPosts.remove(postId);
      post['likesCount'] = (post['likesCount'] as int) - 1;
    } else {
      updatedLikedPosts.add(postId);
      post['likesCount'] = (post['likesCount'] as int) + 1;
    }

    posts[postIndex] = post;

    emit(currentState.copyWith(
      posts: posts,
      likedPostIds: updatedLikedPosts,
    ));

    // Persist to database
    try {
      if (isCurrentlyLiked) {
        await _unlikePostInDatabase(postId);
      } else {
        await _likePostInDatabase(postId);
      }
    } catch (e) {
      // Revert on error
      emit(currentState);
    }
  }

  // Delete a post with confirmation
  Future<void> deletePost(String postId) async {
    final currentState = state;
    if (currentState is! MyPostsLoaded) return;

    try {
      await _deletePostFromDatabase(postId);

      final updatedPosts = currentState.posts
          .where((post) => post['id'] != postId)
          .toList();

      final updatedLikedPosts = Set<String>.from(currentState.likedPostIds);
      updatedLikedPosts.remove(postId);

      int newFocusedIndex = currentState.focusedPostIndex;
      if (newFocusedIndex >= updatedPosts.length && updatedPosts.isNotEmpty) {
        newFocusedIndex = updatedPosts.length - 1;
      }

      if (updatedPosts.isEmpty) {
        emit(const MyPostsDeleted('All posts deleted'));
      } else {
        emit(MyPostsLoaded(
          posts: updatedPosts,
          focusedPostIndex: newFocusedIndex,
          likedPostIds: updatedLikedPosts,
        ));
      }
    } catch (e) {
      emit(MyPostsError('Failed to delete post: $e'));
      // Restore previous state after showing error
      Future.delayed(const Duration(seconds: 2), () {
        if (state is MyPostsError) {
          emit(currentState);
        }
      });
    }
  }

  // Calculate scroll position for focused post
  double calculateScrollPosition() {
    final currentState = state;
    if (currentState is! MyPostsLoaded) return 0.0;
    
    const double approximateCardHeight = 500.0;
    return currentState.focusedPostIndex * approximateCardHeight;
  }

  // Check if should scroll to focused post
  bool shouldScrollToFocusedPost() {
    final currentState = state;
    if (currentState is! MyPostsLoaded) return false;
    return currentState.focusedPostIndex > 0;
  }

  // Navigate to comments
  String getCommentsRoute(String postId) {
    return '/comments/$postId';
  }

  // --- Database Operations (To be replaced with actual implementations) ---

  Future<Set<String>> _loadLikedPostsFromDatabase() async {
    // TODO: Replace with actual database query
    // Example: return await database.getLikedPostIds(currentUserId);
    await Future.delayed(const Duration(milliseconds: 100));
    return {};
  }

  Future<void> _likePostInDatabase(String postId) async {
    // TODO: Replace with actual database call
    // Example: await database.likePost(currentUserId, postId);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> _unlikePostInDatabase(String postId) async {
    // TODO: Replace with actual database call
    // Example: await database.unlikePost(currentUserId, postId);
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> _deletePostFromDatabase(String postId) async {
    // TODO: Replace with actual database call
    // Example: await database.deletePost(postId);
    await Future.delayed(const Duration(milliseconds: 500));
  }
}