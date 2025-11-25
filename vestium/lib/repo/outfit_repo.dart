import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class OutfitRepo {
  Future<List<OutfitModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('outfits');
    return res.map((m) => OutfitModel.fromMap(m)).toList();
  }

  Future<List<OutfitModel>> getByUserId(int userId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('outfits', where: 'user_id = ?', whereArgs: [userId]);
    return res.map((m) => OutfitModel.fromMap(m)).toList();
  }

  Future<bool> insert(OutfitModel outfit) async {
    final db = await DBHelper.getDatabase();
    await db.insert('outfits', outfit.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(int id, OutfitModel outfit) async {
    final db = await DBHelper.getDatabase();
    await db.update('outfits', outfit.toMap(), where: 'outfit_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('outfits', where: 'outfit_id = ?', whereArgs: [id]);
    return true;
  }
}
