import '../db_helper.dart';
import '../db_models.dart';
import '../../repo/post_repo.dart';
import '../../repo/follow_repo.dart';
import '../../repo/like_repo.dart';
import '../../repo/comment_repo.dart';
import 'post_image_service.dart';
//import 'dart:io';

class FeedService {
  final PostRepo _postRepo = PostRepo();
  final FollowRepo _followRepo = FollowRepo();
  final LikeRepo _likeRepo = LikeRepo();
  final CommentRepo _commentRepo = CommentRepo();


  // static Future<String?> _getPostImageUrl(PostModel post) async {
  //   try {
  //     // First, try to get from PostImageService by postId
  //     if (post.postId != null) {
  //       final imagePath = await PostImageService.getPostImagePath(post.postId!);
  //       if (imagePath != null && await File(imagePath).exists()) {
  //         return imagePath;
  //       }
  //     }
      
  //     // Fallback to the imagePath in the post (for backward compatibility)
  //     if (post.imagePath != null && post.imagePath!.isNotEmpty) {
  //       // Check if it's a file path or asset path
  //       if (post.imagePath!.startsWith('assets/')) {
  //         return post.imagePath;
  //       } else {
  //         // It might be a file path
  //         final file = File(post.imagePath!);
  //         if (await file.exists()) {
  //           return post.imagePath;
  //         }
  //       }
  //     }
      
  //     return 'assets/images/default_post.png';
  //   } catch (e) {
  //     print('Error getting post image URL: $e');
  //     return 'assets/images/default_post.png';
  //   }
  // }
  /// Get feed posts with priority logic
  // Future<List<PostWithCounts>> getFeedPosts({
  //   required int currentUserId,
  //   int limit = 20,
  //   int offset = 0,
  //   bool isRefreshing = false,
  // }) async {
  //   final db = await DBHelper.getDatabase();
    
  //   // Get following IDs
  //   final followingIds = await _followRepo.getFollowingIds(currentUserId);
  //   final followingIdsStr = followingIds.isNotEmpty 
  //       ? followingIds.join(',')
  //       : '0';
    
  //   // Base query with priority logic
  //   String query = '''
  //     SELECT p.*,
  //       CASE
  //         WHEN o.user_id = ? THEN 1  -- User's own outfit posts
  //         WHEN p.user_id = ? THEN 1  -- User's own gallery posts
  //         WHEN o.user_id IN ($followingIdsStr) THEN 2  -- Following users' outfit posts
  //         WHEN p.user_id IN ($followingIdsStr) THEN 2  -- Following users' gallery posts
  //         ELSE 3  -- Others' posts
  //       END as priority,
  //       RANDOM() as random_factor
  //     FROM posts p
  //     LEFT JOIN outfits o ON p.outfit_id = o.outfit_id
  //     WHERE 1=1
  //   ''';
    
  //   final List<dynamic> params = [currentUserId, currentUserId];
    
  //   // For refreshing, add some randomness to "others" posts
  //   if (isRefreshing) {
  //     query += '''
  //       ORDER BY
  //         priority,
  //         CASE 
  //           WHEN priority = 3 THEN random_factor
  //           ELSE 0
  //         END,
  //         p.date DESC
  //     ''';
  //   } else {
  //     query += ' ORDER BY priority, p.date DESC';
  //   }
    
  //   query += ' LIMIT ? OFFSET ?';
  //   params.addAll([limit, offset]);
    
  //   final result = await db.rawQuery(query, params);
    
  //   // Convert to PostModel and get counts
  //   final postsWithCounts = <PostWithCounts>[];
    
  //   for (final row in result) {
  //     final post = PostModel.fromMap(row);
      
  //     if (post.postId != null) {
  //       final likes = await _likeRepo.getByPostId(post.postId!);
  //       final comments = await _commentRepo.getByPostId(post.postId!);
  //       final isLiked = await _isPostLikedByUser(post.postId!, currentUserId);
        
  //       postsWithCounts.add(PostWithCounts(
  //         post: post,
  //         likesCount: likes.length,
  //         commentsCount: comments.length,
  //         isLikedByCurrentUser: isLiked,
  //       ));
  //     }
  //   }
    
  //   return postsWithCounts;
  // }

  /// Helper method to check if post is liked by user
  Future<bool> _isPostLikedByUser(int postId, int userId) async {
    try {
      final db = await DBHelper.getDatabase();
      final result = await db.query(
        'likes',
        where: 'post_id = ? AND user_id = ?',
        whereArgs: [postId, userId],
      );
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking if post liked: $e');
      return false;
    }
  }

  /// Get user info for post
  // Future<User?> getUserForPost(PostModel post) async {
  //   try {
  //     final db = await DBHelper.getDatabase();
      
  //     // Check if post has outfit
  //     if (post.outfitId != null) {
  //       // Get user from outfit
  //       final result = await db.rawQuery('''
  //         SELECT u.* FROM user u
  //         JOIN outfits o ON u.user_id = o.user_id
  //         WHERE o.outfit_id = ?
  //       ''', [post.outfitId]);
        
  //       if (result.isNotEmpty) {
  //         return User.fromMap(result.first);
  //       }
  //     }
      
