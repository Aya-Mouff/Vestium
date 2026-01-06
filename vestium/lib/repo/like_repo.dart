import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class LikeRepo {
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

  Future<bool> insert(LikeModel like) async {
    final db = await DBHelper.getDatabase();
    await db.insert('likes', like.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(int id, LikeModel like) async {
    final db = await DBHelper.getDatabase();
    await db.update('likes', like.toMap(), where: 'like_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('likes', where: 'like_id = ?', whereArgs: [id]);
    return true;
  }
}

// -----------------------------------------------------------------

// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';
// import '../services/sync_manager.dart'; // ADD THIS

// class LikeRepo {
//   final SyncManager _syncManager = SyncManager(); // ADD THIS
  
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
    
//     // 1. Save locally
//     await db.insert('likes', like.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    
//     // 2. Queue for sync
//     await _syncManager.queueLikeOperation(
//       action: 'create',
//       data: like.toMap(),
//     );
    
//     return true;
//   }

//   Future<bool> update(int id, LikeModel like) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Update locally
//     await db.update('likes', like.toMap(), where: 'like_id = ?', whereArgs: [id]);
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queueLikeOperation(
//         action: 'update',
//         data: like.toMap(),
//         entityId: id,
//       );
//     }
    
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Delete locally
//     await db.delete('likes', where: 'like_id = ?', whereArgs: [id]);
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queueLikeOperation(
//         action: 'delete',
//         data: {'like_id': id},
//         entityId: id,
//       );
//     }
    
//     return true;
//   }
// }
