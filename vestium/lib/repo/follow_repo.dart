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

  // Get followers count for a user
  Future<int> getFollowersCount(int userId) async {
    final db = await DBHelper.getDatabase();
    final count = await db.rawQuery(
      'SELECT COUNT(*) as count FROM followings_followers WHERE following_id = ?',
      [userId],
    );
    return count.first['count'] as int;
  }

  // Get following count for a user
  Future<int> getFollowingCount(int userId) async {
    final db = await DBHelper.getDatabase();
    final count = await db.rawQuery(
      'SELECT COUNT(*) as count FROM followings_followers WHERE follower_id = ?',
      [userId],
    );
    return count.first['count'] as int;
  }

  // Get list of follower IDs for a user
  Future<List<int>> getFollowerIds(int userId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.query(
      'followings_followers',
      columns: ['follower_id'],
      where: 'following_id = ?',
      whereArgs: [userId],
    );
    return result.map((map) => map['follower_id'] as int).toList();
  }

  // Get list of following IDs for a user
  Future<List<int>> getFollowingIds(int userId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.query(
      'followings_followers',
      columns: ['following_id'],
      where: 'follower_id = ?',
      whereArgs: [userId],
    );
    return result.map((map) => map['following_id'] as int).toList();
  }

  // Get list of followers (full User objects) for a user
  Future<List<User>> getFollowers(int userId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.rawQuery('''
      SELECT u.* FROM user u
      INNER JOIN followings_followers ff ON u.user_id = ff.follower_id
      WHERE ff.following_id = ?
    ''', [userId]);
    return result.map((map) => User.fromMap(map)).toList();
  }

  // Get list of users being followed (full User objects) for a user
  Future<List<User>> getFollowing(int userId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.rawQuery('''
      SELECT u.* FROM user u
      INNER JOIN followings_followers ff ON u.user_id = ff.following_id
      WHERE ff.follower_id = ?
    ''', [userId]);
    return result.map((map) => User.fromMap(map)).toList();
  }
}

