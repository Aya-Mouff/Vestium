// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class PostRepo {
//   Future<List<PostModel>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('posts');
//     return res.map((m) => PostModel.fromMap(m)).toList();
//   }

//   Future<List<PostModel>> getByOutfitId(int outfitId) async {
//     final db = await DBHelper.getDatabase();
//     final res =
//         await db.query('posts', where: 'outfit_id = ?', whereArgs: [outfitId]);
//     return res.map((m) => PostModel.fromMap(m)).toList();
//   }

//   /// Get posts by user ID
//   /// Includes both:
//   /// 1. Posts with outfits (linked through outfit's user_id)
//   /// 2. Gallery posts (posts with user_id but no outfit_id)
//   Future<List<PostModel>> getByUserId(int userId) async {
//     final db = await DBHelper.getDatabase();

//     // Get posts in two ways:
//     // 1. Posts that have user_id directly (gallery posts)
//     // 2. Posts linked through outfits (outfit posts)
//     final result = await db.rawQuery('''
//       SELECT DISTINCT p.* FROM posts p
//       LEFT JOIN outfits o ON p.outfit_id = o.outfit_id
//       WHERE p.user_id = ? OR o.user_id = ?
//       ORDER BY p.date DESC
//     ''', [userId, userId]);

//     print('📊 Found ${result.length} posts for user $userId');
    
//     return result.map((m) => PostModel.fromMap(m)).toList();
//   }

//   /// Insert a post and return its new ID
//   Future<int> insert(PostModel post) async {
//     final db = await DBHelper.getDatabase();
//     final id = await db.insert(
//       'posts',
//       post.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     print('✅ Post inserted with id: $id, outfitId: ${post.outfitId}, userId: ${post.userId}, imagePath: ${post.imagePath}');
//     return id;
//   }

//   Future<bool> update(int id, PostModel post) async {
//     final db = await DBHelper.getDatabase();
//     await db.update(
//       'posts',
//       post.toMap(),
//       where: 'post_id = ?',
//       whereArgs: [id],
//     );
//     print('✅ Post updated: $id');
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete('posts', where: 'post_id = ?', whereArgs: [id]);
//     print('🗑️ Post deleted: $id');
//     return true;
//   }

//   Future<List<PostModel>> getByPostId(int postId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'posts',
//       where: 'post_id = ?',
//       whereArgs: [postId],
//     );
//     return res.map((m) => PostModel.fromMap(m)).toList();
//   }
// }

// ---------------------------------------------------------------------------

// lib/repo/post_repo.dart - UPDATED WITH SYNC
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import '../services/sync_manager.dart';

class PostRepo {
  static final PostRepo _instance = PostRepo._internal();
  factory PostRepo() => _instance;
  PostRepo._internal();
  
  final SyncManager _syncManager = SyncManager();
  
  // KEEP ALL ORIGINAL METHODS
  
