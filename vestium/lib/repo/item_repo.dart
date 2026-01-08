// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class ItemRepo {
//   Future<List<ItemModel>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('items');
//     return res.map((m) => ItemModel.fromMap(m)).toList();
//   }

//   Future<List<ItemModel>> getByUserId(int userId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'items', 
//       where: 'user_id = ?', 
//       whereArgs: [userId],
//       orderBy: 'date DESC',
//     );
//     return res.map((m) => ItemModel.fromMap(m)).toList();
//   }

//   Future<ItemModel?> getById(int itemId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'items',
//       where: 'item_id = ?',
//       whereArgs: [itemId],
//     );
//     if (res.isEmpty) return null;
//     return ItemModel.fromMap(res.first);
//   }

//   Future<int> insert(ItemModel item) async {
//     final db = await DBHelper.getDatabase();
//     final id = await db.insert(
//       'items', 
//       item.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     return id;
//   }

//   Future<bool> update(int id, ItemModel item) async {
//     final db = await DBHelper.getDatabase();
//     await db.update(
//       'items', 
//       item.toMap(), 
//       where: 'item_id = ?', 
//       whereArgs: [id]
//     );
//     return true;
//   }

//   Future<bool> delete(int id) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete('items', where: 'item_id = ?', whereArgs: [id]);
//     return true;
//   }

//   Future<List<ItemModel>> getBySeason(String season) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query(
//       'items',
//       where: 'season = ?',
//       whereArgs: [season],
//     );
//     return res.map((m) => ItemModel.fromMap(m)).toList();
//   }

//   Future<int> insertWithId(ItemModel item) async {
//     final db = await DBHelper.getDatabase();
    
//     // Check if item with this ID already exists
//     final existing = await db.query(
//       'items',
//       where: 'item_id = ?',
//       whereArgs: [item.itemId],
//     );
    
//     if (existing.isNotEmpty) {
//       // Update existing
//       await db.update('items', item.toMap(), 
//         where: 'item_id = ?', whereArgs: [item.itemId]);
//       return item.itemId!;
//     } else {
//       // Insert new with specific ID
//       await db.insert('items', item.toMap());
//       return item.itemId!;
//     }
//   }

//   // NEW: Get items that need sync (without backend ID)
//   Future<List<ItemModel>> getUnsyncedItems(int userId) async {
//     final db = await DBHelper.getDatabase();
    
//     // Assuming local-only items have IDs < 1000
//     final result = await db.query(
//       'items',
//       where: 'user_id = ? AND item_id < 1000',
//       whereArgs: [userId],
//     );
    
//     return result.map((m) => ItemModel.fromMap(m)).toList();
//   }
// }

// --------------------------------------------------------------------------------------------------

// lib/repo/item_repo.dart - CORRECTED VERSION
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import '../services/sync_manager.dart';
import 'abstract_repo.dart';

class ItemRepo implements AbstractRepo<ItemModel> {
  static final ItemRepo _instance = ItemRepo._internal();
  factory ItemRepo() => _instance;
  ItemRepo._internal();
  
  // Add these fields (not getters)
  final SyncManager _syncManager = SyncManager();
  
  @override
  String get tableName => 'items';
  
  @override
  String get primaryKey => 'item_id';
  
  @override
  Map<String, dynamic> toMap(ItemModel item) {
    return {
      'item_id': item.itemId,
      'user_id': item.userId,
      'image_path': item.imagePath,
      'item_name': item.itemName,
      'description': item.description,
      'season': item.season,
      'date': item.date,
    };
  }
  
  @override
  ItemModel fromMap(Map<String, dynamic> map) {
    return ItemModel(
      itemId: map['item_id'],
      userId: map['user_id'],
      imagePath: map['image_path'],
      itemName: map['item_name'],
      description: map['description'],
      season: map['season'],
      date: map['date'],
    );
  }
  
  // Add these ID helper methods:
  @override
  bool isLocalId(int id) => id < 1000;
  
