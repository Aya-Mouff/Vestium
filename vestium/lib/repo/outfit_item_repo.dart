import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class OutfitItemRepo {
  Future<List<OutfitItem>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('outfit_item');
    return res.map((m) => OutfitItem.fromMap(m)).toList();
  }

  Future<List<OutfitItem>> getByOutfitId(int outfitId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('outfit_item', where: 'outfit_id = ?', whereArgs: [outfitId]);
    return res.map((m) => OutfitItem.fromMap(m)).toList();
  }

  Future<bool> insert(OutfitItem oi) async {
    final db = await DBHelper.getDatabase();
    await db.insert('outfit_item', oi.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(Map<String, int> oldKeys, OutfitItem newValue) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'outfit_item',
      newValue.toMap(),
      where: 'outfit_id = ? AND item_id = ?',
      whereArgs: [oldKeys['outfit_id'], oldKeys['item_id']],
    );
    return true;
  }

  Future<bool> delete(int outfitId, int itemId) async {
    final db = await DBHelper.getDatabase();
    await db.delete(
      'outfit_item',
      where: 'outfit_id = ? AND item_id = ?',
      whereArgs: [outfitId, itemId],
    );
    return true;
  }
}
