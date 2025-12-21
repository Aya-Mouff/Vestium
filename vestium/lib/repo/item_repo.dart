// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class ItemRepo {
//   Future<List<ItemModel>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('items');
//     return res.map((m) => ItemModel.fromMap(m)).toList();
//   }

//   Future<List<ItemModel>> getByUserId(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('items', where: 'user_id = ?', whereArgs: [userId]);
//     return res.map((m) => ItemModel.fromMap(m)).toList();
//   }

//   Future<bool> insert(ItemModel item) async {
//     final db = await DBHelper.getDatabase();
//     await db.insert('items', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//     return true;
//   }

//   Future<bool> update(int id, ItemModel item) async {
//     final db = await DBHelper.getDatabase();
//     await db.update('items', item.toMap(), where: 'item_id = ?', whereArgs: [id]);
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete('items', where: 'item_id = ?', whereArgs: [id]);
//     return true;
//   }
// }

// =================================================================

import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class ItemRepo {
  Future<List<ItemModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('items');
    return res.map((m) => ItemModel.fromMap(m)).toList();
  }

  Future<List<ItemModel>> getByUserId(int userId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'items', 
      where: 'user_id = ?', 
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return res.map((m) => ItemModel.fromMap(m)).toList();
  }

  Future<ItemModel?> getById(int itemId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'items',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    if (res.isEmpty) return null;
    return ItemModel.fromMap(res.first);
  }

  Future<int> insert(ItemModel item) async {
    final db = await DBHelper.getDatabase();
    final id = await db.insert(
      'items', 
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<bool> update(int id, ItemModel item) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'items', 
      item.toMap(), 
      where: 'item_id = ?', 
      whereArgs: [id]
    );
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('items', where: 'item_id = ?', whereArgs: [id]);
    return true;
  }

  Future<List<ItemModel>> getBySeason(String season) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'items',
      where: 'season = ?',
      whereArgs: [season],
    );
    return res.map((m) => ItemModel.fromMap(m)).toList();
  }

  Future<int> insertWithId(ItemModel item) async {
    final db = await DBHelper.getDatabase();
    
    // Check if item with this ID already exists
    final existing = await db.query(
      'items',
      where: 'item_id = ?',
      whereArgs: [item.itemId],
    );
    
    if (existing.isNotEmpty) {
      // Update existing
      await db.update('items', item.toMap(), 
        where: 'item_id = ?', whereArgs: [item.itemId]);
      return item.itemId!;
    } else {
      // Insert new with specific ID
      await db.insert('items', item.toMap());
      return item.itemId!;
    }
  }

  // NEW: Get items that need sync (without backend ID)
  Future<List<ItemModel>> getUnsyncedItems(int userId) async {
    final db = await DBHelper.getDatabase();
    
    // Assuming local-only items have IDs < 1000
    final result = await db.query(
      'items',
      where: 'user_id = ? AND item_id < 1000',
      whereArgs: [userId],
    );
    
    return result.map((m) => ItemModel.fromMap(m)).toList();
  }
}
