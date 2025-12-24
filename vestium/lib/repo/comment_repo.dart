import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class CommentRepo {
  Future<List<CommentModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('comments');
    return res.map((m) => CommentModel.fromMap(m)).toList();
  }

  Future<List<CommentModel>> getByPostId(int postId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('comments', where: 'post_id = ?', whereArgs: [postId]);
    return res.map((m) => CommentModel.fromMap(m)).toList();
  }

  Future<bool> insert(CommentModel c) async {
    final db = await DBHelper.getDatabase();
    await db.insert('comments', c.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(int id, CommentModel c) async {
    final db = await DBHelper.getDatabase();
    await db.update('comments', c.toMap(), where: 'comment_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('comments', where: 'comment_id = ?', whereArgs: [id]);
    return true;
  }
}

// -----------------------------------------------------------------------------

// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';
// import '../services/sync_manager.dart'; // ADD THIS

// class CommentRepo {
//   final SyncManager _syncManager = SyncManager(); // ADD THIS
  
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

//   Future<bool> insert(CommentModel comment) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Save locally
//     await db.insert('comments', comment.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    
//     // 2. Queue for sync
//     await _syncManager.queueCommentOperation(
//       action: 'create',
//       data: comment.toMap(),
//     );
    
//     return true;
//   }

//   Future<bool> update(int id, CommentModel comment) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Update locally
//     await db.update('comments', comment.toMap(), where: 'comment_id = ?', whereArgs: [id]);
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queueCommentOperation(
//         action: 'update',
//         data: comment.toMap(),
//         entityId: id,
//       );
//     }
    
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Delete locally
//     await db.delete('comments', where: 'comment_id = ?', whereArgs: [id]);
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queueCommentOperation(
//         action: 'delete',
//         data: {'comment_id': id},
//         entityId: id,
//       );
//     }
    
//     return true;
//   }
// }