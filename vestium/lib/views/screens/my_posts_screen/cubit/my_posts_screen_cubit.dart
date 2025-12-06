import 'package:flutter_bloc/flutter_bloc.dart';
import 'my_posts_screen_state.dart';
import '../../../../repo/post_repo.dart';
import '../../../../repo/like_repo.dart';
import '../../../../repo/comment_repo.dart'; // Added for comments count
import '../../../../databases/db_models.dart';
import '../../../../databases/services/current_user_service.dart';
import '../../../../databases/services/post_image_service.dart';

class MyPostsScreenCubit extends Cubit<MyPostsScreenState> {
  final PostRepo _postRepo = PostRepo();
  final LikeRepo _likeRepo = LikeRepo();
  final CommentRepo _commentRepo = CommentRepo(); // Added
  
  MyPostsScreenCubit() : super(MyPostsInitial());

  // Load all posts from a specific user based on the clicked post
  Future<void> loadUserPosts(String postId) async {
    emit(MyPostsLoading());

    try {
      // Get the current user ID
      final currentUserId = CurrentUserService.currentUserId;
      if (currentUserId == null) {
        emit(const MyPostsError('User not logged in'));
        return;
      }

      // Get user's posts (current user's posts)
      final userPosts = await _postRepo.getByUserId(currentUserId);
      
      // Convert PostModel list to format needed by UI
      final formattedPosts = await _formatPostsForUI(userPosts);
      
      // Find focused post index
      final focusedIndex = formattedPosts.indexWhere((post) => post['id'] == postId);

      // Load liked posts
      final likedPostIds = await _loadLikedPostsFromDatabase(currentUserId);

      emit(MyPostsLoaded(
        posts: formattedPosts,
        focusedPostIndex: focusedIndex,
        likedPostIds: likedPostIds,
      ));
    } catch (e) {
      emit(MyPostsError('Failed to load posts: $e'));
    }
  }

  // Toggle like status for a post - Optimized version
  Future<void> toggleLike(String postId) async {
    final currentState = state;
    if (currentState is! MyPostsLoaded) return;

    final currentUserId = CurrentUserService.currentUserId;
    if (currentUserId == null) return;

    final postIdInt = int.parse(postId);
    final isCurrentlyLiked = currentState.likedPostIds.contains(postId);
    
    // Get the post index
    final posts = List<Map<String, dynamic>>.from(currentState.posts);
    final postIndex = posts.indexWhere((post) => post['id'] == postId);
    
    if (postIndex == -1) return;
    
    // Create updated posts list with only the changed post
    final updatedPosts = List<Map<String, dynamic>>.from(posts);
    final updatedPost = Map<String, dynamic>.from(updatedPosts[postIndex]);
    
    // Update liked posts set
    final updatedLikedPosts = Set<String>.from(currentState.likedPostIds);
    
    if (isCurrentlyLiked) {
      // Unlike
      updatedPost['likesCount'] = (updatedPost['likesCount'] as int) - 1;
      updatedLikedPosts.remove(postId);
    } else {
      // Like
      updatedPost['likesCount'] = (updatedPost['likesCount'] as int) + 1;
      updatedLikedPosts.add(postId);
    }
    
    // Update only the specific post
    updatedPosts[postIndex] = updatedPost;
    
    // Emit new state with updated posts
    emit(MyPostsLoaded(
      posts: updatedPosts,
      focusedPostIndex: currentState.focusedPostIndex,
      likedPostIds: updatedLikedPosts,
    ));
    
    // Update database in background
    try {
      if (isCurrentlyLiked) {
        await _unlikePostInDatabase(currentUserId, postIdInt);
      } else {
        await _likePostInDatabase(currentUserId, postIdInt);
      }
    } catch (e) {
      print('Error updating like in database: $e');
      // Optionally show error toast, but don't revert UI
    }
  }

  // Delete a post with confirmation
  Future<void> deletePost(String postId) async {
    final currentState = state;
    if (currentState is! MyPostsLoaded) return;

    try {
      // Delete from database
      await _deletePostFromDatabase(int.parse(postId));

      // Delete image file
      await PostImageService.deletePostImageById(int.parse(postId));

      // Update UI state
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

  // --- Database Operations ---

  Future<Set<String>> _loadLikedPostsFromDatabase(int userId) async {
    try {
      final allLikes = await _likeRepo.getAll();
      final userLikes = allLikes.where((like) => like.userId == userId);
      return Set<String>.from(userLikes.map((like) => like.postId.toString()));
    } catch (e) {
      print('Error loading liked posts: $e');
      return {};
    }
  }

  Future<void> _likePostInDatabase(int userId, int postId) async {
    try {
      final like = LikeModel(
        postId: postId,
        userId: userId,
        date: DateTime.now().toIso8601String(),
      );
      await _likeRepo.insert(like);
    } catch (e) {
      print('Error liking post: $e');
      rethrow;
    }
  }

  Future<void> _unlikePostInDatabase(int userId, int postId) async {
    try {
      // Get the like ID first
      final allLikes = await _likeRepo.getAll();
      final userLike = allLikes.firstWhere(
        (like) => like.userId == userId && like.postId == postId,
        orElse: () => LikeModel(),
      );
      
      if (userLike.likeId != null) {
        await _likeRepo.delete(userLike.likeId!);
      }
    } catch (e) {
      print('Error unliking post: $e');
      rethrow;
    }
  }

  Future<void> _deletePostFromDatabase(int postId) async {
    try {
      await _postRepo.delete(postId);
    } catch (e) {
      print('Error deleting post: $e');
      rethrow;
    }
  }

  Future<PostModel?> _getPostById(int postId) async {
    try {
      final posts = await _postRepo.getByPostId(postId);
      return posts.isNotEmpty ? posts.first : null;
    } catch (e) {
      print('Error getting post by ID: $e');
      return null;
    }
  }

  // Get comments count for a post
  Future<int> _getCommentsCount(int postId) async {
    try {
      final comments = await _commentRepo.getByPostId(postId);
      return comments.length;
    } catch (e) {
      print('Error getting comments count: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> _formatPostsForUI(List<PostModel> posts) async {
    final formattedPosts = <Map<String, dynamic>>[];
    
    for (final post in posts) {
      // Get likes count
      final allLikes = await _likeRepo.getAll();
      final postLikes = allLikes.where((like) => like.postId == post.postId);
      final likesCount = postLikes.length;
      
      // Get comments count - FIXED
      final commentsCount = await _getCommentsCount(post.postId!);
      
      // Get image path
      final imagePath = await PostImageService.getPostImagePath(post.postId!);
      
      // Get current user info
      final currentUser = CurrentUserService.currentUser;
      
      // Format post for UI
      formattedPosts.add({
        'id': post.postId.toString(),
        'postId': post.postId, // Add actual postId for navigation
        'userId': post.userId ?? currentUser?.userId ?? 1,
        'username': currentUser?.username ?? 'User',
        'profileImage': currentUser?.pfp ?? 'assets/images/icons/person.jpg',
        'imageUrl': imagePath ?? 'assets/default_post.png',
        'caption': post.caption ?? '',
        'likesCount': likesCount,
        'commentsCount': commentsCount,
        'date': post.date ?? DateTime.now().toIso8601String(),
      });
    }
    
    // Sort by date (newest first)
    formattedPosts.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
    
    return formattedPosts;
  }
}   