import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class OutfitCategoryRepo {
  Future<List<OutfitCategory>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('outfit_categories');
    return res.map((m) => OutfitCategory.fromMap(m)).toList();
  }

  Future<bool> insert(OutfitCategory cat) async {
    final db = await DBHelper.getDatabase();
    await db.insert('outfit_categories', cat.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(int id, OutfitCategory cat) async {
    final db = await DBHelper.getDatabase();
    await db.update('outfit_categories', cat.toMap(), where: 'category_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('outfit_categories', where: 'category_id = ?', whereArgs: [id]);
    return true;
  }
}
