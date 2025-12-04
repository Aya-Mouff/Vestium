
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class ItemCategoryJoinRepo {
  Future<List<ItemCategoryJoin>> getCategoriesForItem(int itemId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'item_categories_join',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    return res.map((m) => ItemCategoryJoin.fromMap(m)).toList();
  }

  Future<List<ItemCategoryJoin>> getItemsForCategory(int categoryId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'item_categories_join',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return res.map((m) => ItemCategoryJoin.fromMap(m)).toList();
  }

  Future<bool> addCategoryToItem(int itemId, int categoryId) async {
    final db = await DBHelper.getDatabase();
    await db.insert(
      'item_categories_join',
      {'item_id': itemId, 'category_id': categoryId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<bool> removeCategoryFromItem(int itemId, int categoryId) async {
    final db = await DBHelper.getDatabase();
    await db.delete(
      'item_categories_join',
      where: 'item_id = ? AND category_id = ?',
      whereArgs: [itemId, categoryId],
    );
    return true;
  }

  Future<bool> removeAllCategoriesFromItem(int itemId) async {
    final db = await DBHelper.getDatabase();
    await db.delete(
      'item_categories_join',
      where: 'item_id = ?',
      whereArgs: [itemId],
    );
    return true;
  }

  Future<bool> updateItemCategories(int itemId, List<int> categoryIds) async {
    final db = await DBHelper.getDatabase();
    
    // Start a transaction
    await db.transaction((txn) async {
      // Remove existing categories
      await txn.delete(
        'item_categories_join',
        where: 'item_id = ?',
        whereArgs: [itemId],
      );
      
      // Add new categories
      for (final categoryId in categoryIds) {
        await txn.insert(
          'item_categories_join',
          {'item_id': itemId, 'category_id': categoryId},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    
    return true;
  }

  Future<bool> itemHasCategory(int itemId, int categoryId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'item_categories_join',
      where: 'item_id = ? AND category_id = ?',
      whereArgs: [itemId, categoryId],
    );
    return res.isNotEmpty;
  }
}
