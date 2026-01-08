// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class FollowRepo {
//   Future<List<FollowingFollower>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('followings_followers');
//     return res.map((m) => FollowingFollower.fromMap(m)).toList();
//   }

//   Future<bool> insert(FollowingFollower f) async {
//     final db = await DBHelper.getDatabase();
//     await db.insert('followings_followers', f.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//     return true;
//   }

//   /// UPDATE using composite PK
//   Future<bool> update(Map<String, int> oldKeys, FollowingFollower updated) async {
//     final db = await DBHelper.getDatabase();
//     await db.update(
//       'followings_followers',
//       updated.toMap(),
//       where: 'following_id = ? AND follower_id = ?',
//       whereArgs: [oldKeys['following_id'], oldKeys['follower_id']],
//     );
//     return true;
//   }

//   Future<bool> delete(int followingId, int followerId) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete(
//       'followings_followers',
//       where: 'following_id = ? AND follower_id = ?',
//       whereArgs: [followingId, followerId],
//     );
//     return true;
//   }

//   // Get followers count for a user
//   Future<int> getFollowersCount(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final count = await db.rawQuery(
//       'SELECT COUNT(*) as count FROM followings_followers WHERE following_id = ?',
//       [userId],
//     );
//     return count.first['count'] as int;
//   }

//   // Get following count for a user
//   Future<int> getFollowingCount(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final count = await db.rawQuery(
//       'SELECT COUNT(*) as count FROM followings_followers WHERE follower_id = ?',
//       [userId],
//     );
//     return count.first['count'] as int;
//   }

//   // Get list of follower IDs for a user
//   Future<List<int>> getFollowerIds(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final result = await db.query(
//       'followings_followers',
//       columns: ['follower_id'],
//       where: 'following_id = ?',
//       whereArgs: [userId],
//     );
//     return result.map((map) => map['follower_id'] as int).toList();
//   }

//   // Get list of following IDs for a user
//   Future<List<int>> getFollowingIds(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final result = await db.query(
//       'followings_followers',
//       columns: ['following_id'],
//       where: 'follower_id = ?',
//       whereArgs: [userId],
//     );
//     return result.map((map) => map['following_id'] as int).toList();
//   }

//   // Get list of followers (full User objects) for a user
//   Future<List<User>> getFollowers(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final result = await db.rawQuery('''
//       SELECT u.* FROM user u
//       INNER JOIN followings_followers ff ON u.user_id = ff.follower_id
//       WHERE ff.following_id = ?
//     ''', [userId]);
//     return result.map((map) => User.fromMap(map)).toList();
//   }

//   // Get list of users being followed (full User objects) for a user
//   Future<List<User>> getFollowing(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final result = await db.rawQuery('''
//       SELECT u.* FROM user u
//       INNER JOIN followings_followers ff ON u.user_id = ff.following_id
//       WHERE ff.follower_id = ?
//     ''', [userId]);
//     return result.map((map) => User.fromMap(map)).toList();
//   }
// }

// -----------------------------------------------------------------------

// lib/repo/follow_repo.dart - UPDATED VERSION WITH SYNC
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import '../services/sync_manager.dart';
import 'package:vestium/databases/services/current_user_service.dart';

class FollowRepo {
  static final FollowRepo _instance = FollowRepo._internal();
  factory FollowRepo() => _instance;
  FollowRepo._internal();
  
  final SyncManager _syncManager = SyncManager();
  
  Future<Database> getDatabase() async {
    return await DBHelper.getDatabase();
  }
  
  // Get all follows
  Future<List<FollowingFollower>> getAll() async {
    final db = await getDatabase();
    final res = await db.query('followings_followers');
    return res.map((m) => FollowingFollower.fromMap(m)).toList();
  }

