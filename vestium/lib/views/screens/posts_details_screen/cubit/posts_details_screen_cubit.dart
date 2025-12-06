import 'package:bloc/bloc.dart';
import '../../../../repo/user_repo.dart';
import '../../../../repo/post_repo.dart';
import '../../../../repo/like_repo.dart';
import '../../../../repo/follow_repo.dart';
import '../../../../repo/comment_repo.dart';
import '../../../../databases/db_models.dart';
import 'posts_details_screen_state.dart';
import '../../../../databases/services/post_image_service.dart';
import '../../../../databases/services/user_profile_service.dart';

class PostsDetailsCubit extends Cubit<PostsDetailsState> {
  final UserRepo _userRepo = UserRepo();
  final PostRepo _postRepo = PostRepo();
  final LikeRepo _likeRepo = LikeRepo();
  final FollowRepo _followRepo = FollowRepo();
  final CommentRepo _commentRepo = CommentRepo();

  PostsDetailsCubit() : super(PostsDetailsInitial());

  Future<void> loadPosts({
    required int userId,
    required int postId,
    required int currentUserId,
  }) async {
    emit(PostsDetailsLoading());

    try {
      // Get user information
      final user = await _userRepo.getById(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Get user's posts from database
      final List<PostModel> userPosts = await _postRepo.getByUserId(userId);

      // Convert PostModel to Map<String, dynamic> with counts
      final posts = await Future.wait(userPosts.map((post) async {
        // Get likes count for this post
        final likes = await _likeRepo.getByPostId(post.postId!);
        final likesCount = likes.length;

        // Check if current user liked this post
        final isLikedByCurrentUser = likes.any((like) => like.userId == currentUserId);

        // Get comments count for this post
        final comments = await _commentRepo.getByPostId(post.postId!);
        final commentsCount = comments.length;

        // Get likedBy user IDs for this post
        final likedBy = likes.map((like) => like.userId!).toList();

        // Get post image path from PostImageService
        String? postImagePath;
        if (post.postId != null) {
          postImagePath = await PostImageService.getPostImagePath(post.postId!);
        }

        // Get user profile image path from UserProfileService
        String? userProfileImagePath;
        if (user.userId != null) {
          userProfileImagePath = await UserProfileService.getUserProfileImagePath(user.userId!);
        }

        return {
          'id': post.postId,
          'userId': post.userId ?? userId, // Use post.userId if available, otherwise use parameter
          'username': user.username ?? 'Unknown User',
          'profileImage': userProfileImagePath ?? 'assets/images/icons/person.jpg',
          'imageUrl': postImagePath ?? 'assets/images/default_post.png',
          'caption': post.caption ?? '',
          'likesCount': likesCount,
          'commentsCount': commentsCount,
          'likedBy': likedBy,
          'outfitId': post.outfitId,
          'date': post.date ?? DateTime.now().toIso8601String(),
        };
      }));

      // Sort posts by date (newest first)
      posts.sort((a, b) {
        // Safely get date strings, ensuring they're Strings
        final dateAStr = (a['date'] as String?) ?? '';
        final dateBStr = (b['date'] as String?) ?? '';
        
        final dateA = DateTime.tryParse(dateAStr) ?? DateTime(2000);
        final dateB = DateTime.tryParse(dateBStr) ?? DateTime(2000);
        return dateB.compareTo(dateA);
      });

      // Find initial index (the post that was clicked)
      final initialIndex = posts.indexWhere((p) => p['id'] == postId);
      if (initialIndex == -1 && posts.isNotEmpty) {
        // If the clicked post isn't found (maybe deleted), show first post
        emit(PostsDetailsLoaded(posts: posts, initialIndex: 0));
      } else {
        emit(PostsDetailsLoaded(posts: posts, initialIndex: initialIndex));
      }

    } catch (e) {
      print('❌ Error loading posts: $e');
      // Fallback to empty state
      emit(PostsDetailsLoaded(posts: [], initialIndex: 0));
    }
  }

  void toggleLike(int postIndex, int currentUserId) async {
    if (state is! PostsDetailsLoaded) return;
    if (currentUserId == -1) return;

    final loadedState = state as PostsDetailsLoaded;
    final post = Map<String, dynamic>.from(loadedState.posts[postIndex]);
    final postId = post['id'] as int;
    final likedBy = List<int>.from(post['likedBy'] ?? []);

    try {
      if (likedBy.contains(currentUserId)) {
        // Unlike: Remove like from database
        await _removeLikeFromDatabase(postId, currentUserId);
        likedBy.remove(currentUserId);
        post['likesCount'] = (post['likesCount'] as int) - 1;
      } else {
        // Like: Add like to database
        await _addLikeToDatabase(postId, currentUserId);
        likedBy.add(currentUserId);
        post['likesCount'] = (post['likesCount'] as int) + 1;
      }

      post['likedBy'] = likedBy;

      // Update the posts list
      final posts = List<Map<String, dynamic>>.from(loadedState.posts);
      posts[postIndex] = post;

      emit(PostsDetailsLoaded(posts: posts, initialIndex: loadedState.initialIndex));

    } catch (e) {
      print('❌ Error toggling like: $e');
      // Revert to original state on error
      emit(PostsDetailsLoaded(posts: loadedState.posts, initialIndex: loadedState.initialIndex));
    }
  }

  Future<void> _addLikeToDatabase(int postId, int userId) async {
    try {
      final like = LikeModel(
        postId: postId,
        userId: userId,
        date: DateTime.now().toIso8601String(),
      );
      await _likeRepo.insert(like);
      print('✅ Like added: post $postId, user $userId');
    } catch (e) {
      print('❌ Error adding like to database: $e');
      rethrow;
    }
  }

  Future<void> _removeLikeFromDatabase(int postId, int userId) async {
    try {
      // Get all likes for this post
      final likes = await _likeRepo.getByPostId(postId);
      
      // Find the like from this user
      final userLike = likes.firstWhere(
        (like) => like.userId == userId && like.postId == postId,
        orElse: () => LikeModel(),
      );
      
      if (userLike.likeId != null) {
        await _likeRepo.delete(userLike.likeId!);
        print('✅ Like removed: post $postId, user $userId');
      }
    } catch (e) {
      print('❌ Error removing like from database: $e');
      rethrow;
    }
  }
}