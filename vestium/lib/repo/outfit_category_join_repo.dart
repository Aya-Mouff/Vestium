// // lib/repo/outfit_category_join_repo.dart
// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class OutfitCategoryJoinRepo {
//   Future<List<OutfitCategoryJoin>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('outfit_category_join');
//     return res.map((m) => OutfitCategoryJoin.fromMap(m)).toList();
//   }

//   Future<List<OutfitCategoryJoin>> getByOutfitId(int outfitId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'outfit_category_join',
//       where: 'outfit_id = ?',
//       whereArgs: [outfitId],
//     );
//     return res.map((m) => OutfitCategoryJoin.fromMap(m)).toList();
//   }

//   Future<List<OutfitCategoryJoin>> getByCategoryId(int categoryId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'outfit_category_join',
//       where: 'category_id = ?',
//       whereArgs: [categoryId],
//     );
//     return res.map((m) => OutfitCategoryJoin.fromMap(m)).toList();
//   }

//   Future<bool> insert(OutfitCategoryJoin outfitCategory) async {
//     final db = await DBHelper.getDatabase();
//     await db.insert(
//       'outfit_category_join',
//       outfitCategory.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     return true;
//   }

//   Future<bool> delete(int outfitId, int categoryId) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete(
//       'outfit_category_join',
//       where: 'outfit_id = ? AND category_id = ?',
//       whereArgs: [outfitId, categoryId],
//     );
//     return true;
//   }

//   Future<bool> deleteByOutfitId(int outfitId) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete(
//       'outfit_category_join',
//       where: 'outfit_id = ?',
//       whereArgs: [outfitId],
//     );
//     return true;
//   }

//   Future<bool> deleteByCategoryId(int categoryId) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete(
//       'outfit_category_join',
//       where: 'category_id = ?',
//       whereArgs: [categoryId],
//     );
//     return true;
//   }

//   Future<List<OutfitCategory>> getCategoriesForOutfit(int outfitId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.rawQuery('''
//       SELECT oc.* 
//       FROM outfit_categories oc
//       INNER JOIN outfit_category_join ocj ON oc.category_id = ocj.category_id
//       WHERE ocj.outfit_id = ?
//     ''', [outfitId]);
//     return res.map((m) => OutfitCategory.fromMap(m)).toList();
//   }

//   Future<List<OutfitModel>> getOutfitsByCategory(int categoryId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.rawQuery('''
//       SELECT o.* 
//       FROM outfits o
//       INNER JOIN outfit_category_join ocj ON o.outfit_id = ocj.outfit_id
//       WHERE ocj.category_id = ?
//     ''', [categoryId]);
//     return res.map((m) => OutfitModel.fromMap(m)).toList();
//   }
// }

// ============================================================================

