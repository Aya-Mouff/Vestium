// import 'package:sqflite/sqflite.dart';
// import '../databases/db_helper.dart';
// import '../databases/db_models.dart';

// class OutfitItemRepo {
//   Future<List<OutfitItem>> getAll() async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('outfit_item');
//     return res.map((m) => OutfitItem.fromMap(m)).toList();
//   }

//   Future<List<OutfitItem>> getByOutfitId(int outfitId) async {
//     final db = await DBHelper.getDatabase();
//     final res = await db.query('outfit_item', where: 'outfit_id = ?', whereArgs: [outfitId]);
//     return res.map((m) => OutfitItem.fromMap(m)).toList();
//   }

//   Future<bool> insert(OutfitItem oi) async {
//     final db = await DBHelper.getDatabase();
//     await db.insert('outfit_item', oi.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
//     return true;
//   }

//   Future<bool> update(Map<String, int> oldKeys, OutfitItem newValue) async {
//     final db = await DBHelper.getDatabase();
//     await db.update(
//       'outfit_item',
//       newValue.toMap(),
//       where: 'outfit_id = ? AND item_id = ?',
//       whereArgs: [oldKeys['outfit_id'], oldKeys['item_id']],
//     );
//     return true;
//   }

//   Future<bool> delete(int outfitId, int itemId) async {
//     final db = await DBHelper.getDatabase();
//     await db.delete(
//       'outfit_item',
//       where: 'outfit_id = ? AND item_id = ?',
//       whereArgs: [outfitId, itemId],
//     );
//     return true;
//   }
// }

// ===============================================================

// lib/repo/outfit_item_repo.dart - FINAL VERSION
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import '../services/sync_manager.dart';

class OutfitItemRepo {
  static final OutfitItemRepo _instance = OutfitItemRepo._internal();
  factory OutfitItemRepo() => _instance;
  OutfitItemRepo._internal();
  
  final SyncManager _syncManager = SyncManager();
  
  // KEEP ALL ORIGINAL METHODS
  
  Future<List<OutfitItem>> getAll() async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('outfit_item');
    return res.map((m) => OutfitItem.fromMap(m)).toList();
  }

  Future<List<OutfitItem>> getByOutfitId(int outfitId) async {
    final db = await DBHelper.getDatabase();
    final res = await db.query('outfit_item', where: 'outfit_id = ?', whereArgs: [outfitId]);
    return res.map((m) => OutfitItem.fromMap(m)).toList();
  }

  // ORIGINAL insert method with sync added
  Future<bool> insert(OutfitItem oi) async {
    final db = await DBHelper.getDatabase();
    
    // ORIGINAL LOGIC
    await db.insert('outfit_item', oi.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    
    // NEW SYNC LOGIC ONLY
    await _queueForSync('create', oi);
    
    return true;
  }

  // ORIGINAL update method with sync added
  Future<bool> update(Map<String, int> oldKeys, OutfitItem newValue) async {
    final db = await DBHelper.getDatabase();
    
    // ORIGINAL LOGIC
    await db.update(
      'outfit_item',
      newValue.toMap(),
      where: 'outfit_id = ? AND item_id = ?',
      whereArgs: [oldKeys['outfit_id'], oldKeys['item_id']],
    );
    
    // NEW SYNC LOGIC ONLY - For updates, queue both delete old and create new
    if (_isServerId(oldKeys['outfit_id']!) && _isServerId(oldKeys['item_id']!)) {
      await _queueForSync('delete', OutfitItem(
        outfitId: oldKeys['outfit_id']!,
        itemId: oldKeys['item_id']!,
      ));
    }
    
    await _queueForSync('create', newValue);
    
    return true;
  }

  // ORIGINAL delete method with sync added
  Future<bool> delete(int outfitId, int itemId) async {
    final db = await DBHelper.getDatabase();
    
    // ORIGINAL LOGIC
    await db.delete(
      'outfit_item',
      where: 'outfit_id = ? AND item_id = ?',
      whereArgs: [outfitId, itemId],
    );
    
    // NEW SYNC LOGIC ONLY
    await _queueForSync('delete', OutfitItem(outfitId: outfitId, itemId: itemId));
    
    return true;
  }
  
  // NEW: Helper method for sync logic ONLY
  Future<void> _queueForSync(String action, OutfitItem oi) async {
    // Only sync if both IDs are server IDs (≥ 1000)
    if (_isServerId(oi.outfitId) && _isServerId(oi.itemId)) {
      final data = {
        'outfit_id': oi.outfitId,
        'item_id': oi.itemId,
      };
      
      await _syncManager.queueOutfitItemOperation(
        action: action,
        data: data,
      );
      
      print('✅ Outfit-item $action queued for sync (outfit: ${oi.outfitId}, item: ${oi.itemId})');
    } else {
      print('ℹ️ Local outfit-item operation - not queued for sync');
    }
  }
  
  // NEW: Check if ID is from server
  bool _isServerId(int id) {
    return id >= 1000;
  }
}