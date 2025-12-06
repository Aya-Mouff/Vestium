// home_screen_cubit.dart - Complete version with all methods
import 'dart:math';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../repo/user_repo.dart';
import 'home_screen_state.dart';
import '../../../../databases/services/feed_service.dart';
import '../../../../databases/services/current_user_service.dart';
import '../../../../databases/db_models.dart';
import '../../../../databases/services/post_image_service.dart';
import '../../../../repo/post_repo.dart';
import '../../../../repo/follow_repo.dart';
import '../../../../repo/like_repo.dart';
import '../../../../repo/comment_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepo userRepo = UserRepo();
  final FeedService _feedService = FeedService();
  
  // For new post buffer
  final List<Map<String, dynamic>> _newPostsBuffer = [];
  bool _hasNewPosts = false;
  
  // Pagination state
  int _currentOffset = 0;
  final int _postsPerPage = 10;
  bool _isLoadingMore = false;
  bool _hasMorePosts = true;

  HomeCubit() : super(HomeLoading()) {
    loadPosts();
  }

  /// Getter for new posts buffer state
  bool get hasNewPosts => _hasNewPosts;
  
  /// Getter for new posts buffer
  List<Map<String, dynamic>> get newPostsBuffer => _newPostsBuffer;
  
  /// Getter for loading more state
  bool get isLoadingMore => _isLoadingMore;
  
  /// Getter for has more posts
  bool get hasMore => _hasMorePosts;

  /// Clear new posts buffer
  void clearNewPostsBuffer() {
    _newPostsBuffer.clear();
    _hasNewPosts = false;
    
    // Update state if currently in loaded state
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(HomeLoaded(
        posts: currentState.posts,
        currentUser: currentState.currentUser,
        hasMorePosts: currentState.hasMorePosts,
      ));
    }
  }

  /// Load user data from database by userId
  Future<void> loadUserData(int userId) async {
    try {
      final user = await userRepo.getById(userId);
      if (user != null) {
        emit(HomeUserLoaded(user: user));
      } else {
        emit(HomeError(message: 'User not logged in'));
      }
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> loadPosts() async {
    try {
      emit(HomeLoading());
      
      // Get current user
      final currentUserId = CurrentUserService.currentUserId;
      if (currentUserId == null) {
        emit(HomeError(message: 'User not logged in'));
        return;
      }
      
      // Reset pagination
      _currentOffset = 0;
      _hasMorePosts = true;
      
      // Load posts from database
      final postsWithCounts = await _feedService.getFeedPosts(
        currentUserId: currentUserId,
        limit: _postsPerPage,
        offset: _currentOffset,
      );
      
      // Update offset
      _currentOffset += postsWithCounts.length;
      
      // Check if there are more posts
      _hasMorePosts = await _feedService.hasMorePosts(
        currentUserId: currentUserId,
        currentOffset: _currentOffset,
      );
      
      // Convert to format expected by UI
      final formattedPosts = await _formatPostsForUI(postsWithCounts, currentUserId);
      
      // Combine with buffer posts
      final allPosts = [..._newPostsBuffer, ...formattedPosts];
      
      emit(HomeLoaded(
        posts: allPosts,
        hasMorePosts: _hasMorePosts,
      ));
    } catch (e) {
      print('Error loading posts: $e');
      emit(HomeError(message: "Failed to load posts: $e"));
    }
  }

  /// Load more posts for infinite scroll
  Future<void> loadMorePosts() async {
    if (_isLoadingMore || !_hasMorePosts || state is! HomeLoaded) return;
    
    try {
      _isLoadingMore = true;
      
      final currentUserId = CurrentUserService.currentUserId;
      if (currentUserId == null) return;
      
      final currentState = state as HomeLoaded;
      
      // Load more posts
      final postsWithCounts = await _feedService.getFeedPosts(
        currentUserId: currentUserId,
        limit: _postsPerPage,
        offset: _currentOffset,
      );
      
      // Update offset
      _currentOffset += postsWithCounts.length;
      
      // Check if there are more posts
      _hasMorePosts = await _feedService.hasMorePosts(
        currentUserId: currentUserId,
        currentOffset: _currentOffset,
      );
      
      // Convert to format expected by UI
      final newFormattedPosts = await _formatPostsForUI(postsWithCounts, currentUserId);
      
      // Combine with existing posts
      final allPosts = [...currentState.posts, ...newFormattedPosts];
      
      emit(HomeLoaded(
        posts: allPosts,
        hasMorePosts: _hasMorePosts,
        currentUser: currentState.currentUser,
      ));
      
    } catch (e) {
      print('Error loading more posts: $e');
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Refresh posts with some randomness
  Future<void> refreshPosts() async {
    try {
      final currentUserId = CurrentUserService.currentUserId;
      if (currentUserId == null) return;
      
      // Clear buffer when refreshing
      clearNewPostsBuffer();
      
      // Reset pagination
      _currentOffset = 0;
      _hasMorePosts = true;
      
      // Load fresh posts
      final postsWithCounts = await _feedService.getFeedPosts(
        currentUserId: currentUserId,
        limit: _postsPerPage,
        offset: _currentOffset,
        isRefreshing: true,
      );
      
      // Update offset
      _currentOffset += postsWithCounts.length;
      
      // Check if there are more posts
      _hasMorePosts = await _feedService.hasMorePosts(
        currentUserId: currentUserId,
        currentOffset: _currentOffset,
      );
      
      // Mix in some discovery posts
      final mixedPosts = await _mixInDiscoveryPosts(postsWithCounts, currentUserId);
      
      final formattedPosts = await _formatPostsForUI(mixedPosts, currentUserId);
      
      emit(HomeLoaded(
        posts: formattedPosts,
        hasMorePosts: _hasMorePosts,
      ));
    } catch (e) {
      print('Error refreshing posts: $e');
    }
  }

  /// Format posts for UI consumption
  Future<List<Map<String, dynamic>>> _formatPostsForUI(
    List<PostWithCounts> postsWithCounts,
    int currentUserId,
  ) async {
    final formattedPosts = <Map<String, dynamic>>[];
    
    for (final postWithCounts in postsWithCounts) {
      final post = postWithCounts.post;
      
      // Get user info
      final user = await _feedService.getUserForPost(post);
      
      // Get post image URL using PostImageService
      final imageUrl = await _getPostImageUrl(post);
      
      // Get profile image URL
      String profileImage = await _getProfileImageUrl(user);
      
      // Get likedBy list
      final likedBy = postWithCounts.isLikedByCurrentUser ? [currentUserId] : [];
      
      formattedPosts.add({
        'id': post.postId ?? 0,
        'userId': user?.userId ?? 0,
        'username': user?.username ?? 'Unknown',
        'profileImage': profileImage,
        'imageUrl': imageUrl,
        'caption': post.caption ?? '',
        'likesCount': postWithCounts.likesCount,
        'commentsCount': postWithCounts.commentsCount,
        'likedBy': likedBy,
        'isLiked': postWithCounts.isLikedByCurrentUser,
        'date': post.date,
      });
    }
    
    return formattedPosts;
  }

  /// Helper method to get profile image URL
  Future<String> _getProfileImageUrl(User? user) async {
    try {
      if (user == null) {
        return 'assets/images/icons/person.jpg';
      }
      
      // Check if user has a profile picture path
      if (user.pfp != null && user.pfp!.isNotEmpty) {
        // Check if it's a file path
        if (user.pfp!.startsWith('/') || user.pfp!.contains('.')) {
          final file = File(user.pfp!);
          if (await file.exists()) {
            return user.pfp!;
          }
        }
        
        // Check if it's an asset path
        if (user.pfp!.startsWith('assets/')) {
          return user.pfp!;
        }
      }
      
      // Default fallback
      return 'assets/images/icons/person.jpg';
    } catch (e) {
      return 'assets/images/icons/person.jpg';
    }
  }

  /// Helper method to get post image URL
  Future<String> _getPostImageUrl(PostModel post) async {
    try {
      // Try to get from PostImageService first
      if (post.postId != null) {
        final imagePath = await PostImageService.getPostImagePath(post.postId!);
        if (imagePath != null) {
          final file = File(imagePath);
          if (await file.exists()) {
            return imagePath;
          }
        }
      }
      
      // Fallback to imagePath in post
      if (post.imagePath != null && post.imagePath!.isNotEmpty) {
        // Check if it's a file path
        if (post.imagePath!.startsWith('/') || post.imagePath!.contains('.')) {
          final file = File(post.imagePath!);
          if (await file.exists()) {
            return post.imagePath!;
          }
        }
        // Assume it's an asset path
        return post.imagePath!;
      }
      
      return 'assets/images/default_post.png';
    } catch (e) {
      return 'assets/images/default_post.png';
    }
  }

  /// Mix in discovery posts from non-followed users
  Future<List<PostWithCounts>> _mixInDiscoveryPosts(
    List<PostWithCounts> currentPosts,
    int currentUserId,
  ) async {
    try {
      final postRepo = PostRepo();
      final likeRepo = LikeRepo();
      final commentRepo = CommentRepo();
      final followRepo = FollowRepo();
      
      // Get all posts from database
      final allPosts = await postRepo.getAll();
      
      // Get following IDs
      final followingIds = await followRepo.getFollowingIds(currentUserId);
      
      // Filter for discovery posts (not from following and not from current user)
      final discoveryPosts = <PostModel>[];
      for (final post in allPosts) {
        // Get post owner
        final user = await _feedService.getUserForPost(post);
        if (user != null && 
            user.userId != currentUserId && 
            !followingIds.contains(user.userId)) {
          discoveryPosts.add(post);
        }
        
        // Limit to 3 discovery posts
        if (discoveryPosts.length >= 3) break;
      }
      
      // Shuffle discovery posts
      discoveryPosts.shuffle();
      
      // Convert to PostWithCounts
      final discoveryPostsWithCounts = <PostWithCounts>[];
      for (final post in discoveryPosts.take(3)) {
        if (post.postId != null) {
          final likes = await likeRepo.getByPostId(post.postId!);
          final comments = await commentRepo.getByPostId(post.postId!);
          final isLiked = await _feedService.isPostLikedByUser(post.postId!, currentUserId);
          
          discoveryPostsWithCounts.add(PostWithCounts(
            post: post,
            likesCount: likes.length,
            commentsCount: comments.length,
            isLikedByCurrentUser: isLiked,
          ));
        }
      }
      
      // Mix discovery posts into current posts (after first few posts)
      final mixedPosts = List<PostWithCounts>.from(currentPosts);
      final random = Random();
      
      for (final discoveryPost in discoveryPostsWithCounts) {
        if (mixedPosts.length > 3) {
          final insertPosition = random.nextInt(mixedPosts.length - 3) + 3;
          mixedPosts.insert(insertPosition, discoveryPost);
        }
      }
      
      return mixedPosts;
    } catch (e) {
      print('Error mixing discovery posts: $e');
      return currentPosts;
    }
  }

  /// Add a newly created post to buffer
  Future<void> addNewPostToBuffer(Map<String, dynamic> newPost) async {
    _newPostsBuffer.insert(0, newPost); // Insert at beginning
    _hasNewPosts = true;
    
    // Get current user ID for formatting
    final currentUserId = CurrentUserService.currentUserId;
    if (currentUserId == null) return;
    
    // Update state if currently in loaded state
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      
      // Get existing posts without buffer posts
      final existingPosts = currentState.posts
          .where((post) => !_newPostsBuffer.contains(post))
          .toList();
      
      final allPosts = [..._newPostsBuffer, ...existingPosts];
      emit(HomeLoaded(
        posts: allPosts,
        currentUser: currentState.currentUser,
        hasMorePosts: currentState.hasMorePosts,
      ));
    } else {
      // If not loaded yet, just load posts normally
      await loadPosts();
    }
  }

  /// Toggle like on a post
  Future<void> toggleLike(int postId, int currentUserId) async {
    if (state is! HomeLoaded) return;

    final loadedState = state as HomeLoaded;
    final posts = List<Map<String, dynamic>>.from(loadedState.posts);
    
    // Find the post index
    int postIndex = -1;
    for (int i = 0; i < posts.length; i++) {
      if (posts[i]['id'] == postId) {
        postIndex = i;
        break;
      }
    }
    
    if (postIndex >= 0) {
      final post = Map<String, dynamic>.from(posts[postIndex]);
      
      await _feedService.toggleLike(postId, currentUserId);
      
      // Update UI state
      final isLiked = !(post['isLiked'] as bool);
      final likesCount = (post['likesCount'] as int) + (isLiked ? 1 : -1);
      final likedBy = List<int>.from(post['likedBy'] ?? []);
      
      if (isLiked) {
        likedBy.add(currentUserId);
      } else {
        likedBy.remove(currentUserId);
      }
      
      posts[postIndex] = {
        ...post,
        'isLiked': isLiked,
        'likesCount': likesCount,
        'likedBy': likedBy,
      };
      
      emit(HomeLoaded(
        posts: posts, 
        currentUser: loadedState.currentUser,
        hasMorePosts: loadedState.hasMorePosts,
      ));
    }
  }
}