  @override
  bool isServerId(int id) => id >= 1000;
  
  // Core CRUD methods:
  
  @override
  Future<List<ItemModel>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(tableName);
    return res.map((m) => fromMap(m)).toList();
  }

  @override
  Future<ItemModel?> getById(int itemId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      tableName,
      where: '$primaryKey = ?',
      whereArgs: [itemId],
    );
    if (res.isEmpty) return null;
    return fromMap(res.first);
  }

  @override
  Future<int> insert(ItemModel item) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Save to local database
    final localMap = toMap(item);
    final localId = await db.insert(
      tableName, 
      localMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
    // 2. Queue for sync
    await queueCreateOperation(item, localId);
    
    return localId;
  }

  @override
  Future<bool> update(int id, ItemModel item) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Update local database
    await db.update(
      tableName, 
      toMap(item), 
      where: '$primaryKey = ?', 
      whereArgs: [id]
    );
    
    // 2. Queue for sync (only if server ID)
    if (isServerId(id)) {
      await queueUpdateOperation(id, item);
    }
    
    return true;
  }

  @override
  Future<bool> delete(int id) async {
    final db = await DBHelper.getDatabase();
    
    // 1. Get item before deletion (for sync data)
    final item = await getById(id);
    
    // 2. Delete from local database
    await db.delete(tableName, where: '$primaryKey = ?', whereArgs: [id]);
    
    // 3. Queue for sync (only if server ID)
    if (isServerId(id) && item != null) {
      await queueDeleteOperation(id);
    }
    
    return true;
  }

  // Sync queue methods:
  
  @override
  Future<void> queueCreateOperation(ItemModel item, int localId) async {
    final itemWithLocalId = item.copyWith(itemId: localId);
    
    await _syncManager.queueItemOperation(
      action: 'create',
      data: itemWithLocalId.toMap(),
      entityId: localId,
    );
    
    print('✅ Queued item create: $localId');
  }
  
  @override
  Future<void> queueUpdateOperation(int id, ItemModel item) async {
    await _syncManager.queueItemOperation(
      action: 'update',
      data: item.toMap(),
      entityId: id,
    );
    
    print('✅ Queued item update: $id');
  }
  
  @override
  Future<void> queueDeleteOperation(int id) async {
    await _syncManager.queueItemOperation(
      action: 'delete',
      data: {'item_id': id},
      entityId: id,
    );
    
    print('✅ Queued item delete: $id');
  }
  
  // Additional custom methods (not from AbstractRepo):
  
  Future<List<ItemModel>> getByUserId(int userId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      tableName, 
      where: 'user_id = ?', 
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
    return res.map((m) => fromMap(m)).toList();
  }

  Future<List<ItemModel>> getBySeason(String season) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query(
      tableName,
      where: 'season = ?',
      whereArgs: [season],
    );
    return res.map((m) => fromMap(m)).toList();
  }

  Future<int> insertWithId(ItemModel item) async {
    final db = await DBHelper.getDatabase();
    
    // Check if item with this ID already exists
    final existing = await db.query(
      tableName,
      where: '$primaryKey = ?',
      whereArgs: [item.itemId],
    );
    
    if (existing.isNotEmpty) {
      // Update existing
      await db.update(tableName, toMap(item), 
        where: '$primaryKey = ?', whereArgs: [item.itemId]);
      return item.itemId!;
    } else {
      // Insert new with specific ID (used for sync pull)
      await db.insert(tableName, toMap(item));
      return item.itemId!;
    }
  }

  Future<List<ItemModel>> getUnsyncedItems(int userId) async {
    final db = await DBHelper.getDatabase();
    
    // Local-only items have IDs < 1000
    final result = await db.query(
      tableName,
      where: 'user_id = ? AND $primaryKey < 1000',
      whereArgs: [userId],
    );
    
    return result.map((m) => fromMap(m)).toList();
  }
}