  //     // Check if post has direct user_id (gallery post)
  //     if (post.userId != null) {
  //       final result = await db.query(
  //         'user',
  //         where: 'user_id = ?',
  //         whereArgs: [post.userId],
  //       );
        
  //       if (result.isNotEmpty) {
  //         return User.fromMap(result.first);
  //       }
  //     }
      
  //     return null;
  //   } catch (e) {
  //     print('Error getting user for post: $e');
  //     return null;
  //   }
  // }

  // In feed_service.dart, update the getFeedPosts query
  /// Get feed posts with priority logic
  // Future<List<PostWithCounts>> getFeedPosts({
  //   required int currentUserId,
  //   int limit = 20,
  //   int offset = 0,
  //   bool isRefreshing = false,
  // }) async {
  //   final db = await DBHelper.getDatabase();
    
  //   // Get following IDs
  //   final followingIds = await _followRepo.getFollowingIds(currentUserId);
  //   final followingIdsStr = followingIds.isNotEmpty 
  //       ? followingIds.join(',')
  //       : '0';
    
  //   // Base query with priority logic
  //   String query = '''
  //     SELECT 
  //       p.*,
  //       CASE
  //         WHEN o.user_id = ? THEN 1  -- User's own outfit posts
  //         WHEN p.user_id = ? THEN 1  -- User's own gallery posts
  //         WHEN o.user_id IN ($followingIdsStr) THEN 2  -- Following users' outfit posts
  //         WHEN p.user_id IN ($followingIdsStr) THEN 2  -- Following users' gallery posts
  //         ELSE 3  -- Others' posts
  //       END as priority,
  //       RANDOM() as random_factor,
  //       u.username,
  //       u.pfp as user_profile_image
  //     FROM posts p
  //     LEFT JOIN outfits o ON p.outfit_id = o.outfit_id
  //     LEFT JOIN user u ON (o.user_id = u.user_id OR p.user_id = u.user_id)
  //     WHERE 1=1
  //   ''';
    
  //   final List<dynamic> params = [currentUserId, currentUserId];
    
  //   // For refreshing, add some randomness to "others" posts
  //   if (isRefreshing) {
  //     query += '''
  //       ORDER BY
  //         priority,
  //         CASE 
  //           WHEN priority = 3 THEN random_factor
  //           ELSE 0
  //         END,
  //         p.date DESC
  //     ''';
  //   } else {
  //     query += ' ORDER BY priority, p.date DESC';
  //   }
    
  //   query += ' LIMIT ? OFFSET ?';
  //   params.addAll([limit, offset]);
    
  //   final result = await db.rawQuery(query, params);
    
  //   // Convert to PostModel and get counts
  //   final postsWithCounts = <PostWithCounts>[];
    
  //   for (final row in result) {
  //     final post = PostModel.fromMap(row);
      
  //     if (post.postId != null) {
  //       final likes = await _likeRepo.getByPostId(post.postId!);
  //       final comments = await _commentRepo.getByPostId(post.postId!);
  //       final isLiked = await _isPostLikedByUser(post.postId!, currentUserId);
        
  //       postsWithCounts.add(PostWithCounts(
  //         post: post,
  //         likesCount: likes.length,
  //         commentsCount: comments.length,
  //         isLikedByCurrentUser: isLiked,
  //       ));
  //     }
  //   }
    
  //   return postsWithCounts;
  // }

