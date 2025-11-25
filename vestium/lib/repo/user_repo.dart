import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class UserRepo {
  Future<List<User>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('user');
    return res.map((m) => User.fromMap(m)).toList();
  }

  Future<User?> getById(int id) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('user', where: 'user_id = ?', whereArgs: [id]);
    if (res.isEmpty) return null;
    return User.fromMap(res.first);
  }

  Future<bool> insert(User user) async {
    final db = await DBHelper.getDatabase();
    await db.insert('user', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<bool> update(int id, User user) async {
    final db = await DBHelper.getDatabase();
    await db.update('user', user.toMap(), where: 'user_id = ?', whereArgs: [id]);
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('user', where: 'user_id = ?', whereArgs: [id]);
    return true;
  }
}
