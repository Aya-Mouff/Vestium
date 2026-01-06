import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class PostRepo {
  Future<List<PostModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('posts');
    return res.map((m) => PostModel.fromMap(m)).toList();
  }

  Future<List<PostModel>> getByOutfitId(int outfitId) async {
    final db = await DBHelper.getDatabase();
    final res =
        await db.query('posts', where: 'outfit_id = ?', whereArgs: [outfitId]);
    return res.map((m) => PostModel.fromMap(m)).toList();
  }

  /// Get posts by user ID
  /// Includes both:
  /// 1. Posts with outfits (linked through outfit's user_id)
  /// 2. Gallery posts (posts with user_id but no outfit_id)
  Future<List<PostModel>> getByUserId(int userId) async {
    final db = await DBHelper.getDatabase();

    // Get posts in two ways:
    // 1. Posts that have user_id directly (gallery posts)
    // 2. Posts linked through outfits (outfit posts)
    final result = await db.rawQuery('''
      SELECT DISTINCT p.* FROM posts p
      LEFT JOIN outfits o ON p.outfit_id = o.outfit_id
      WHERE p.user_id = ? OR o.user_id = ?
      ORDER BY p.date DESC
    ''', [userId, userId]);

    print('📊 Found ${result.length} posts for user $userId');
    
    return result.map((m) => PostModel.fromMap(m)).toList();
  }

  /// Insert a post and return its new ID
  Future<int> insert(PostModel post) async {
    final db = await DBHelper.getDatabase();
    final id = await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('✅ Post inserted with id: $id, outfitId: ${post.outfitId}, userId: ${post.userId}, imagePath: ${post.imagePath}');
    return id;
  }

  Future<bool> update(int id, PostModel post) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'posts',
      post.toMap(),
      where: 'post_id = ?',
      whereArgs: [id],
    );
    print('✅ Post updated: $id');
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('posts', where: 'post_id = ?', whereArgs: [id]);
    print('🗑️ Post deleted: $id');
    return true;
  }

  Future<List<PostModel>> getByPostId(int postId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'posts',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return res.map((m) => PostModel.fromMap(m)).toList();
  }
}

// ---------------------------------------------------------------------------

// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';
// import '../services/sync_manager.dart'; // ADD THIS

// class PostRepo {
//   final SyncManager _syncManager = SyncManager(); // ADD THIS
  
//   Future<List<PostModel>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('posts');
//     return res.map((m) => PostModel.fromMap(m)).toList();
//   }

//   Future<List<PostModel>> getByOutfitId(int outfitId) async {
//     final db = await DBHelper.getDatabase();
//     final res =
//         await db.query('posts', where: 'outfit_id = ?', whereArgs: [outfitId]);
//     return res.map((m) => PostModel.fromMap(m)).toList();
//   }

//   Future<List<PostModel>> getByUserId(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final result = await db.rawQuery('''
//       SELECT DISTINCT p.* FROM posts p
//       LEFT JOIN outfits o ON p.outfit_id = o.outfit_id
//       WHERE p.user_id = ? OR o.user_id = ?
//       ORDER BY p.date DESC
//     ''', [userId, userId]);

//     print('📊 Found ${result.length} posts for user $userId');
    
//     return result.map((m) => PostModel.fromMap(m)).toList();
//   }

//   Future<int> insert(PostModel post) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Save locally
//     final id = await db.insert(
//       'posts',
//       post.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
    
//     // 2. Queue for sync
//     final postWithId = PostModel(
//       postId: id,
//       userId: post.userId,
//       outfitId: post.outfitId,
//       imagePath: post.imagePath,
//       caption: post.caption,
//       date: post.date,
//     );
    
//     await _syncManager.queuePostOperation(
//       action: 'create',
//       data: postWithId.toMap(),
//       entityId: id,
//     );
    
//     print('✅ Post inserted with id: $id, outfitId: ${post.outfitId}, userId: ${post.userId}, imagePath: ${post.imagePath}');
//     return id;
//   }

//   Future<bool> update(int id, PostModel post) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Update locally
//     await db.update(
//       'posts',
//       post.toMap(),
//       where: 'post_id = ?',
//       whereArgs: [id],
//     );
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queuePostOperation(
//         action: 'update',
//         data: post.toMap(),
//         entityId: id,
//       );
//     }
    
//     print('✅ Post updated: $id');
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Delete locally
//     await db.delete('posts', where: 'post_id = ?', whereArgs: [id]);
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queuePostOperation(
//         action: 'delete',
//         data: {'post_id': id},
//         entityId: id,
//       );
//     }
    
//     print('🗑️ Post deleted: $id');
//     return true;
//   }

//   Future<List<PostModel>> getByPostId(int postId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'posts',
//       where: 'post_id = ?',
//       whereArgs: [postId],
//     );
//     return res.map((m) => PostModel.fromMap(m)).toList();
//   }
// }