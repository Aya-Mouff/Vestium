// lib/repo/outfit_repo.dart
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class OutfitRepo {
  Future<List<OutfitModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('outfits');
    return res.map((m) => OutfitModel.fromMap(m)).toList();
  }

  Future<List<OutfitModel>> getByUserId(int userId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'outfits',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return res.map((m) => OutfitModel.fromMap(m)).toList();
  }

  Future<OutfitModel?> getById(int id) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'outfits',
      where: 'outfit_id = ?',
      whereArgs: [id],
    );
    if (res.isEmpty) return null;
    return OutfitModel.fromMap(res.first);
  }

  // Future<bool> insert(OutfitModel outfit) async {
  //   final db = await DBHelper.getDatabase();
  //   await db.insert(
  //     'outfits',
  //     outfit.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   return true;
  // }
  Future<int> insert(OutfitModel outfit) async {
    final db = await DBHelper.getDatabase();
    final id = await db.insert(
      'outfits',
      outfit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('✅ Outfit inserted with id: $id');
    return id;
  }

  Future<bool> update(int id, OutfitModel outfit) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'outfits',
      outfit.toMap(),
      where: 'outfit_id = ?',
      whereArgs: [id],
    );
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('outfits', where: 'outfit_id = ?', whereArgs: [id]);
    return true;
  }

  // In OutfitRepo.dart
  Future<void> updateOutfitImage(int outfitId, String imagePath) async {
    try {
      final db = await DBHelper.getDatabase();
      await db.update(
        'outfits',
        {'image_path': imagePath},
        where: 'outfit_id = ?',
        whereArgs: [outfitId],
      );
      print('📊 Database updated: outfit $outfitId -> image $imagePath');
    } catch (e) {
      print('❌ Error updating outfit image in database: $e');
      rethrow;
    }
  }
}
// ----------------------------------------------------

// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';
// import '../services/sync_manager.dart'; // ADD THIS

// class OutfitRepo {
//   final SyncManager _syncManager = SyncManager(); // ADD THIS
  
//   Future<List<OutfitModel>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('outfits');
//     return res.map((m) => OutfitModel.fromMap(m)).toList();
//   }

//   Future<List<OutfitModel>> getByUserId(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('outfits', where: 'user_id = ?', whereArgs: [userId]);
//     return res.map((m) => OutfitModel.fromMap(m)).toList();
//   }

//   Future<OutfitModel?> getById(int id) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('outfits', where: 'outfit_id = ?', whereArgs: [id]);
//     if (res.isEmpty) return null;
//     return OutfitModel.fromMap(res.first);
//   }

//   Future<int> insert(OutfitModel outfit) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Save locally
//     final id = await db.insert(
//       'outfits',
//       outfit.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
    
//     // 2. Queue for sync
//     final outfitWithId = OutfitModel(
//       outfitId: id,
//       userId: outfit.userId,
//       outfitName: outfit.outfitName,
//       description: outfit.description,
//       season: outfit.season,
//       date: outfit.date,
//     );
    
//     await _syncManager.queueOutfitOperation(
//       action: 'create',
//       data: outfitWithId.toMap(),
//       entityId: id,
//     );
    
//     print('✅ Outfit inserted with id: $id');
//     return id;
//   }

//   Future<bool> update(int id, OutfitModel outfit) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Update locally
//     await db.update(
//       'outfits',
//       outfit.toMap(),
//       where: 'outfit_id = ?',
//       whereArgs: [id],
//     );
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queueOutfitOperation(
//         action: 'update',
//         data: outfit.toMap(),
//         entityId: id,
//       );
//     }
    
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Delete locally
//     await db.delete('outfits', where: 'outfit_id = ?', whereArgs: [id]);
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queueOutfitOperation(
//         action: 'delete',
//         data: {'outfit_id': id},
//         entityId: id,
//       );
//     }
    
//     return true;
//   }
// }
