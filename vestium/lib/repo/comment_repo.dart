// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class CommentRepo {
//   Future<List<CommentModel>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('comments');
//     return res.map((m) => CommentModel.fromMap(m)).toList();
//   }

//   Future<List<CommentModel>> getByPostId(int postId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('comments', where: 'post_id = ?', whereArgs: [postId]);
//     return res.map((m) => CommentModel.fromMap(m)).toList();
//   }

//   Future<bool> insert(CommentModel c) async {
//     final db = await DBHelper.getDatabase();
//     await db.insert('comments', c.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//     return true;
//   }

//   Future<bool> update(int id, CommentModel c) async {
//     final db = await DBHelper.getDatabase();
//     await db.update('comments', c.toMap(), where: 'comment_id = ?', whereArgs: [id]);
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete('comments', where: 'comment_id = ?', whereArgs: [id]);
//     return true;
//   }
// }

// -----------------------------------------------------------------------------

// lib/repo/comment_repo.dart - UPDATED VERSION WITH SYNC
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import '../services/sync_manager.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import 'abstract_repo.dart';

class CommentRepo implements AbstractRepo<CommentModel> {
  static final CommentRepo _instance = CommentRepo._internal();
  factory CommentRepo() => _instance;
  CommentRepo._internal();
  
  // Sync manager instance
  final SyncManager _syncManager = SyncManager();
  
  @override
  String get tableName => 'comments';
  
  @override
  String get primaryKey => 'comment_id';
  
  @override
  Map<String, dynamic> toMap(CommentModel comment) {
    return {
      'comment_id': comment.commentId,
      'post_id': comment.postId,
      'user_id': comment.userId,
      'content': comment.content,
      'date': comment.date,
    };
  }
  
  @override
  CommentModel fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['comment_id'],
      postId: map['post_id'],
      userId: map['user_id'],
      content: map['content'],
      date: map['date'],
    );
  }
  
  // ID helper methods
  @override
  bool isLocalId(int id) => id < 1000;
  
  @override
  bool isServerId(int id) => id >= 1000;
  
  // Core CRUD methods with sync
  
  @override
  Future<List<CommentModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(tableName);
    return res.map((m) => fromMap(m)).toList();
  }

  @override
  Future<CommentModel?> getById(int id) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      tableName,
      where: '$primaryKey = ?',
      whereArgs: [id],
    );
    if (res.isEmpty) return null;
    return fromMap(res.first);
  }

  @override
  Future<int> insert(CommentModel comment) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Save to local database
    final localMap = toMap(comment);
    final localId = await db.insert(
      tableName,
      localMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // 2. Queue for sync
    await queueCreateOperation(comment, localId);
    
    print('✅ Comment inserted with local ID: $localId');
    return localId;
  }

  @override
  Future<bool> update(int id, CommentModel comment) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Update local database
    await db.update(
      tableName,
      toMap(comment),
      where: '$primaryKey = ?',
      whereArgs: [id],
    );
    
    // 2. Queue for sync (only if server ID)
    if (isServerId(id)) {
      await queueUpdateOperation(id, comment);
    }
    
    print('✅ Comment updated: $id');
    return true;
  }

  @override
  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Get comment before deletion (for sync data)
    final comment = await getById(id);
    
    // 2. Delete from local database
    await db.delete(tableName, where: '$primaryKey = ?', whereArgs: [id]);
    
    // 3. Queue for sync (only if server ID)
    if (isServerId(id) && comment != null) {
      await queueDeleteOperation(id);
    }
    
    print('🗑️ Comment deleted: $id');
    return true;
  }

  // Sync queue methods
  
  @override
  Future<void> queueCreateOperation(CommentModel comment, int localId) async {
    final commentWithLocalId = CommentModel(
      commentId: localId,
      postId: comment.postId,
      userId: comment.userId,
      content: comment.content,
      date: comment.date,
    );
    
    await _syncManager.queueCommentOperation(
      action: 'create',
      data: commentWithLocalId.toMap(),
      entityId: localId,
    );
    
    print('✅ Queued comment create: $localId');
  }
  
  @override
  Future<void> queueUpdateOperation(int id, CommentModel comment) async {
    await _syncManager.queueCommentOperation(
      action: 'update',
      data: comment.toMap(),
      entityId: id,
    );
    
    print('✅ Queued comment update: $id');
  }
  
  @override
  Future<void> queueDeleteOperation(int id) async {
    await _syncManager.queueCommentOperation(
      action: 'delete',
      data: {'comment_id': id},
      entityId: id,
    );
    
    print('✅ Queued comment delete: $id');
  }
  
  // Additional custom methods (kept for compatibility)
  
  Future<List<CommentModel>> getByPostId(int postId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      tableName, 
      where: 'post_id = ?', 
      whereArgs: [postId],
      orderBy: 'date DESC',
    );
    return res.map((m) => fromMap(m)).toList();
  }
  
  // Helper method to create comment with current user
  Future<int> createComment({
    required int postId,
    required String content,
    int? userId,
  }) async {
    final currentUserId = userId ?? CurrentUserService.currentUserId;
    if (currentUserId == null) {
      throw Exception('No user logged in');
    }
    
    final comment = CommentModel(
      postId: postId,
      userId: currentUserId,
      content: content,
      date: DateTime.now().toIso8601String(),
    );
    
    return await insert(comment);
  }
  
  // Get comments count for a post
  Future<int> getCommentCount(int postId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM comments WHERE post_id = ?',
      [postId],
    );
    return result.first['count'] as int;
  }
}