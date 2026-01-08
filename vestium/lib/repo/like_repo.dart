// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class LikeRepo {
//   Future<List<LikeModel>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('likes');
//     return res.map((m) => LikeModel.fromMap(m)).toList();
//   }

//   Future<List<LikeModel>> getByPostId(int postId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('likes', where: 'post_id = ?', whereArgs: [postId]);
//     return res.map((m) => LikeModel.fromMap(m)).toList();
//   }

//   Future<bool> insert(LikeModel like) async {
//     final db = await DBHelper.getDatabase();
//     await db.insert('likes', like.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//     return true;
//   }

//   Future<bool> update(int id, LikeModel like) async {
//     final db = await DBHelper.getDatabase();
//     await db.update('likes', like.toMap(), where: 'like_id = ?', whereArgs: [id]);
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete('likes', where: 'like_id = ?', whereArgs: [id]);
//     return true;
//   }
// }

// -----------------------------------------------------------------

// lib/repo/like_repo.dart - UPDATED WITH SYNC
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import '../services/sync_manager.dart';

class LikeRepo {
  static final LikeRepo _instance = LikeRepo._internal();
  factory LikeRepo() => _instance;
  LikeRepo._internal();
  
  // Add sync manager
  final SyncManager _syncManager = SyncManager();
  
  // KEEP ALL ORIGINAL METHODS
  
  Future<List<LikeModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('likes');
    return res.map((m) => LikeModel.fromMap(m)).toList();
  }

  Future<List<LikeModel>> getByPostId(int postId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('likes', where: 'post_id = ?', whereArgs: [postId]);
    return res.map((m) => LikeModel.fromMap(m)).toList();
  }

  // MODIFIED: Add sync for likes
  Future<bool> insert(LikeModel like) async {
    final db = await DBHelper.getDatabase();
    
    // Check if already liked (prevent duplicates)
    if (like.postId == null || like.userId == null) {
      return false; // Cannot like without postId and userId
    }
    
    final existing = await _getLike(like.postId!, like.userId!);
    if (existing != null) {
      print('⚠️ Already liked post ${like.postId} by user ${like.userId}');
      return true; // Already liked, treat as success
    }
    
    // 1. Save to local database (ORIGINAL LOGIC)
    await db.insert('likes', like.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    
    // 2. NEW: Queue for sync
    await _queueLikeOperation(
      action: 'create',
      data: like.toMap(),
      postId: like.postId,
      userId: like.userId,
    );
    
    print('✅ Liked post ${like.postId}, queued for sync');
    return true;
  }

  // MODIFIED: Add sync for updates (rarely used but kept)
  Future<bool> update(int id, LikeModel like) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Update local database (ORIGINAL LOGIC)
    await db.update('likes', like.toMap(), where: 'like_id = ?', whereArgs: [id]);
    
    // 2. NEW: Queue for sync (only if server ID)
    if (id >= 1000) { // Server ID
      await _queueLikeOperation(
        action: 'update',
        data: like.toMap(),
        entityId: id,
      );
      print('✅ Like update queued for sync: $id');
    }
    
    return true;
  }

  // MODIFIED: Add sync for deletes (unlikes)
  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Get like before deletion (for sync data)
    final like = await _getLikeById(id);
    
    // 2. Delete from local database (ORIGINAL LOGIC)
    await db.delete('likes', where: 'like_id = ?', whereArgs: [id]);
    
    // 3. NEW: Queue for sync (only if server ID)
    if (id >= 1000 && like != null) { // Server ID
      await _queueLikeOperation(
        action: 'delete',
        data: {'like_id': id, 'post_id': like.postId, 'user_id': like.userId},
        entityId: id,
      );
      print('✅ Unlike queued for sync: $id');
    }
    
    return true;
  }
  
  // NEW: Helper method to queue like operations
  Future<void> _queueLikeOperation({
    required String action,
    required Map<String, dynamic> data,
    int? postId,
    int? userId,
    int? entityId,
  }) async {
    await _syncManager.queueLikeOperation(
      action: action,
      data: data,
      entityId: entityId,
    );
  }
  
  // NEW: Get like by post and user
  Future<LikeModel?> _getLike(int postId, int userId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.query(
      'likes',
      where: 'post_id = ? AND user_id = ?',
      whereArgs: [postId, userId],
    );
    
    if (result.isNotEmpty) {
      return LikeModel.fromMap(result.first);
    }
    return null;
  }
  
  // NEW: Get like by ID
  Future<LikeModel?> _getLikeById(int id) async {
    final db = await DBHelper.getDatabase();
    final result = await db.query(
      'likes',
      where: 'like_id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return LikeModel.fromMap(result.first);
    }
    return null;
  }
  
  // NEW: Convenience method to toggle like
  Future<bool> toggleLike(int postId, int userId) async {
    final existing = await _getLike(postId, userId);
    
    if (existing != null) {
      // Unlike
      return await delete(existing.likeId!);
    } else {
      // Like
      final like = LikeModel(
        postId: postId,
        userId: userId,
        date: DateTime.now().toIso8601String(),
      );
      return await insert(like);
    }
  }
  
  // NEW: Check if user liked a post
  Future<bool> isLikedByUser(int postId, int userId) async {
    final like = await _getLike(postId, userId);
    return like != null;
  }
  
  // NEW: Get like count for a post
  Future<int> getLikeCount(int postId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM likes WHERE post_id = ?',
      [postId],
    );
    return result.first['count'] as int;
  }
  
  // NEW: Delete all likes for a post (when post is deleted)
  Future<bool> deleteLikesForPost(int postId) async {
    final db = await DBHelper.getDatabase();
    
    // Get all likes for this post before deletion
    final likes = await getByPostId(postId);
    
    // Delete from local database
    await db.delete('likes', where: 'post_id = ?', whereArgs: [postId]);
    
    // Queue sync for each like (if server IDs)
    for (final like in likes) {
      if (like.likeId != null && like.likeId! >= 1000) {
        await _queueLikeOperation(
          action: 'delete',
          data: {'like_id': like.likeId, 'post_id': postId, 'user_id': like.userId},
          entityId: like.likeId,
        );
      }
    }
    
    print('🗑️ Deleted ${likes.length} likes for post $postId');
    return true;
  }
}