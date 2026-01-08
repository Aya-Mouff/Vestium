// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class OutfitCategoryRepo {
//   Future<List<OutfitCategory>> getAll(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'outfit_categories',
//       where: 'user_id = ? OR user_id IS NULL',
//       whereArgs: [userId],
//     );
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

//   Future<OutfitCategory?> getByName(String name, {int? userId}) async {
//     final db = await DBHelper.getDatabase();

//     // If userId provided, check user-specific first, then shared
//     if (userId != null) {
//       final userRes = await db.query(
//         'outfit_categories',
//         where: 'category_name = ? AND user_id = ?',
//         whereArgs: [name, userId],
//       );

//       if (userRes.isNotEmpty) {
//         return OutfitCategory.fromMap(userRes.first);
//       }
//     }

//     // Check shared categories (NULL user_id)
//     final sharedRes = await db.query(
//       'outfit_categories',
//       where: 'category_name = ? AND user_id IS NULL',
//       whereArgs: [name],
//     );

//     if (sharedRes.isNotEmpty) {
//       return OutfitCategory.fromMap(sharedRes.first);
//     }

//     return null;
//   }

//   Future<bool> insert(OutfitCategory cat) async {
//     final db = await DBHelper.getDatabase();
//     await db.insert(
//       'outfit_categories',
//       cat.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     return true;
//   }

