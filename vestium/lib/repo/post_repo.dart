import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class PostRepo {
  Future<List<PostModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('posts');
    return res.map((m) => PostModel.fromMap(m)).toList();
  }

  Future<List<PostModel>> getByOutfitId(int outfitId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('posts', where: 'outfit_id = ?', whereArgs: [outfitId]);
    return res.map((m) => PostModel.fromMap(m)).toList();
  }

  Future<bool> insert(PostModel post) async {
    final db = await DBHelper.getDatabase();
    await db.insert('posts', post.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(int id, PostModel post) async {
    final db = await DBHelper.getDatabase();
    await db.update('posts', post.toMap(), where: 'post_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('posts', where: 'post_id = ?', whereArgs: [id]);
    return true;
  }
}
