import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';

class FollowRepo {
  Future<List<FollowingFollower>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('followings_followers');
    return res.map((m) => FollowingFollower.fromMap(m)).toList();
  }

  Future<bool> insert(FollowingFollower f) async {
    final db = await DBHelper.getDatabase();
    await db.insert('followings_followers', f.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  /// UPDATE using composite PK
  Future<bool> update(Map<String, int> oldKeys, FollowingFollower updated) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'followings_followers',
      updated.toMap(),
      where: 'following_id = ? AND follower_id = ?',
      whereArgs: [oldKeys['following_id'], oldKeys['follower_id']],
    );
    return true;
  }

  Future<bool> delete(int followingId, int followerId) async {
    final db = await DBHelper.getDatabase();
    await db.delete(
      'followings_followers',
      where: 'following_id = ? AND follower_id = ?',
      whereArgs: [followingId, followerId],
    );
    return true;
  }
}