//   Future<bool> update(int id, OutfitCategory cat) async {
//     final db = await DBHelper.getDatabase();
//     await db.update(
//       'outfit_categories',
//       cat.toMap(),
//       where: 'category_id = ?',
//       whereArgs: [id],
//     );
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete(
//       'outfit_categories',
//       where: 'category_id = ?',
//       whereArgs: [id],
//     );
//     return true;
//   }
// }

// -------------------------------------------------------------------

// lib/repo/outfit_category_repo.dart - UPDATED WITH SYNC
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import '../services/sync_manager.dart';

class OutfitCategoryRepo {
  static final OutfitCategoryRepo _instance = OutfitCategoryRepo._internal();
  factory OutfitCategoryRepo() => _instance;
  OutfitCategoryRepo._internal();
  
  // Add sync manager
  final SyncManager _syncManager = SyncManager();
  
  // KEEP ALL ORIGINAL METHODS
  
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

  // MODIFIED: Add sync for creates
  Future<bool> insert(OutfitCategory cat) async {
    final db = await DBHelper.getDatabase();
    
    // Check if category already exists locally
    final existing = await _getCategoryByNameAndUser(
      cat.categoryName ?? '', 
      cat.userId
    );
    if (existing != null) {
      print('⚠️ Category "${cat.categoryName}" already exists locally');
      return true; // Already exists, treat as success
    }
    
    // 1. Save to local database (ORIGINAL LOGIC)
    final insertedId = await db.insert(
      'outfit_categories',
      cat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // Update the category with the inserted ID
    final insertedCategory = cat.copyWith(categoryId: insertedId);
    
    // 2. NEW: Queue for sync (only if not a system category)
    if (cat.userId != null) { // User-specific categories should sync
      await _queueCategoryOperation(
        action: 'create',
        category: insertedCategory,
        entityId: insertedId,
      );
    } else {
      print('ℹ️ System category "${cat.categoryName}" - not queued for sync');
    }
    
    print('✅ Created outfit category "${cat.categoryName}" (ID: $insertedId), queued for sync');
    return true;
  }

  // MODIFIED: Add sync for updates
  Future<bool> update(int id, OutfitCategory cat) async {
    final db = await DBHelper.getDatabase();
    
    // Get existing category before update
    final existingCategory = await getById(id);
    if (existingCategory == null) {
      print('❌ Category $id not found for update');
      return false;
    }
    
    // 1. Update local database (ORIGINAL LOGIC)
    await db.update(
      'outfit_categories',
      cat.toMap(),
      where: 'category_id = ?',
      whereArgs: [id],
    );
    
    // 2. NEW: Queue for sync (only if server ID and user-specific)
    if (id >= 1000 && cat.userId != null) { // Server ID and user-specific
      await _queueCategoryOperation(
        action: 'update',
        category: cat.copyWith(categoryId: id),
        entityId: id,
      );
      print('✅ Category update queued for sync: $id');
    } else if (id < 1000) {
      print('ℹ️ Local category $id updated - not queued for sync');
    } else if (cat.userId == null) {
      print('ℹ️ System category $id updated - not queued for sync');
    }
    
    return true;
  }

  // MODIFIED: Add sync for deletes
  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Get category before deletion (for sync data)
    final category = await getById(id);
    if (category == null) {
      print('❌ Category $id not found for deletion');
      return false;
    }
    
    // Check if category is in use by outfits
    final inUse = await _isCategoryInUse(id);
    if (inUse) {
      print('❌ Cannot delete category $id - it is in use by outfits');
      return false;
    }
    
    // 2. Delete from local database (ORIGINAL LOGIC)
    await db.delete(
      'outfit_categories',
      where: 'category_id = ?',
      whereArgs: [id],
    );
    
    // 3. NEW: Queue for sync (only if server ID and user-specific)
    if (id >= 1000 && category.userId != null) { // Server ID and user-specific
      await _queueCategoryOperation(
        action: 'delete',
        category: category,
        entityId: id,
      );
      print('✅ Category deletion queued for sync: $id');
    } else if (id < 1000) {
      print('ℹ️ Local category $id deleted - not queued for sync');
    } else if (category.userId == null) {
      print('ℹ️ System category $id deleted - not queued for sync');
    }
    
    return true;
  }
  
  // NEW: Helper method to queue category operations
  Future<void> _queueCategoryOperation({
    required String action,
    required OutfitCategory category,
    int? entityId,
  }) async {
    await _syncManager.queueOutfitCategoryOperation(
      action: action,
      data: category.toMap(),
      entityId: entityId,
    );
  }
  
  // NEW: Get category by name and user ID
  Future<OutfitCategory?> _getCategoryByNameAndUser(String name, int? userId) async {
    final db = await DBHelper.getDatabase();
    
    if (userId != null) {
      // Check user-specific
      final userRes = await db.query(
        'outfit_categories',
        where: 'category_name = ? AND user_id = ?',
        whereArgs: [name, userId],
      );
      if (userRes.isNotEmpty) {
        return OutfitCategory.fromMap(userRes.first);
      }
    }
    
    // Check system categories
    final systemRes = await db.query(
      'outfit_categories',
      where: 'category_name = ? AND user_id IS NULL',
      whereArgs: [name],
    );
    if (systemRes.isNotEmpty) {
      return OutfitCategory.fromMap(systemRes.first);
    }
    
    return null;
  }
  
  // NEW: Check if category is in use by outfits
  Future<bool> _isCategoryInUse(int categoryId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM outfit_category_join WHERE category_id = ?',
      [categoryId],
    );
    return (result.first['count'] as int) > 0;
  }
  
  // NEW: Get categories for a specific outfit
  Future<List<OutfitCategory>> getCategoriesForOutfit(int outfitId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.rawQuery('''
      SELECT oc.* FROM outfit_categories oc
      JOIN outfit_category_join ocj ON oc.category_id = ocj.category_id
      WHERE ocj.outfit_id = ?
    ''', [outfitId]);
    
    return result.map((m) => OutfitCategory.fromMap(m)).toList();
  }
  
  // NEW: Add category to outfit
  Future<bool> addCategoryToOutfit(int outfitId, int categoryId) async {
    final db = await DBHelper.getDatabase();
    
    // Check if already exists
    final existing = await db.query(
      'outfit_category_join',
      where: 'outfit_id = ? AND category_id = ?',
      whereArgs: [outfitId, categoryId],
    );
    
    if (existing.isNotEmpty) {
      return true; // Already exists
    }
    
    await db.insert(
      'outfit_category_join',
      {'outfit_id': outfitId, 'category_id': categoryId},
    );
    
    return true;
  }
  
  // NEW: Remove category from outfit
  Future<bool> removeCategoryFromOutfit(int outfitId, int categoryId) async {
    final db = await DBHelper.getDatabase();
    
    await db.delete(
      'outfit_category_join',
      where: 'outfit_id = ? AND category_id = ?',
      whereArgs: [outfitId, categoryId],
    );
    
    return true;
  }
  
  // NEW: Create or get existing category
  Future<OutfitCategory> createOrGetCategory({
    required String name,
    required int userId,
  }) async {
    // Try to find existing
    final existing = await getByName(name, userId: userId);
    if (existing != null) {
      return existing;
    }
    
    // Create new
    final newCategory = OutfitCategory(
      categoryName: name,
      userId: userId,
    );
    
    await insert(newCategory);
    
    // Get the newly created category with its ID
    final created = await getByName(name, userId: userId);
    return created ?? newCategory;
  }
  
  // NEW: Get user-specific categories only
  Future<List<OutfitCategory>> getUserCategories(int userId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'outfit_categories',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return res.map((m) => OutfitCategory.fromMap(m)).toList();
  }
  
  // NEW: Get system categories only
  Future<List<OutfitCategory>> getSystemCategories() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'outfit_categories',
      where: 'user_id IS NULL',
    );
    return res.map((m) => OutfitCategory.fromMap(m)).toList();
  }
  
  // NEW: CopyWith method helper for OutfitCategory
}

// Helper extension for copyWith
extension OutfitCategoryCopyWith on OutfitCategory {
  OutfitCategory copyWith({
    int? categoryId,
    int? userId,
    String? categoryName,
  }) {
    return OutfitCategory(
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}