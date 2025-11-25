import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class ItemCategoryRepo {
  Future<List<ItemCategory>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('items_categories');
    return res.map((m) => ItemCategory.fromMap(m)).toList();
  }

  Future<bool> insert(ItemCategory cat) async {
    final db = await DBHelper.getDatabase();
    await db.insert('items_categories', cat.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(int id, ItemCategory cat) async {
    final db = await DBHelper.getDatabase();
    await db.update('items_categories', cat.toMap(), where: 'category_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('items_categories', where: 'category_id = ?', whereArgs: [id]);
    return true;
  }
}