// lib/repo/outfit_category_join_repo.dart - MINIMAL UPDATE
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class OutfitCategoryJoinRepo {
  // KEEP ALL ORIGINAL METHODS EXACTLY AS THEY WERE
  
  Future<List<OutfitCategoryJoin>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('outfit_category_join');
    return res.map((m) => OutfitCategoryJoin.fromMap(m)).toList();
  }

  Future<List<OutfitCategoryJoin>> getByOutfitId(int outfitId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'outfit_category_join',
      where: 'outfit_id = ?',
      whereArgs: [outfitId],
    );
    return res.map((m) => OutfitCategoryJoin.fromMap(m)).toList();
  }

  Future<List<OutfitCategoryJoin>> getByCategoryId(int categoryId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'outfit_category_join',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return res.map((m) => OutfitCategoryJoin.fromMap(m)).toList();
  }

  Future<bool> insert(OutfitCategoryJoin outfitCategory) async {
    final db = await DBHelper.getDatabase();
    await db.insert(
      'outfit_category_join',
      outfitCategory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<bool> delete(int outfitId, int categoryId) async {
    final db = await DBHelper.getDatabase();
    await db.delete(
      'outfit_category_join',
      where: 'outfit_id = ? AND category_id = ?',
      whereArgs: [outfitId, categoryId],
    );
    return true;
  }

  Future<bool> deleteByOutfitId(int outfitId) async {
    final db = await DBHelper.getDatabase();
    await db.delete(
      'outfit_category_join',
      where: 'outfit_id = ?',
      whereArgs: [outfitId],
    );
    return true;
  }

  Future<bool> deleteByCategoryId(int categoryId) async {
    final db = await DBHelper.getDatabase();
    await db.delete(
      'outfit_category_join',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    return true;
  }

  Future<List<OutfitCategory>> getCategoriesForOutfit(int outfitId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.rawQuery('''
      SELECT oc.* 
      FROM outfit_categories oc
      INNER JOIN outfit_category_join ocj ON oc.category_id = ocj.category_id
      WHERE ocj.outfit_id = ?
    ''', [outfitId]);
    return res.map((m) => OutfitCategory.fromMap(m)).toList();
  }

  Future<List<OutfitModel>> getOutfitsByCategory(int categoryId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.rawQuery('''
      SELECT o.* 
      FROM outfits o
      INNER JOIN outfit_category_join ocj ON o.outfit_id = ocj.outfit_id
      WHERE ocj.category_id = ?
    ''', [categoryId]);
    return res.map((m) => OutfitModel.fromMap(m)).toList();
  }
  
  // NEW: Helper to update outfit IDs after sync
  Future<void> updateOutfitIdAfterSync(int oldOutfitId, int newOutfitId) async {
    final db = await DBHelper.getDatabase();
    
    // Update all category joins for this outfit
    await db.update(
      'outfit_category_join',
      {'outfit_id': newOutfitId},
      where: 'outfit_id = ?',
      whereArgs: [oldOutfitId],
    );
    
    print('🔄 Updated outfit category joins: $oldOutfitId → $newOutfitId');
  }
  
  // NEW: Helper to update category IDs after sync
  Future<void> updateCategoryIdAfterSync(int oldCategoryId, int newCategoryId) async {
    final db = await DBHelper.getDatabase();
    
    // Update all outfit joins for this category
    await db.update(
      'outfit_category_join',
      {'category_id': newCategoryId},
      where: 'category_id = ?',
      whereArgs: [oldCategoryId],
    );
    
    print('🔄 Updated outfit category joins: category $oldCategoryId → $newCategoryId');
  }
  
  // NEW: Batch update outfit categories (convenience method)
  Future<bool> updateOutfitCategories(int outfitId, List<int> categoryIds) async {
    final db = await DBHelper.getDatabase();
    
    await db.transaction((txn) async {
      // Remove existing categories
      await txn.delete(
        'outfit_category_join',
        where: 'outfit_id = ?',
        whereArgs: [outfitId],
      );
      
      // Add new categories
      for (final categoryId in categoryIds) {
        await txn.insert(
          'outfit_category_join',
          {'outfit_id': outfitId, 'category_id': categoryId},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
    
    print('✅ Updated ${categoryIds.length} categories for outfit $outfitId');
    return true;
  }
  
  // NEW: Get category names for an outfit (useful for UI)
  Future<List<String>> getCategoryNamesForOutfit(int outfitId) async {
    final db = await DBHelper.getDatabase();
    
    final result = await db.rawQuery('''
      SELECT oc.category_name 
      FROM outfit_categories oc
      INNER JOIN outfit_category_join ocj ON oc.category_id = ocj.category_id
      WHERE ocj.outfit_id = ?
    ''', [outfitId]);
    
    return result.map((map) => map['category_name'] as String).toList();
  }
  
  // NEW: Check if outfit has category
  Future<bool> outfitHasCategory(int outfitId, int categoryId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'outfit_category_join',
      where: 'outfit_id = ? AND category_id = ?',
      whereArgs: [outfitId, categoryId],
    );
    return res.isNotEmpty;
  }
}