  // Follow a user (with sync)
  Future<bool> insert(FollowingFollower f) async {
    final db = await getDatabase();
    
    // Check if already following
    final existing = await db.query(
      'followings_followers',
      where: 'following_id = ? AND follower_id = ?',
      whereArgs: [f.followingId, f.followerId],
    );
    
    if (existing.isNotEmpty) {
      print('⚠️ Already following: ${f.followingId}');
      return false; // Already following
    }
    
    // 1. Save to local database
    await db.insert(
      'followings_followers', 
      f.toMap(), 
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // 2. Queue for sync
    await _queueFollowOperation(
      action: 'create',
      data: f.toMap(),
      followingId: f.followingId,
      followerId: f.followerId,
    );
    
    print('✅ Followed user ${f.followingId}, queued for sync');
    return true;
  }

  // Update follow (with sync) - rarely used but kept for compatibility
  Future<bool> update(Map<String, int> oldKeys, FollowingFollower updated) async {
    final db = await getDatabase();
    
    // 1. Update local database
    await db.update(
      'followings_followers',
      updated.toMap(),
      where: 'following_id = ? AND follower_id = ?',
      whereArgs: [oldKeys['following_id'], oldKeys['follower_id']],
    );
    
    // 2. Queue for sync (if it has server IDs)
    if (_isServerFollow(oldKeys['following_id']!, oldKeys['follower_id']!)) {
      await _queueFollowOperation(
        action: 'update',
        data: updated.toMap(),
        followingId: updated.followingId,
        followerId: updated.followerId,
      );
    }
    
    return true;
  }

  // Unfollow a user (with sync)
  Future<bool> delete(int followingId, int followerId) async {
    final db = await getDatabase();
    
    // 1. Get follow data before deletion
    await _getFollow(followingId, followerId);
    
    // 2. Delete from local database
    final deleted = await db.delete(
      'followings_followers',
      where: 'following_id = ? AND follower_id = ?',
      whereArgs: [followingId, followerId],
    );
    
    if (deleted > 0) {
      // 3. Queue for sync (if it has server IDs)
      if (_isServerFollow(followingId, followerId)) {
        await _queueFollowOperation(
          action: 'delete',
          data: {'following_id': followingId, 'follower_id': followerId},
          followingId: followingId,
          followerId: followerId,
        );
      }
      print('✅ Unfollowed user $followingId, queued for sync');
      return true;
    }
    
    return false;
  }
  
  // Helper: Check if follow relationship exists on server
  bool _isServerFollow(int followingId, int followerId) {
    // If either ID is server ID (≥1000), consider it a server follow
    return followingId >= 1000 || followerId >= 1000;
  }
  
  // Helper: Get specific follow
  Future<FollowingFollower?> _getFollow(int followingId, int followerId) async {
    final db = await getDatabase();
    final result = await db.query(
      'followings_followers',
      where: 'following_id = ? AND follower_id = ?',
      whereArgs: [followingId, followerId],
    );
    
    if (result.isNotEmpty) {
      return FollowingFollower.fromMap(result.first);
    }
    return null;
  }
  
  // Queue follow operation for sync
  Future<void> _queueFollowOperation({
    required String action,
    required Map<String, dynamic> data,
    required int followingId,
    required int followerId,
  }) async {
    await _syncManager.queueFollowOperation(
      action: action,
      data: data,
      entityId: null, // Composite key, no single ID
    );
    
    print('✅ Queued follow $action: $followerId → $followingId');
  }
  
  // Convenience method: Follow user with current user
  Future<bool> followUser(int followingId) async {
    final currentUserId = CurrentUserService.currentUserId;
    if (currentUserId == null) {
      print('❌ No user logged in');
      return false;
    }
    
    if (followingId == currentUserId) {
      print('❌ Cannot follow yourself');
      return false;
    }
    
    final follow = FollowingFollower(
      followingId: followingId,
      followerId: currentUserId,
      date: DateTime.now().toIso8601String(),
    );
    
    return await insert(follow);
  }
  
  // Convenience method: Unfollow user with current user
  Future<bool> unfollowUser(int followingId) async {
    final currentUserId = CurrentUserService.currentUserId;
    if (currentUserId == null) {
      print('❌ No user logged in');
      return false;
    }
    
    return await delete(followingId, currentUserId);
  }
  
  // Convenience method: Toggle follow
  Future<bool> toggleFollow(int followingId) async {
    final currentUserId = CurrentUserService.currentUserId;
    if (currentUserId == null) {
      print('❌ No user logged in');
      return false;
    }
    
    final isFollowing = await isFollowingUser(followingId, currentUserId);
    
    if (isFollowing) {
      return await unfollowUser(followingId);
    } else {
      return await followUser(followingId);
    }
  }
  
  // Check if following a user
  Future<bool> isFollowingUser(int followingId, int followerId) async {
    final db = await getDatabase();
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM followings_followers WHERE following_id = ? AND follower_id = ?',
      [followingId, followerId],
    );
    return (result.first['count'] as int) > 0;
  }

  // Get followers count for a user
  Future<int> getFollowersCount(int userId) async {
    final db = await getDatabase();
    final count = await db.rawQuery(
      'SELECT COUNT(*) as count FROM followings_followers WHERE following_id = ?',
      [userId],
    );
    return count.first['count'] as int;
  }

  // Get following count for a user
  Future<int> getFollowingCount(int userId) async {
    final db = await getDatabase();
    final count = await db.rawQuery(
      'SELECT COUNT(*) as count FROM followings_followers WHERE follower_id = ?',
      [userId],
    );
    return count.first['count'] as int;
  }

  // Get list of follower IDs for a user
  Future<List<int>> getFollowerIds(int userId) async {
    final db = await getDatabase();
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
    final db = await getDatabase();
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
    final db = await getDatabase();
    final result = await db.rawQuery('''
      SELECT u.* FROM user u
      INNER JOIN followings_followers ff ON u.user_id = ff.follower_id
      WHERE ff.following_id = ?
    ''', [userId]);
    return result.map((map) => User.fromMap(map)).toList();
  }

  // Get list of users being followed (full User objects) for a user
  Future<List<User>> getFollowing(int userId) async {
    final db = await getDatabase();
    final result = await db.rawQuery('''
      SELECT u.* FROM user u
      INNER JOIN followings_followers ff ON u.user_id = ff.following_id
      WHERE ff.follower_id = ?
    ''', [userId]);
    return result.map((map) => User.fromMap(map)).toList();
  }
}