import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class OutfitCategoryRepo {
  Future<List<OutfitCategory>> getAll(int userId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'outfit_categories',
      where: 'user_id = ? OR user_id IS NULL',
      whereArgs: [userId],
    );
    return res.map((m) => OutfitCategory.fromMap(m)).toList();
  }

  // Global (no filter) – used only for updateCategory checks
  Future<List<OutfitCategory>> getAllGlobal() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('outfit_categories');
    return res.map((m) => OutfitCategory.fromMap(m)).toList();
  }

  Future<OutfitCategory?> getById(int id) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'outfit_categories',
      where: 'category_id = ?',
      whereArgs: [id],
    );
    if (res.isEmpty) return null;
    return OutfitCategory.fromMap(res.first);
  }

  Future<OutfitCategory?> getByName(String name, {int? userId}) async {
    final db = await DBHelper.getDatabase();

    // If userId provided, check user-specific first, then shared
    if (userId != null) {
      final userRes = await db.query(
        'outfit_categories',
        where: 'category_name = ? AND user_id = ?',
        whereArgs: [name, userId],
      );

      if (userRes.isNotEmpty) {
        return OutfitCategory.fromMap(userRes.first);
      }
    }

    // Check shared categories (NULL user_id)
    final sharedRes = await db.query(
      'outfit_categories',
      where: 'category_name = ? AND user_id IS NULL',
      whereArgs: [name],
    );

    if (sharedRes.isNotEmpty) {
      return OutfitCategory.fromMap(sharedRes.first);
    }

    return null;
  }

  Future<bool> insert(OutfitCategory cat) async {
    final db = await DBHelper.getDatabase();
    await db.insert(
      'outfit_categories',
      cat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<bool> update(int id, OutfitCategory cat) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'outfit_categories',
      cat.toMap(),
      where: 'category_id = ?',
      whereArgs: [id],
    );
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete(
      'outfit_categories',
      where: 'category_id = ?',
      whereArgs: [id],
    );
    return true;
  }
}

// -------------------------------------------------------------------

// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';
// import '../services/sync_manager.dart'; // ADD THIS

// class OutfitCategoryRepo {
//   final SyncManager _syncManager = SyncManager(); // ADD THIS
  
//   Future<List<OutfitCategory>> getAll(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('outfit_categories', where : 'user_id = ?', whereArgs: [userId],);
//     return res.map((m) => OutfitCategory.fromMap(m)).toList();
//   }

//   // Global (no filter) – used only for updateCategory checks
//   Future<List<OutfitCategory>> getAllGlobal() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('outfit_categories');
//     return res.map((m) => OutfitCategory.fromMap(m)).toList();
//   } 
  
//   Future<OutfitCategory?> getById(int id) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'outfit_categories',
//       where: 'category_id = ?',
//       whereArgs: [id],
//     );
//     if (res.isEmpty) return null;
//     return OutfitCategory.fromMap(res.first);
//   }

//   Future<OutfitCategory?> getByName(String name) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'outfit_categories',
//       where: 'category_name = ?',
//       whereArgs: [name],
//     );
//     if (res.isEmpty) return null;
//     return OutfitCategory.fromMap(res.first);
//   }

//   Future<bool> insert(OutfitCategory cat) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Save locally
//     await db.insert('outfit_categories', cat.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    
//     // 2. Queue for sync
//     await _syncManager.queueOutfitCategoryOperation(
//       action: 'create',
//       data: cat.toMap(),
//       entityId: cat.categoryId,
//     );
    
//     return true;
//   }

//   Future<bool> update(int id, OutfitCategory cat) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Update locally
//     await db.update('outfit_categories', cat.toMap(), where: 'category_id = ?', whereArgs: [id]);
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queueOutfitCategoryOperation(
//         action: 'update',
//         data: cat.toMap(),
//         entityId: id,
//       );
//     }
    
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Delete locally
//     await db.delete('outfit_categories', where: 'category_id = ?', whereArgs: [id]);
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queueOutfitCategoryOperation(
//         action: 'delete',
//         data: {'category_id': id},
//         entityId: id,
//       );
//     }
    
//     return true;
//   }
// }