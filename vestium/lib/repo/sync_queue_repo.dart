// lib/repo/sync_queue_repo.dart
import 'package:sqflite/sqflite.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import 'dart:convert';

class SyncQueueRepo {
  late Database _db;
  
  Future<void> init() async {
    _db = await DBHelper.getDatabase();
  }
  
  Future<List<SyncQueueModel>> getPendingOperations() async {
    try {
      final maps = await _db.query(
        'sync_queue',
        where: 'processed = 0',
        orderBy: 'created_at ASC',
      );
      
      return maps.map((map) {
        // Parse entity_data from JSON string to Map
        final entityData = map['entity_data'] as String?;
        Map<String, dynamic> entityDataMap = {};
        
        if (entityData != null && entityData.isNotEmpty) {
          try {
            entityDataMap = json.decode(entityData);
          } catch (e) {
            print('❌ Error parsing entity_data JSON: $e');
          }
        }
        
        return SyncQueueModel.fromMap({
          ...map,
          'entity_data': entityDataMap, // Pass as Map, not String
        });
      }).toList();
    } catch (e) {
      print('❌ Error getting pending operations: $e');
      return [];
    }
  }
  
  Future<int> insert(SyncQueueModel entry) async {
    try {
      // Convert entityData Map to JSON string for storage
      final entityDataJson = json.encode(entry.entityData);
      
      final map = {
        ...entry.toMap(),
        'entity_data': entityDataJson, // Store as JSON string
      };
      
      return await _db.insert(
        'sync_queue',
        map,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('❌ Error inserting sync entry: $e');
      return 0;
    }
  }
  
  Future<int> update(int queueId, SyncQueueModel entry) async {
    try {
      // Convert entityData Map to JSON string for storage
      final entityDataJson = entry.entityData;
      
      final map = {
        ...entry.toMap(),
        'entity_data': entityDataJson,
      };
      
      return await _db.update(
        'sync_queue',
        map,
        where: 'queue_id = ?',
        whereArgs: [queueId],
      );
    } catch (e) {
      print('❌ Error updating sync entry: $e');
      return 0;
    }
  }
  
  Future<int> deleteProcessed() async {
    try {
      return await _db.delete(
        'sync_queue',
        where: 'processed = 1',
      );
    } catch (e) {
      print('❌ Error deleting processed entries: $e');
      return 0;
    }
  }
  
  Future<int> cleanupOldOperations({int days = 7}) async {
    try {
      final cutoff = DateTime.now().subtract(Duration(days: days)).toIso8601String();
      
      return await _db.delete(
        'sync_queue',
        where: 'processed = 1 AND created_at < ?',
        whereArgs: [cutoff],
      );
    } catch (e) {
      print('❌ Error cleaning up old operations: $e');
      return 0;
    }
  }
  
  Future<int> getPendingCount() async {
    try {
      final result = await _db.rawQuery(
        'SELECT COUNT(*) as count FROM sync_queue WHERE processed = 0'
      );
      return result.first['count'] as int;
    } catch (e) {
      print('❌ Error getting pending count: $e');
      return 0;
    }
  }

  Future<Database> getDatabase() async {
    if (!_db.isOpen) {
      _db = await DBHelper.getDatabase();
    }
    return _db;
  }
}