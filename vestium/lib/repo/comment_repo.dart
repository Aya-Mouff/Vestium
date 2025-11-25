import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class CommentRepo {
  Future<List<CommentModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('comments');
    return res.map((m) => CommentModel.fromMap(m)).toList();
  }

  Future<List<CommentModel>> getByPostId(int postId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('comments', where: 'post_id = ?', whereArgs: [postId]);
    return res.map((m) => CommentModel.fromMap(m)).toList();
  }

  Future<bool> insert(CommentModel c) async {
    final db = await DBHelper.getDatabase();
    await db.insert('comments', c.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(int id, CommentModel c) async {
    final db = await DBHelper.getDatabase();
    await db.update('comments', c.toMap(), where: 'comment_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('comments', where: 'comment_id = ?', whereArgs: [id]);
    return true;
  }
}
