import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _databaseName = "vestium_DATABASE.db";
  static const _databaseVersion = 1; // Keep as 1
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        // Users
        await db.execute('''
          CREATE TABLE user (
            user_id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            full_name TEXT,
            bio TEXT,
            pfp TEXT,
            email TEXT,
            password TEXT,
            date_created TEXT,
            camera_permission INTEGER,
            gallery_permission INTEGER
          );
        ''');

        // Follow relationships
        await db.execute('''
          CREATE TABLE followings_followers (
            following_id INTEGER,
            follower_id INTEGER,
            date TEXT,
            PRIMARY KEY (following_id, follower_id),
            FOREIGN KEY (following_id) REFERENCES user(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (follower_id) REFERENCES user(user_id) ON DELETE CASCADE ON UPDATE CASCADE
          );
        ''');

        // Item categories
        await db.execute('''
          CREATE TABLE items_categories (
            category_id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_name TEXT
          );
        ''');

        // Insert initial item categories - FIXED: Changed " to '
        await db.execute('INSERT INTO items_categories (category_name) VALUES (\'Tops\')');
        await db.execute('INSERT INTO items_categories (category_name) VALUES (\'Bottoms\')');
        await db.execute('INSERT INTO items_categories (category_name) VALUES (\'Dresses\')');
        await db.execute('INSERT INTO items_categories (category_name) VALUES (\'Outerwear\')');
        await db.execute('INSERT INTO items_categories (category_name) VALUES (\'Shoes\')');
        await db.execute('INSERT INTO items_categories (category_name) VALUES (\'Accessories\')');

        // Items
        await db.execute('''
          CREATE TABLE items (
            item_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            image_path TEXT,
            item_name TEXT,
            description TEXT,
            season TEXT,
            date TEXT,
            FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE ON UPDATE CASCADE
          );
        ''');

        // Item <-> Category join table
        await db.execute('''
          CREATE TABLE item_categories_join (
            item_id INTEGER,
            category_id INTEGER,
            PRIMARY KEY (item_id, category_id),
            FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (category_id) REFERENCES items_categories(category_id) ON DELETE CASCADE ON UPDATE CASCADE
          );
        ''');

        // Outfit categories
        await db.execute('''
          CREATE TABLE outfit_categories (
            category_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            category_name TEXT,
            FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE ON UPDATE CASCADE

          );
        ''');

        // Insert initial outfit categories - FIXED: Changed " to '
        await db.execute('INSERT INTO outfit_categories (category_name) VALUES (\'Casual\')');
        await db.execute('INSERT INTO outfit_categories (category_name) VALUES (\'Formal\')');
        await db.execute('INSERT INTO outfit_categories (category_name) VALUES (\'Workwear\')');
        await db.execute('INSERT INTO outfit_categories (category_name) VALUES (\'Athletic\')');
        await db.execute('INSERT INTO outfit_categories (category_name) VALUES (\'Party\')');
        await db.execute('INSERT INTO outfit_categories (category_name) VALUES (\'Date Night\')');
        await db.execute('INSERT INTO outfit_categories (category_name) VALUES (\'Vacation\')');
        await db.execute('INSERT INTO outfit_categories (category_name) VALUES (\'Seasonal\')');

        // Outfits (CREATE WITHOUT category_id field)
        await db.execute('''
          CREATE TABLE outfits (
            outfit_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            outfit_name TEXT,
            description TEXT,
            date TEXT,
            season TEXT,
            FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE ON UPDATE CASCADE
          );
        ''');

        // Outfit <-> Item join
        await db.execute('''
          CREATE TABLE outfit_item (
            outfit_id INTEGER,
            item_id INTEGER,
            PRIMARY KEY (outfit_id, item_id),
            FOREIGN KEY (outfit_id) REFERENCES outfits(outfit_id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE ON UPDATE CASCADE
          );
        ''');

        // Outfit <-> Category join (NEW - many-to-many relationship)
        await db.execute('''
          CREATE TABLE outfit_category_join (
            outfit_id INTEGER,
            category_id INTEGER,
            PRIMARY KEY (outfit_id, category_id),
            FOREIGN KEY (outfit_id) REFERENCES outfits(outfit_id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (category_id) REFERENCES outfit_categories(category_id) ON DELETE CASCADE ON UPDATE CASCADE
          );
        ''');

        // Posts
        await db.execute('''
          CREATE TABLE posts (
            post_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            outfit_id INTEGER,
            image_path TEXT,
            caption TEXT,
            date TEXT,
            FOREIGN KEY (outfit_id) REFERENCES outfits(outfit_id) ON DELETE SET NULL ON UPDATE CASCADE
          );
        ''');

        // Comments
        await db.execute('''
          CREATE TABLE comments (
            comment_id INTEGER PRIMARY KEY AUTOINCREMENT,
            post_id INTEGER,
            user_id INTEGER,
            content TEXT,
            date TEXT,
            FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE ON UPDATE CASCADE
          );
        ''');

        // Likes
        await db.execute('''
          CREATE TABLE likes (
            like_id INTEGER PRIMARY KEY AUTOINCREMENT,
            post_id INTEGER,
            user_id INTEGER,
            date TEXT,
            FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE ON UPDATE CASCADE
          );
        ''');

        // Sync Queue Table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS sync_queue (
            queue_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            action TEXT,
            entity_type TEXT,
            entity_id INTEGER,
            entity_data TEXT,
            created_at TEXT,
            processed INTEGER DEFAULT 0,
            processed_at TEXT,
            retry_count INTEGER DEFAULT 0,
            FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE
          );
        ''');

        print('✅ Created sync_queue table');
      },
    );

    return _database!;
  }
}