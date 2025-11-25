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
    final res = await db.query('items', where: 'user_id = ?', whereArgs: [userId]);
    return res.map((m) => ItemModel.fromMap(m)).toList();
  }

  Future<bool> insert(ItemModel item) async {
    final db = await DBHelper.getDatabase();
    await db.insert('items', item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(int id, ItemModel item) async {
    final db = await DBHelper.getDatabase();
    await db.update('items', item.toMap(), where: 'item_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('items', where: 'item_id = ?', whereArgs: [id]);
    return true;
  }
}
