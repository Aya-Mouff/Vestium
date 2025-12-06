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
    final res =
        await db.query('posts', where: 'outfit_id = ?', whereArgs: [outfitId]);
    return res.map((m) => PostModel.fromMap(m)).toList();
  }

  Future<List<PostModel>> getByUserId(int userId) async {
    final db = await DBHelper.getDatabase();

    // JOIN posts with outfits to get posts by user_id
    final result = await db.rawQuery('''
      SELECT p.* FROM posts p
      INNER JOIN outfits o ON p.outfit_id = o.outfit_id
      WHERE o.user_id = ?
      ORDER BY p.date DESC
    ''', [userId]);

    return result.map((m) => PostModel.fromMap(m)).toList();
  }

  /// Insert a post and return its new ID
  Future<int> insert(PostModel post) async {
    final db = await DBHelper.getDatabase();
    final id = await db.insert(
      'posts',
      post.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('✅ Post inserted with id: $id, outfitId: ${post.outfitId}, imagePath: ${post.imagePath}');
    return id;
  }

  Future<bool> update(int id, PostModel post) async {
    final db = await DBHelper.getDatabase();
    await db.update(
      'posts',
      post.toMap(),
      where: 'post_id = ?',
      whereArgs: [id],
    );
    print('✅ Post updated: $id');
    return true;
  }

  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    await db.delete('posts', where: 'post_id = ?', whereArgs: [id]);
    print('🗑️ Post deleted: $id');
    return true;
  }

  Future<List<PostModel>> getByPostId(int postId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      'posts',
      where: 'post_id = ?', // fixed column name from 'postId' to 'post_id'
      whereArgs: [postId],
    );
    return res.map((m) => PostModel.fromMap(m)).toList();
  }
}
