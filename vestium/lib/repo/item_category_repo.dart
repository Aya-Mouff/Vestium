import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class ItemCategoryRepo {
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

  Future<int> insert(String categoryName) async {
    final db = await DBHelper.getDatabase();
    final id = await db.insert(
      'items_categories',
      {'category_name': categoryName},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<bool> insertCategory(ItemCategory cat) async {
    final db = await DBHelper.getDatabase();
    await db.insert(
      'items_categories', 
      cat.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    return true;
  }

  Future<bool> update(int id, ItemCategory cat) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'items_categories', 
      cat.toMap(), 
      where: 'category_id = ?', 
      whereArgs: [id]
    );
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('items_categories', where: 'category_id = ?', whereArgs: [id]);
    return true;
  }

  Future<List<ItemCategory>> getInitialCategories() async {
    // These are the default categories that every user gets
    return [
      ItemCategory(categoryId: 1, categoryName: 'Tops'),
      ItemCategory(categoryId: 2, categoryName: 'Bottoms'),
      ItemCategory(categoryId: 3, categoryName: 'Dresses'),
      ItemCategory(categoryId: 4, categoryName: 'Outerwear'),
      ItemCategory(categoryId: 5, categoryName: 'Shoes'),
      ItemCategory(categoryId: 6, categoryName: 'Accessories'),
    ];
  }
}

// ------------------------------------------------------------------

// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';
// import '../services/sync_manager.dart'; // ADD THIS

// class ItemCategoryRepo {
//   final SyncManager _syncManager = SyncManager(); // ADD THIS
  
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
    
//     // 1. Save locally
//     final id = await db.insert(
//       'items_categories',
//       {'category_name': categoryName},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
    
//     // 2. Queue for sync
//     final category = ItemCategory(
//       categoryId: id,
//       categoryName: categoryName,
//     );
    
//     await _syncManager.queueItemCategoryOperation(
//       action: 'create',
//       data: category.toMap(),
//       entityId: id,
//     );
    
//     return id;
//   }

//   Future<bool> insertCategory(ItemCategory cat) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Save locally
//     await db.insert(
//       'items_categories', 
//       cat.toMap(), 
//       conflictAlgorithm: ConflictAlgorithm.replace
//     );
    
//     // 2. Queue for sync
//     await _syncManager.queueItemCategoryOperation(
//       action: 'create',
//       data: cat.toMap(),
//       entityId: cat.categoryId,
//     );
    
//     return true;
//   }

//   Future<bool> update(int id, ItemCategory cat) async {
//     final db = await DBHelper.getDatabase();
    
//     // 1. Update locally
//     await db.update(
//       'items_categories', 
//       cat.toMap(), 
//       where: 'category_id = ?', 
//       whereArgs: [id]
//     );
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queueItemCategoryOperation(
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
//     await db.delete('items_categories', where: 'category_id = ?', whereArgs: [id]);
    
//     // 2. Queue for sync (only if it has a backend ID > 1000)
//     if (id > 1000) {
//       await _syncManager.queueItemCategoryOperation(
//         action: 'delete',
//         data: {'category_id': id},
//         entityId: id,
//       );
//     }
    
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