  /// Get user info for post - simplified version
  Future<User?> getUserForPost(PostModel post) async {
    try {
      final db = await DBHelper.getDatabase();
      
      // Try to get user from posts table first (for gallery posts)
      if (post.userId != null) {
        final result = await db.query(
          'user',
          where: 'user_id = ?',
          whereArgs: [post.userId],
        );
        
        if (result.isNotEmpty) {
          return User.fromMap(result.first);
        }
      }
      
      // If no direct user_id, try to get from outfit
      if (post.outfitId != null) {
        final result = await db.rawQuery('''
          SELECT u.* FROM user u
          JOIN outfits o ON u.user_id = o.user_id
          WHERE o.outfit_id = ?
        ''', [post.outfitId]);
        
        if (result.isNotEmpty) {
          return User.fromMap(result.first);
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting user for post: $e');
      return null;
    }
  }

  /// Check if current user liked a post
  Future<bool> isPostLikedByUser(int postId, int userId) async {
    return await _isPostLikedByUser(postId, userId);
  }

  /// Toggle like on a post
  Future<void> toggleLike(int postId, int userId) async {
    try {
      final db = await DBHelper.getDatabase();
      
      // Check if already liked
      final existing = await db.query(
        'likes',
        where: 'post_id = ? AND user_id = ?',
        whereArgs: [postId, userId],
      );
      
      if (existing.isNotEmpty) {
        // Unlike
        await db.delete(
          'likes',
          where: 'post_id = ? AND user_id = ?',
          whereArgs: [postId, userId],
        );
      } else {
        // Like
        await db.insert('likes', {
          'post_id': postId,
          'user_id': userId,
          'date': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Error toggling like: $e');
      rethrow;
    }
  }

  /// Create a new post and return to feed
  // Future<PostModel> createPostAndReturnToFeed({
  //   required int? userId,
  //   required String imagePath,
  //   required String caption,
  //   int? outfitId,
  // }) async {
  //   try {
  //     // Create post
  //     final post = PostModel(
  //       userId: userId,
  //       outfitId: outfitId,
  //       imagePath: imagePath,
  //       caption: caption,
  //       date: DateTime.now().toIso8601String(),
  //     );
      
  //     // Save to database
  //     final postId = await _postRepo.insert(post);
      
  //     // Return the complete post with ID
  //     return post.copyWith(postId: postId);
  //   } catch (e) {
  //     print('Error creating post: $e');
  //     rethrow;
  //   }
  // }
  Future<PostModel> createPostAndReturnToFeed({
    required int? userId,
    required String imagePath,
    required String caption,
    int? outfitId,
  }) async {
    try {
      // First create the post to get an ID
      final post = PostModel(
        userId: userId,
        outfitId: outfitId,
        imagePath: '', // Will update after saving image
        caption: caption,
        date: DateTime.now().toIso8601String(),
      );
      
      // Save to database to get postId
      final postId = await _postRepo.insert(post);
      
      // Now save the image with the postId
      final savedImagePath = await PostImageService.savePostImage(
        imagePath,
        postId: postId,
        userId: userId,
      );
      
      // Update the post with the image path
      final updatedPost = post.copyWith(
        postId: postId,
        imagePath: savedImagePath,
      );
      
      // Update in database
      await _postRepo.update(postId, updatedPost);
      
      print('✅ Post created with ID: $postId, image saved at: $savedImagePath');
      return updatedPost;
    } catch (e) {
      print('Error creating post: $e');
      rethrow;
    }
  }

  Future<List<PostWithCounts>> getFeedPosts({
  required int currentUserId,
  int limit = 10,
  int offset = 0,
  bool isRefreshing = false,
}) async {
  final db = await DBHelper.getDatabase();
  
  // Get following IDs
  final followingIds = await _followRepo.getFollowingIds(currentUserId);
  final followingIdsStr = followingIds.isNotEmpty 
      ? followingIds.join(',')
      : '0';
  
  // NEW LOGIC: Exclude current user's posts, show following first, then others
  String query = '''
    SELECT 
      p.*,
      CASE
        -- Priority 1: Posts from people you follow (excluding yourself)
        WHEN (o.user_id IN ($followingIdsStr) OR p.user_id IN ($followingIdsStr)) 
             AND (o.user_id != ? AND p.user_id != ?) THEN 1
        -- Priority 2: Posts from others (excluding yourself and following)
        ELSE 2
      END as priority
    FROM posts p
    LEFT JOIN outfits o ON p.outfit_id = o.outfit_id
    WHERE 1=1
    -- Exclude current user's posts
    AND (o.user_id != ? OR o.user_id IS NULL)
    AND (p.user_id != ? OR p.user_id IS NULL)
    ORDER BY 
      priority, 
      p.date DESC
    LIMIT ? OFFSET ?
  ''';
  
  final List<dynamic> params = [
    currentUserId, currentUserId,  // For priority calculation
    currentUserId, currentUserId,  // For WHERE clause exclusion
    limit, offset
  ];
  
  print('📊 Loading feed: limit=$limit, offset=$offset, excluding user $currentUserId');
  
  final result = await db.rawQuery(query, params);
  
  // Convert to PostModel and get counts
  final postsWithCounts = <PostWithCounts>[];
  
  for (final row in result) {
    final post = PostModel.fromMap(row);
    
    if (post.postId != null) {
      final likes = await _likeRepo.getByPostId(post.postId!);
      final comments = await _commentRepo.getByPostId(post.postId!);
      final isLiked = await _isPostLikedByUser(post.postId!, currentUserId);
      
      postsWithCounts.add(PostWithCounts(
        post: post,
        likesCount: likes.length,
        commentsCount: comments.length,
        isLikedByCurrentUser: isLiked,
      ));
    }
  }
  
  print('✅ Loaded ${postsWithCounts.length} posts (priority: ${result.map((r) => r['priority']).toList()})');
  return postsWithCounts;
}

/// Check if there are more posts to load
Future<bool> hasMorePosts({
  required int currentUserId,
  int currentOffset = 0,
}) async {
  final db = await DBHelper.getDatabase();
  
  final followingIds = await _followRepo.getFollowingIds(currentUserId);
  final followingIdsStr = followingIds.isNotEmpty 
      ? followingIds.join(',')
      : '0';
  
  final countResult = await db.rawQuery('''
    SELECT COUNT(*) as total
    FROM posts p
    LEFT JOIN outfits o ON p.outfit_id = o.outfit_id
    WHERE 1=1
    AND (o.user_id != ? OR o.user_id IS NULL)
    AND (p.user_id != ? OR p.user_id IS NULL)
  ''', [currentUserId, currentUserId]);
  
  final totalPosts = countResult.first['total'] as int;
  return currentOffset < totalPosts;
}
}
// feed_service.dart - Add pagination and new logic
/// Get feed posts with pagination

