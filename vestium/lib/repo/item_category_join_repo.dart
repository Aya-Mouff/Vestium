
// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class ItemCategoryJoinRepo {
//   Future<List<ItemCategoryJoin>> getCategoriesForItem(int itemId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'item_categories_join',
//       where: 'item_id = ?',
//       whereArgs: [itemId],
//     );
//     return res.map((m) => ItemCategoryJoin.fromMap(m)).toList();
//   }

//   Future<List<ItemCategoryJoin>> getItemsForCategory(int categoryId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'item_categories_join',
//       where: 'category_id = ?',
//       whereArgs: [categoryId],
//     );
//     return res.map((m) => ItemCategoryJoin.fromMap(m)).toList();
//   }

//   Future<bool> addCategoryToItem(int itemId, int categoryId) async {
//     final db = await DBHelper.getDatabase();
//     await db.insert(
//       'item_categories_join',
//       {'item_id': itemId, 'category_id': categoryId},
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     return true;
//   }

//   Future<bool> removeCategoryFromItem(int itemId, int categoryId) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete(
//       'item_categories_join',
//       where: 'item_id = ? AND category_id = ?',
//       whereArgs: [itemId, categoryId],
//     );
//     return true;
//   }

//   Future<bool> removeAllCategoriesFromItem(int itemId) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete(
//       'item_categories_join',
//       where: 'item_id = ?',
//       whereArgs: [itemId],
//     );
//     return true;
//   }

//   Future<bool> updateItemCategories(int itemId, List<int> categoryIds) async {
//     final db = await DBHelper.getDatabase();
    
//     // Start a transaction
//     await db.transaction((txn) async {
//       // Remove existing categories
//       await txn.delete(
//         'item_categories_join',
//         where: 'item_id = ?',
//         whereArgs: [itemId],
//       );
      
//       // Add new categories
//       for (final categoryId in categoryIds) {
//         await txn.insert(
//           'item_categories_join',
//           {'item_id': itemId, 'category_id': categoryId},
//           conflictAlgorithm: ConflictAlgorithm.replace,
//         );
//       }
//     });
    
//     return true;
//   }

//   Future<bool> itemHasCategory(int itemId, int categoryId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'item_categories_join',
//       where: 'item_id = ? AND category_id = ?',
//       whereArgs: [itemId, categoryId],
//     );
//     return res.isNotEmpty;
//   }
// }

// ===================================================================

// lib/repo/item_category_join_repo.dart - MINIMAL UPDATE
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
  
  // Add this method to handle ID updates after sync
  Future<void> updateItemIdAfterSync(int oldItemId, int newItemId) async {
    final db = await DBHelper.getDatabase();
    
    // Update all category joins for this item
    await db.update(
      'item_categories_join',
      {'item_id': newItemId},
      where: 'item_id = ?',
      whereArgs: [oldItemId],
    );
    
    print('🔄 Updated item category joins: $oldItemId → $newItemId');
  }
  
  // Get category names for an item (useful for UI)
  Future<List<String>> getCategoryNamesForItem(int itemId) async {
    final db = await DBHelper.getDatabase();
    
    final result = await db.rawQuery('''
      SELECT ic.category_name 
      FROM items_categories ic
      INNER JOIN item_categories_join icj ON ic.category_id = icj.category_id
      WHERE icj.item_id = ?
    ''', [itemId]);
    
    return result.map((map) => map['category_name'] as String).toList();
  }
}