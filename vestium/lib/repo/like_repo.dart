import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class LikeRepo {
  Future<List<LikeModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('likes');
    return res.map((m) => LikeModel.fromMap(m)).toList();
  }

  Future<List<LikeModel>> getByPostId(int postId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('likes', where: 'post_id = ?', whereArgs: [postId]);
    return res.map((m) => LikeModel.fromMap(m)).toList();
  }

  Future<bool> insert(LikeModel like) async {
    final db = await DBHelper.getDatabase();
    await db.insert('likes', like.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(int id, LikeModel like) async {
    final db = await DBHelper.getDatabase();
    await db.update('likes', like.toMap(), where: 'like_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('likes', where: 'like_id = ?', whereArgs: [id]);
    return true;
  }
}