  Future<List<PostModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('posts');
    return res.map((m) => PostModel.fromMap(m)).toList();
  }

  Future<List<PostModel>> getByOutfitId(int outfitId) async {
    final db = await DBHelper.getDatabase();
    final res =
        await db.query('posts', where: 'outfit_id = ?', whereArgs: [outfitId]);
    return res.map((m) => PostModel.fromMap(m)).toList();
  }

  /// Get posts by user ID
  /// Includes both:
  /// 1. Posts with outfits (linked through outfit's user_id)
  /// 2. Gallery posts (posts with user_id but no outfit_id)
  Future<List<PostModel>> getByUserId(int userId) async {
    final db = await DBHelper.getDatabase();

    // Get posts in two ways:
    // 1. Posts that have user_id directly (gallery posts)
    // 2. Posts linked through outfits (outfit posts)
    final result = await db.rawQuery('''
      SELECT DISTINCT p.* FROM posts p
      LEFT JOIN outfits o ON p.outfit_id = o.outfit_id
      WHERE p.user_id = ? OR o.user_id = ?
      ORDER BY p.date DESC
    ''', [userId, userId]);

    print('📊 Found ${result.length} posts for user $userId');
    
    return result.map((m) => PostModel.fromMap(m)).toList();
  }

  /// MODIFIED: Insert a post and return its new ID with sync
  Future<int> insert(PostModel post) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Save to local database (ORIGINAL LOGIC)
    final id = await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // Update post with the new ID
    final insertedPost = post.copyWith(postId: id);
    
    // 2. NEW: Queue for sync
    await _queueForSync('create', insertedPost);
    
    print('✅ Post inserted with id: $id, outfitId: ${post.outfitId}, userId: ${post.userId}, imagePath: ${post.imagePath}, queued for sync');
    return id;
  }

  // MODIFIED: update with sync
  Future<bool> update(int id, PostModel post) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Update in local database (ORIGINAL LOGIC)
    await db.update(
      'posts',
      post.toMap(),
      where: 'post_id = ?',
      whereArgs: [id],
    );
    
    // 2. NEW: Queue for sync (only if server ID)
    if (_isServerId(id)) {
      await _queueForSync('update', post.copyWith(postId: id));
      print('✅ Post update queued for sync: $id');
    } else {
      print('ℹ️ Local post update - not queued for sync');
    }
    
    print('✅ Post updated: $id');
    return true;
  }

  // MODIFIED: delete with sync
  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Get post before deletion (for sync)
    final post = await _getPostById(id);
    
    // 2. Delete from local database (ORIGINAL LOGIC)
    await db.delete('posts', where: 'post_id = ?', whereArgs: [id]);
    
    // 3. NEW: Queue for sync (only if server ID)
    if (_isServerId(id) && post != null) {
      await _queueForSync('delete', post);
      print('✅ Post deletion queued for sync: $id');
    } else if (!_isServerId(id)) {
      print('ℹ️ Local post deleted - not queued for sync');
    }
    
    print('🗑️ Post deleted: $id');
    return true;
  }

  Future<List<PostModel>> getByPostId(int postId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'posts',
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    return res.map((m) => PostModel.fromMap(m)).toList();
  }
  
  // NEW: Helper method for sync logic
  Future<void> _queueForSync(String action, PostModel post) async {
    if (post.postId == null) return;
    
    // Only sync if server ID
    if (_isServerId(post.postId!)) {
      await _syncManager.queuePostOperation(
        action: action,
        data: post.toMap(),
        entityId: post.postId,
      );
    }
  }
  
  // NEW: Check if ID is from server
  bool _isServerId(int id) {
    return id >= 1000;
  }
  
  // NEW: Get post by ID
  Future<PostModel?> _getPostById(int id) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'posts',
      where: 'post_id = ?',
      whereArgs: [id],
    );
    if (res.isEmpty) return null;
    return PostModel.fromMap(res.first);
  }
  
  // NEW: Update post caption only
  Future<bool> updateCaption(int postId, String caption) async {
    final db = await DBHelper.getDatabase();
    
    await db.update(
      'posts',
      {'caption': caption},
      where: 'post_id = ?',
      whereArgs: [postId],
    );
    
    // Queue sync if server ID
    if (_isServerId(postId)) {
      final updateData = {
        'post_id': postId,
        'caption': caption,
      };
      
      await _syncManager.queuePostOperation(
        action: 'update',
        data: updateData,
        entityId: postId,
      );
      print('✅ Post caption update queued for sync: $postId');
    }
    
    print('📝 Post caption updated: $postId');
    return true;
  }
  
  // NEW: Get gallery posts (posts with user_id but no outfit_id)
  Future<List<PostModel>> getGalleryPosts(int userId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'posts',
      where: 'user_id = ? AND outfit_id IS NULL',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return res.map((m) => PostModel.fromMap(m)).toList();
  }
  
  // NEW: Get outfit posts (posts with outfit_id)
  Future<List<PostModel>> getOutfitPosts(int userId) async {
    final db = await DBHelper.getDatabase();
    final result = await db.rawQuery('''
      SELECT p.* FROM posts p
      JOIN outfits o ON p.outfit_id = o.outfit_id
      WHERE o.user_id = ?
      ORDER BY p.date DESC
    ''', [userId]);
    
    return result.map((m) => PostModel.fromMap(m)).toList();
  }
  
  // NEW: Create gallery post (post without outfit)
  Future<int> createGalleryPost({
    required int userId,
    required String imagePath,
    required String caption,
  }) async {
    final post = PostModel(
      userId: userId,
      imagePath: imagePath,
      caption: caption,
      date: DateTime.now().toIso8601String(),
    );
    
    return await insert(post);
  }
  
  // NEW: Create outfit post (post with outfit)
  Future<int> createOutfitPost({
    required int outfitId,
    required String imagePath,
    required String caption,
  }) async {
    final post = PostModel(
      outfitId: outfitId,
      imagePath: imagePath,
      caption: caption,
      date: DateTime.now().toIso8601String(),
    );
    
    return await insert(post);
  }
  
  // NEW: Get recent posts for feed
  Future<List<PostModel>> getRecentPosts({int limit = 20, int offset = 0}) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'posts',
      orderBy: 'date DESC',
      limit: limit,
      offset: offset,
    );
    return res.map((m) => PostModel.fromMap(m)).toList();
  }
  
  // NEW: Search posts by caption
  Future<List<PostModel>> searchPosts(String query) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'posts',
      where: 'caption LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'date DESC',
    );
    return res.map((m) => PostModel.fromMap(m)).toList();
  }
}