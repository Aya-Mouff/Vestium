// lib/repo/outfit_category_join_repo.dart
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class OutfitCategoryJoinRepo {
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
}
