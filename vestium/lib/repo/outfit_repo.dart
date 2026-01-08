// // lib/repo/outfit_repo.dart
// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class OutfitRepo {
//   Future<List<OutfitModel>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('outfits');
//     return res.map((m) => OutfitModel.fromMap(m)).toList();
//   }

//   Future<List<OutfitModel>> getByUserId(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'outfits',
//       where: 'user_id = ?',
//       whereArgs: [userId],
//     );
//     return res.map((m) => OutfitModel.fromMap(m)).toList();
//   }

//   Future<OutfitModel?> getById(int id) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'outfits',
//       where: 'outfit_id = ?',
//       whereArgs: [id],
//     );
//     if (res.isEmpty) return null;
//     return OutfitModel.fromMap(res.first);
//   }

//   // Future<bool> insert(OutfitModel outfit) async {
//   //   final db = await DBHelper.getDatabase();
//   //   await db.insert(
//   //     'outfits',
//   //     outfit.toMap(),
//   //     conflictAlgorithm: ConflictAlgorithm.replace,
//   //   );
//   //   return true;
//   // }
//   Future<int> insert(OutfitModel outfit) async {
//     final db = await DBHelper.getDatabase();
//     final id = await db.insert(
//       'outfits',
//       outfit.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     print('✅ Outfit inserted with id: $id');
//     return id;
//   }

//   Future<bool> update(int id, OutfitModel outfit) async {
//     final db = await DBHelper.getDatabase();
//     await db.update(
//       'outfits',
//       outfit.toMap(),
//       where: 'outfit_id = ?',
//       whereArgs: [id],
//     );
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete('outfits', where: 'outfit_id = ?', whereArgs: [id]);
//     return true;
//   }

//   // In OutfitRepo.dart
//   Future<void> updateOutfitImage(int outfitId, String imagePath) async {
//     try {
//       final db = await DBHelper.getDatabase();
//       await db.update(
//         'outfits',
//         {'image_path': imagePath},
//         where: 'outfit_id = ?',
//         whereArgs: [outfitId],
//       );
//       print('📊 Database updated: outfit $outfitId -> image $imagePath');
//     } catch (e) {
//       print('❌ Error updating outfit image in database: $e');
//       rethrow;
//     }
//   }
// }

// ----------------------------------------------------

// lib/repo/outfit_repo.dart - UPDATED WITH SYNC
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import '../services/sync_manager.dart';
import 'outfit_item_repo.dart';
import 'outfit_category_repo.dart';

class OutfitRepo {
  static final OutfitRepo _instance = OutfitRepo._internal();
  factory OutfitRepo() => _instance;
  OutfitRepo._internal();
  
  final SyncManager _syncManager = SyncManager();
  final OutfitItemRepo _outfitItemRepo = OutfitItemRepo();
  final OutfitCategoryRepo _outfitCategoryRepo = OutfitCategoryRepo();
  
  // KEEP ALL ORIGINAL METHODS
  
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

  // MODIFIED: insert with sync
  Future<int> insert(OutfitModel outfit) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Save outfit to local database (ORIGINAL LOGIC)
    final id = await db.insert(
      'outfits',
      outfit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // Update outfit with the new ID
    final insertedOutfit = outfit.copyWith(outfitId: id);
    
    // 2. NEW: Queue for sync
    await _queueForSync('create', insertedOutfit);
    
    print('✅ Outfit inserted with id: $id, queued for sync');
    return id;
  }

