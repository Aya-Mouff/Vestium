// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class ItemCategoryRepo {
//   Future<List<ItemCategory>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('items_categories');
//     return res.map((m) => ItemCategory.fromMap(m)).toList();
//   }

//   Future<ItemCategory?> getById(int id) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'items_categories',
//       where: 'category_id = ?',
//       whereArgs: [id],
//     );
//     if (res.isEmpty) return null;
//     return ItemCategory.fromMap(res.first);
//   }

//   Future<ItemCategory?> getByName(String name) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'items_categories',
//       where: 'category_name = ?',
//       whereArgs: [name],
//     );
//     if (res.isEmpty) return null;
//     return ItemCategory.fromMap(res.first);
//   }

//   Future<int> insert(String categoryName) async {
//     final db = await DBHelper.getDatabase();
//     final id = await db.insert(
//       'items_categories',
//       {'category_name': categoryName},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     return id;
//   }

//   Future<bool> insertCategory(ItemCategory cat) async {
//     final db = await DBHelper.getDatabase();
//     await db.insert(
//       'items_categories', 
//       cat.toMap(), 
//       conflictAlgorithm: ConflictAlgorithm.replace
//     );
//     return true;
//   }

//   Future<bool> update(int id, ItemCategory cat) async {
//     final db = await DBHelper.getDatabase();
//     await db.update(
//       'items_categories', 
//       cat.toMap(), 
//       where: 'category_id = ?', 
//       whereArgs: [id]
//     );
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete('items_categories', where: 'category_id = ?', whereArgs: [id]);
//     return true;
//   }

//   Future<List<ItemCategory>> getInitialCategories() async {
//     // These are the default categories that every user gets
//     return [
//       ItemCategory(categoryId: 1, categoryName: 'Tops'),
//       ItemCategory(categoryId: 2, categoryName: 'Bottoms'),
//       ItemCategory(categoryId: 3, categoryName: 'Dresses'),
//       ItemCategory(categoryId: 4, categoryName: 'Outerwear'),
//       ItemCategory(categoryId: 5, categoryName: 'Shoes'),
//       ItemCategory(categoryId: 6, categoryName: 'Accessories'),
//     ];
//   }
// }

// ------------------------------------------------------------------

// lib/repo/item_category_repo.dart - MINIMAL SYNC ADDITION
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import '../services/sync_manager.dart';

class ItemCategoryRepo {
  static final ItemCategoryRepo _instance = ItemCategoryRepo._internal();
  factory ItemCategoryRepo() => _instance;
  ItemCategoryRepo._internal();
  
  // Add sync manager
  final SyncManager _syncManager = SyncManager();
  
  // KEEP ALL ORIGINAL METHODS EXACTLY AS THEY WERE
  
  Future<List<ItemCategory>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('items_categories');
    return res.map((m) => ItemCategory.fromMap(m)).toList();
  }

  Future<ItemCategory?> getById(int id) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'items_categories',
      where: 'category_id = ?',
      whereArgs: [id],
    );
    if (res.isEmpty) return null;
    return ItemCategory.fromMap(res.first);
  }

  Future<ItemCategory?> getByName(String name) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'items_categories',
      where: 'category_name = ?',
      whereArgs: [name],
    );
    if (res.isEmpty) return null;
    return ItemCategory.fromMap(res.first);
  }

  // MODIFIED: Now returns int (ID) and queues sync
  Future<int> insert(String categoryName) async {
    final db = await DBHelper.getDatabase();
    
    // Check if category already exists
    final existing = await getByName(categoryName);
    if (existing != null) {
      print('⚠️ Category "$categoryName" already exists with ID: ${existing.categoryId}');
      return existing.categoryId!;
    }
    
    // 1. Save to local database (ORIGINAL LOGIC)
    final id = await db.insert(
      'items_categories',
      {'category_name': categoryName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // 2. NEW: Queue for sync (only custom categories, IDs > 6)
    if (id > 6) { // Custom category
      await _queueCategoryOperation(
        action: 'create',
        data: {'category_id': id, 'category_name': categoryName},
        entityId: id,
      );
      print('✅ Custom category created with ID: $id, queued for sync');
    } else {
      print('✅ Default category created with ID: $id (no sync needed)');
    }
    
    return id;
  }

  // KEEP ORIGINAL METHOD NAME but modify for sync
  Future<bool> insertCategory(ItemCategory cat) async {
    if (cat.categoryName == null) return false;
    
    // Use the insert method above (which handles sync)
    final id = await insert(cat.categoryName!);
    return id > 0;
  }

  // MODIFIED: Add sync for updates
  Future<bool> update(int id, ItemCategory cat) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Update local database (ORIGINAL LOGIC)
    await db.update(
      'items_categories', 
      cat.toMap(), 
      where: 'category_id = ?', 
      whereArgs: [id]
    );
    
    // 2. NEW: Queue for sync (only if server ID or default category)
    if (id >= 1000 || id <= 6) {
      await _queueCategoryOperation(
        action: 'update',
        data: cat.toMap(),
        entityId: id,
      );
      print('✅ Category update queued for sync: $id');
    }
    
    return true;
  }

  // MODIFIED: Add sync for deletes
  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    
    // Check if category is in use (NEW LOGIC)
    final inUse = await _isCategoryInUse(id);
    if (inUse) {
      print('❌ Category $id is in use by items, cannot delete');
      return false;
    }
    
    // 1. Delete from local database (ORIGINAL LOGIC)
    await db.delete('items_categories', where: 'category_id = ?', whereArgs: [id]);
    
    // 2. NEW: Queue for sync (only if server ID or default category)
    if (id >= 1000 || id <= 6) {
      await _queueCategoryOperation(
        action: 'delete',
        data: {'category_id': id},
        entityId: id,
      );
      print('✅ Category delete queued for sync: $id');
    }
    
    return true;
  }

  // NEW: Helper method to queue category operations
  Future<void> _queueCategoryOperation({
    required String action,
    required Map<String, dynamic> data,
    int? entityId,
  }) async {
    await _syncManager.queueItemCategoryOperation(
      action: action,
      data: data,
      entityId: entityId,
    );
  }
  
  // NEW: Check if category is being used by items
  Future<bool> _isCategoryInUse(int categoryId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM item_categories_join WHERE category_id = ?',
      [categoryId],
    );
    return (result.first['count'] as int) > 0;
  }

  // KEEP ORIGINAL METHOD
  Future<List<ItemCategory>> getInitialCategories() async {
    return [
      ItemCategory(categoryId: 1, categoryName: 'Tops'),
      ItemCategory(categoryId: 2, categoryName: 'Bottoms'),
      ItemCategory(categoryId: 3, categoryName: 'Dresses'),
      ItemCategory(categoryId: 4, categoryName: 'Outerwear'),
      ItemCategory(categoryId: 5, categoryName: 'Shoes'),
      ItemCategory(categoryId: 6, categoryName: 'Accessories'),
    ];
  }
  
  // NEW: Initialize categories on first app run
  Future<void> ensureDefaultCategoriesExist() async {
    final existing = await getAll();
    if (existing.isEmpty) {
      print('📝 Creating default categories...');
      final defaults = await getInitialCategories();
      
      for (final category in defaults) {
        // Use direct insert to avoid sync for defaults
        final db = await DBHelper.getDatabase();
        await db.insert(
          'items_categories',
          category.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      print('✅ Default categories created');
    }
  }
}