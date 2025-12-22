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