  // NEW: Insert outfit with items and categories
  Future<int> insertWithDetails({
    required OutfitModel outfit,
    required List<int> itemIds,
    required List<String> categories,
    required int userId,
  }) async {
    final db = await DBHelper.getDatabase();
    
    return await db.transaction((txn) async {
      // 1. Insert outfit
      final outfitId = await txn.insert(
        'outfits',
        outfit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      // Update outfit with new ID
      final insertedOutfit = outfit.copyWith(outfitId: outfitId, userId: userId);
      
      // 2. Add items to outfit
      for (final itemId in itemIds) {
        await txn.insert(
          'outfit_item',
          {'outfit_id': outfitId, 'item_id': itemId},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      
      // 3. Add categories to outfit
      for (final categoryName in categories) {
        // Find or create category
        var category = await _outfitCategoryRepo.getByName(categoryName, userId: userId);
        if (category == null) {
          category = OutfitCategory(
            categoryName: categoryName,
            userId: userId,
          );
          await _outfitCategoryRepo.insert(category);
          category = await _outfitCategoryRepo.getByName(categoryName, userId: userId);
        }
        
        if (category != null && category.categoryId != null) {
          await txn.insert(
            'outfit_category_join',
            {'outfit_id': outfitId, 'category_id': category.categoryId},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
      
      // 4. Queue for sync (full outfit with items and categories)
      final syncData = {
        ...insertedOutfit.toMap(),
        'item_ids': itemIds,
        'categories': categories,
      };
      
      // Queue sync if server ID
      if (_isServerId(outfitId)) {
        await _syncManager.queueOutfitOperation(
          action: 'create',
          data: syncData,
          entityId: outfitId,
        );
        print('✅ Outfit with details queued for sync: $outfitId');
      }
      
      return outfitId;
    });
  }

  // MODIFIED: update with sync
  Future<bool> update(int id, OutfitModel outfit) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Update in local database (ORIGINAL LOGIC)
    await db.update(
      'outfits',
      outfit.toMap(),
      where: 'outfit_id = ?',
      whereArgs: [id],
    );
    
    // 2. NEW: Queue for sync (only if server ID)
    if (_isServerId(id)) {
      await _queueForSync('update', outfit.copyWith(outfitId: id));
      print('✅ Outfit update queued for sync: $id');
    } else {
      print('ℹ️ Local outfit update - not queued for sync');
    }
    
    return true;
  }

  // MODIFIED: delete with sync
  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Get outfit before deletion (for sync)
    final outfit = await getById(id);
    
    // 2. Delete from local database (ORIGINAL LOGIC)
    await db.delete('outfits', where: 'outfit_id = ?', whereArgs: [id]);
    
    // 3. NEW: Queue for sync (only if server ID)
    if (_isServerId(id) && outfit != null) {
      await _queueForSync('delete', outfit);
      print('✅ Outfit deletion queued for sync: $id');
    } else if (!_isServerId(id)) {
      print('ℹ️ Local outfit deleted - not queued for sync');
    }
    
    return true;
  }

  // ORIGINAL: updateOutfitImage with sync
  Future<void> updateOutfitImage(int outfitId, String imagePath) async {
    try {
      final db = await DBHelper.getDatabase();
      
      // 1. Update in local database (ORIGINAL LOGIC)
      await db.update(
        'outfits',
        {'image_path': imagePath},
        where: 'outfit_id = ?',
        whereArgs: [outfitId],
      );
      
      // 2. NEW: Queue for sync (only if server ID)
      if (_isServerId(outfitId)) {
        final updateData = {
          'outfit_id': outfitId,
          'image_path': imagePath,
        };
        
        await _syncManager.queueOutfitOperation(
          action: 'update',
          data: updateData,
          entityId: outfitId,
        );
        print('✅ Outfit image update queued for sync: $outfitId');
      } else {
        print('ℹ️ Local outfit image update - not queued for sync');
      }
      
      print('📊 Database updated: outfit $outfitId -> image $imagePath');
    } catch (e) {
      print('❌ Error updating outfit image in database: $e');
      rethrow;
    }
  }
  
  // NEW: Helper method for sync logic
  Future<void> _queueForSync(String action, OutfitModel outfit) async {
    if (outfit.outfitId == null) return;
    
    // Only sync if server ID
    if (_isServerId(outfit.outfitId!)) {
      await _syncManager.queueOutfitOperation(
        action: action,
        data: outfit.toMap(),
        entityId: outfit.outfitId,
      );
    }
  }
  
  // NEW: Check if ID is from server
  bool _isServerId(int id) {
    return id >= 1000;
  }
  
  // NEW: Get outfit with items and categories
  Future<Map<String, dynamic>> getOutfitWithDetails(int outfitId) async {
    final outfit = await getById(outfitId);
    if (outfit == null) {
      throw Exception('Outfit not found');
    }
    
    // Get items in outfit
    final items = await _outfitItemRepo.getByOutfitId(outfitId);
    final itemIds = items.map((oi) => oi.itemId).toList();
    
    // Get categories for outfit
    final categories = await _outfitCategoryRepo.getCategoriesForOutfit(outfitId);
    final categoryNames = categories.map((c) => c.categoryName ?? '').toList();
    
    return {
      'outfit': outfit.toMap(),
      'item_ids': itemIds,
      'categories': categoryNames,
    };
  }
  
  // NEW: Update outfit with items and categories
  Future<bool> updateOutfitWithDetails({
    required int outfitId,
    required OutfitModel outfit,
    required List<int> itemIds,
    required List<String> categories,
    required int userId,
  }) async {
    final db = await DBHelper.getDatabase();
    
    return await db.transaction((txn) async {
      // 1. Update outfit
      await txn.update(
        'outfits',
        outfit.toMap(),
        where: 'outfit_id = ?',
        whereArgs: [outfitId],
      );
      
      // 2. Clear existing items
      await txn.delete('outfit_item', where: 'outfit_id = ?', whereArgs: [outfitId]);
      
      // 3. Add new items
      for (final itemId in itemIds) {
        await txn.insert(
          'outfit_item',
          {'outfit_id': outfitId, 'item_id': itemId},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      
      // 4. Clear existing categories
      await txn.delete('outfit_category_join', where: 'outfit_id = ?', whereArgs: [outfitId]);
      
      // 5. Add new categories
      for (final categoryName in categories) {
        var category = await _outfitCategoryRepo.getByName(categoryName, userId: userId);
        if (category == null) {
          category = OutfitCategory(
            categoryName: categoryName,
            userId: userId,
          );
          await _outfitCategoryRepo.insert(category);
          category = await _outfitCategoryRepo.getByName(categoryName, userId: userId);
        }
        
        if (category != null && category.categoryId != null) {
          await txn.insert(
            'outfit_category_join',
            {'outfit_id': outfitId, 'category_id': category.categoryId},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
      
      // 6. Queue for sync (full outfit with items and categories)
      if (_isServerId(outfitId)) {
        final syncData = {
          ...outfit.toMap(),
          'item_ids': itemIds,
          'categories': categories,
        };
        
        await _syncManager.queueOutfitOperation(
          action: 'update',
          data: syncData,
          entityId: outfitId,
        );
        print('✅ Outfit with details update queued for sync: $outfitId');
      }
      
      return true;
    });
  }
}