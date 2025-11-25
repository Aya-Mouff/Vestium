import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _databaseName = "vestium_database.db";
  static const _databaseVersion = 1;
  static Database? _database;

  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onConfigure: (db) async {
        // Enable foreign key constraints
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

        // Follow relationships (composite PK) - both reference user(user_id)
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

        // Items
        await db.execute('''
          CREATE TABLE items (
            item_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            image_path TEXT,
            category_id INTEGER,
            item_name TEXT,
            description TEXT,
            season TEXT,
            date TEXT,
            FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (category_id) REFERENCES items_categories(category_id) ON DELETE SET NULL ON UPDATE CASCADE
          );
        ''');

        // Outfit categories
        await db.execute('''
          CREATE TABLE outfit_categories (
            category_id INTEGER PRIMARY KEY AUTOINCREMENT,
            category_name TEXT
          );
        ''');

        // Outfits
        await db.execute('''
          CREATE TABLE outfits (
            outfit_id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            outfit_name TEXT,
            description TEXT,
            category_id INTEGER,
            date TEXT,
            season TEXT,
            FOREIGN KEY (user_id) REFERENCES user(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (category_id) REFERENCES outfit_categories(category_id) ON DELETE SET NULL ON UPDATE CASCADE
          );
        ''');

        // Outfit <-> Item join (composite PK)
        await db.execute('''
          CREATE TABLE outfit_item (
            outfit_id INTEGER,
            item_id INTEGER,
            PRIMARY KEY (outfit_id, item_id),
            FOREIGN KEY (outfit_id) REFERENCES outfits(outfit_id) ON DELETE CASCADE ON UPDATE CASCADE,
            FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE ON UPDATE CASCADE
          );
        ''');

        // Posts (an outfit can have posts)
        await db.execute('''
          CREATE TABLE posts (
            post_id INTEGER PRIMARY KEY AUTOINCREMENT,
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
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Implement migrations here when you bump _databaseVersion.
        // e.g., alter tables, create new tables, migrate data, etc.
      },
    );

    return _database!;
  }
}
