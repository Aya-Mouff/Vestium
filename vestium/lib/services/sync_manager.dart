// lib/services/sync_manager.dart
import 'dart:async';
import 'dart:convert';
//import 'package:sqflite/sqflite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../databases/db_helper.dart';
import '../databases/db_models.dart';
import '../services/api_service.dart';
import '../repo/item_repo.dart';
import '../repo/outfit_repo.dart';
import '../repo/post_repo.dart';
import '../repo/comment_repo.dart';
import '../repo/like_repo.dart';
import '../repo/follow_repo.dart';
import '../services/sync_queue_service.dart';

class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal();

  final StreamController<double> _progressController =
      StreamController<double>.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  // Services
  final ApiService _api = ApiService();
  final Connectivity _connectivity = Connectivity();
  final SyncQueueService _syncQueue = SyncQueueService();

  // Repositories
  final ItemRepo _itemRepo = ItemRepo();
  final OutfitRepo _outfitRepo = OutfitRepo();
  final PostRepo _postRepo = PostRepo();
  final CommentRepo _commentRepo = CommentRepo();
  final LikeRepo _likeRepo = LikeRepo();
  final FollowRepo _followRepo = FollowRepo();

  // State
  bool _isSyncing = false;
  Timer? _syncTimer;
  Duration _syncInterval = Duration(
    minutes: 5,
  ); // Default: sync every 5 minutes

  // Stream for UI updates
  final StreamController<String> _syncStream =
      StreamController<String>.broadcast();
  Stream<String> get onSync => _syncStream.stream;

  // ========== INITIALIZATION ==========
  Future<void> init() async {
    print('🔄 SyncManager initialized');

    // Initialize sync queue service
    await _syncQueue.init();

    // Start periodic sync timer
    _startSyncTimer();

    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        _syncStream.add('Online - starting sync...');
        _startSyncTimer(); // Restart timer when online
        unawaited(syncAll()); // Trigger sync
      } else {
        _syncStream.add('Offline - operations will be queued');
        _stopSyncTimer(); // Stop timer when offline
      }
    });

    print(
      '✅ SyncManager ready: periodic sync every ${_syncInterval.inMinutes} minutes',
    );
  }

  // ========== TIMER MANAGEMENT ==========
  void _startSyncTimer() {
    _stopSyncTimer(); // Stop existing timer if any

    _syncTimer = Timer.periodic(_syncInterval, (timer) async {
      if (await isOnline()) {
        print('⏰ Periodic sync triggered');
        _syncStream.add('Periodic sync starting...');
        await syncAll();
      }
    });

    print('⏰ Started sync timer (every ${_syncInterval.inMinutes} minutes)');
  }

  void _stopSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  void setSyncInterval(Duration interval) {
    _syncInterval = interval;
    _startSyncTimer();
    print('⏰ Sync interval updated to ${interval.inMinutes} minutes');
  }

  // ========== MAIN SYNC COORDINATION ==========
  Future<bool> syncAll() async {
    if (_isSyncing) return false;
    _isSyncing = true;

    try {
      // 0% - Starting
      _progressController.add(0.0);
      _syncStream.add('Starting sync...');

      if (!await isOnline()) {
        _syncStream.add('Offline');
        return false;
      }

      // 10% - Getting pending count
      _progressController.add(0.1);
      final pendingCount = await _syncQueue.getPendingCount();

      if (pendingCount > 0) {
        // 20-40% - Pushing (progress based on count)
        _progressController.add(0.2);
        await _pushPendingOperations();
        _progressController.add(0.4);
      } else {
        // Skip to 40% if nothing to push
        _progressController.add(0.4);
      }

      // 50-70% - Pulling data
      _progressController.add(0.5);
      await _pullLatestData();
      _progressController.add(0.7);

      // 80% - Processing
      _progressController.add(0.8);
      await _processServerQueue();

      // 90% - Cleanup
      _progressController.add(0.9);
      await _cleanupOldEntries();

      // 100% - Complete
      _progressController.add(1.0);
      _syncStream.add('✅ Sync complete');

      // Reset after delay
      Future.delayed(Duration(seconds: 2), () {
        _progressController.add(0.0);
      });

      return true;
    } catch (e) {
      _progressController.add(0.0);
      _syncStream.add('❌ Sync failed: $e');
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  // ========== PUSH LOCAL CHANGES ==========
  Future<bool> _pushPendingOperations() async {
    try {
      _syncStream.add('📤 Pushing local changes to server...');

      // Get pending operations
      final pendingOps = await _syncQueue.getPendingOperations();

      if (pendingOps.isEmpty) {
        _syncStream.add('No pending operations to push');
        return true;
      }

      print('📤 Pushing ${pendingOps.length} operations...');
      _syncStream.add('Pushing ${pendingOps.length} operations');

      int success = 0;
      int failed = 0;

      // Send each operation to server
      for (final op in pendingOps) {
        try {
          // Skip if too many retries
          if (op.retryCount >= 3) {
            print('⚠️ Skipping operation ${op.queueId} (too many retries)');
            failed++;
            continue;
          }

          // Convert entityData to JSON string for API
          final entityDataJson = json.encode(op.entityData);

          final response = await _api.syncQueueOperation({
            'action': op.action,
            'entity_type': op.entityType,
            'entity_data': entityDataJson, // Send as JSON string
            'entity_id': op.entityId,
          });

          if (response['success']) {
            // Mark as processed
            await _syncQueue.markAsProcessed(op.queueId!);
            success++;

            // If this was a create operation, update local ID
            if (response['server_id'] != null && op.entityId != null) {
              await _updateLocalId(
                entityType: op.entityType,
                localId: op.entityId!,
                serverId: response['server_id'],
              );
            }
          } else {
            failed++;
            print('❌ Operation ${op.queueId} failed on server');
          }
        } catch (e) {
          print('❌ Operation ${op.queueId} failed: $e');
          failed++;
        }
      }

      _syncStream.add('📤 Push completed: $success success, $failed failed');
      print('📤 Push stats: $success/${pendingOps.length} operations');

      return failed == 0;
    } catch (e) {
      _syncStream.add('❌ Push failed: $e');
      print('❌ _pushPendingOperations error: $e');
      return false;
    }
  }

  // ========== PULL LATEST DATA ==========
  Future<bool> _pullLatestData() async {
    try {
      _syncStream.add('📥 Pulling latest data from server...');

      final response = await _api.syncPull();

      if (response['success']) {
        final data = response['data'];

        // Save to local database
        await _savePulledData(data);

        _syncStream.add('📥 Pull completed successfully');
        return true;
      } else {
        _syncStream.add('❌ Pull failed: ${response['error']}');
        return false;
      }
    } catch (e) {
      _syncStream.add('❌ Pull failed: $e');
      print('❌ _pullLatestData error: $e');
      return false;
    }
  }

  Future<void> _savePulledData(Map<String, dynamic> data) async {
    final db = await DBHelper.getDatabase();

    await db.transaction((txn) async {
      // Save items
      if (data['items'] != null && data['items'] is List) {
        for (final itemData in data['items']) {
          try {
            final item = ItemModel.fromJson(itemData);
            await _itemRepo.insert(item);
          } catch (e) {
            print('❌ Error saving item: $e');
          }
        }
        print('📥 Saved ${data['items'].length} items');
      }

      // Save outfits
      if (data['outfits'] != null && data['outfits'] is List) {
        for (final outfitData in data['outfits']) {
          try {
            final outfit = OutfitModel.fromJson(outfitData);
            await _outfitRepo.insert(outfit);
          } catch (e) {
            print('❌ Error saving outfit: $e');
          }
        }
        print('📥 Saved ${data['outfits'].length} outfits');
      }

      // Save posts
      if (data['posts'] != null && data['posts'] is List) {
        for (final postData in data['posts']) {
          try {
            final post = PostModel.fromJson(postData);
            await _postRepo.insert(post);
          } catch (e) {
            print('❌ Error saving post: $e');
          }
        }
        print('📥 Saved ${data['posts'].length} posts');
      }

      // Save comments
      if (data['comments'] != null && data['comments'] is List) {
        for (final commentData in data['comments']) {
          try {
            final comment = CommentModel.fromJson(commentData);
            await _commentRepo.insert(comment);
          } catch (e) {
            print('❌ Error saving comment: $e');
          }
        }
      }

      // Save likes
      if (data['likes'] != null && data['likes'] is List) {
        for (final likeData in data['likes']) {
          try {
            final like = LikeModel.fromJson(likeData);
            await _likeRepo.insert(like);
          } catch (e) {
            print('❌ Error saving like: $e');
          }
        }
      }

      // Save follows
      if (data['following'] != null && data['following'] is List) {
        for (final followData in data['following']) {
          try {
            final follow = FollowingFollower.fromJson(followData);
            await _followRepo.insert(follow);
          } catch (e) {
            print('❌ Error saving follow: $e');
          }
        }
      }
    });
  }

  // ========== HELPER METHODS ==========
  Future<void> _updateLocalId({
    required String entityType,
    required int localId,
    required int serverId,
  }) async {
    final db = await DBHelper.getDatabase();

    switch (entityType) {
      case 'item':
        await db.update(
          'items',
          {'item_id': serverId},
          where: 'item_id = ?',
          whereArgs: [localId],
        );
        break;
      case 'outfit':
        await db.update(
          'outfits',
          {'outfit_id': serverId},
          where: 'outfit_id = ?',
          whereArgs: [localId],
        );
        break;
      case 'post':
        await db.update(
          'posts',
          {'post_id': serverId},
          where: 'post_id = ?',
          whereArgs: [localId],
        );
        break;
    }

    print('🔄 Updated local $entityType ID: $localId → $serverId');
  }

  Future<void> _processServerQueue() async {
    try {
      await _api.syncProcess();
      print('✅ Processed server queue');
    } catch (e) {
      print('⚠️ Server queue processing failed: $e');
    }
  }

  Future<void> _cleanupOldEntries() async {
    try {
      final db = await DBHelper.getDatabase();
      final weekAgo = DateTime.now()
          .subtract(Duration(days: 7))
          .toIso8601String();

      final deleted = await db.delete(
        'sync_queue',
        where: 'processed = 1 AND created_at < ?',
        whereArgs: [weekAgo],
      );

      if (deleted > 0) {
        print('🧹 Cleaned $deleted old sync entries');
      }
    } catch (e) {
      print('⚠️ Cleanup failed: $e');
    }
  }

  // ========== PUBLIC QUEUE METHODS (for repositories) ==========
  Future<bool> queueItemOperation({
    required String action,
    required Map<String, dynamic> data,
    int? entityId,
  }) async {
    return await _queueGenericOperation(
      entityType: 'item',
      action: action,
      data: data,
      entityId: entityId,
    );
  }

  Future<bool> queueOutfitOperation({
    required String action,
    required Map<String, dynamic> data,
    int? entityId,
  }) async {
    return await _queueGenericOperation(
      entityType: 'outfit',
      action: action,
      data: data,
      entityId: entityId,
    );
  }

  Future<bool> queuePostOperation({
    required String action,
    required Map<String, dynamic> data,
    int? entityId,
  }) async {
    return await _queueGenericOperation(
      entityType: 'post',
      action: action,
      data: data,
      entityId: entityId,
    );
  }

  Future<bool> queueCommentOperation({
    required String action,
    required Map<String, dynamic> data,
    int? entityId,
  }) async {
    return await _queueGenericOperation(
      entityType: 'comment',
      action: action,
      data: data,
      entityId: entityId,
    );
  }

  Future<bool> queueLikeOperation({
    required String action,
    required Map<String, dynamic> data,
    int? entityId,
  }) async {
    return await _queueGenericOperation(
      entityType: 'like',
      action: action,
      data: data,
      entityId: entityId,
    );
  }

  Future<bool> queueFollowOperation({
    required String action,
    required Map<String, dynamic> data,
    int? entityId,
  }) async {
    return await _queueGenericOperation(
      entityType: 'follow',
      action: action,
      data: data,
      entityId: entityId,
    );
  }

  Future<bool> _queueGenericOperation({
    required String entityType,
    required String action,
    required Map<String, dynamic> data,
    int? entityId,
  }) async {
    try {
      // Get user ID
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        print('⚠️ No user ID for queue operation');
        return false;
      }

      _syncQueue.setUserId(userId);

      // Call appropriate SyncQueueService method
      switch (entityType) {
        case 'item':
          if (action == 'create') {
            await _syncQueue.queueCreateItem(data);
          } else if (action == 'update') {
            await _syncQueue.queueUpdateItem(data);
          } else if (action == 'delete') {
            await _syncQueue.queueDeleteItem(entityId!);
          }
          break;

        case 'outfit':
          if (action == 'create') {
            await _syncQueue.queueCreateOutfit(data);
          } else if (action == 'update') {
            await _syncQueue.queueUpdateOutfit(data);
          } else if (action == 'delete') {
            await _syncQueue.queueDeleteOutfit(entityId!);
          }
          break;

        case 'post':
          if (action == 'create') {
            await _syncQueue.queueCreatePost(data);
          } else if (action == 'update') {
            await _syncQueue.queueUpdatePost(data);
          } else if (action == 'delete') {
            await _syncQueue.queueDeletePost(entityId!);
          }
          break;

        case 'item_category': // ADD THIS
          if (action == 'create') {
            await _syncQueue.queueCreateItemCategory(data, localId: entityId);
          } else if (action == 'update') {
            await _syncQueue.queueUpdateItemCategory(data);
          } else if (action == 'delete') {
            await _syncQueue.queueDeleteItemCategory(entityId!);
          }
          break;

        case 'outfit_category': // ADD THIS
          if (action == 'create') {
            await _syncQueue.queueCreateOutfitCategory(data, localId: entityId);
          } else if (action == 'update') {
            await _syncQueue.queueUpdateOutfitCategory(data);
          } else if (action == 'delete') {
            await _syncQueue.queueDeleteOutfitCategory(entityId!);
          }
          break;

        case 'comment':
          if (action == 'create') {
            await _syncQueue.queueCreateComment(data);
          }
          break;

        case 'like':
          if (action == 'create') {
            await _syncQueue.queueCreateLike(data);
          } else if (action == 'delete') {
            await _syncQueue.queueDeleteLike(data);
          }
          break;

        case 'follow':
          if (action == 'create') {
            await _syncQueue.queueFollow(data);
          } else if (action == 'delete') {
            await _syncQueue.queueUnfollow(data);
          }
          break;
      }

      print('✅ Queued $action for $entityType');
      _syncStream.add('Operation queued locally');

      // Try to sync immediately if online
      if (await isOnline() && !_isSyncing) {
        unawaited(syncAll());
      }

      return true;
    } catch (e) {
      print('❌ Queue failed: $e');
      return false;
    }
  }

  Future<bool> queueItemCategoryOperation({
    required String action,
    required Map<String, dynamic> data,
    int? entityId,
  }) async {
    return await _queueGenericOperation(
      entityType: 'item_category',
      action: action,
      data: data,
      entityId: entityId,
    );
  }

  Future<bool> queueOutfitCategoryOperation({
    required String action,
    required Map<String, dynamic> data,
    int? entityId,
  }) async {
    return await _queueGenericOperation(
      entityType: 'outfit_category',
      action: action,
      data: data,
      entityId: entityId,
    );
  }

  // ========== PUBLIC METHODS ==========

  // Initial sync (on login)
  Future<bool> initialSync() async {
    try {
      _syncStream.add('🚀 Starting initial sync...');

      // First pull data from server
      await _pullLatestData();

      // Then push any local changes
      await _pushPendingOperations();

      _syncStream.add('✅ Initial sync completed');
      return true;
    } catch (e) {
      _syncStream.add('❌ Initial sync failed: $e');
      return false;
    }
  }

  // Manual sync
  Future<void> manualSync() async {
    _syncStream.add('👆 Manual sync requested');
    await syncAll();
  }

  // Check if online
  Future<bool> isOnline() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  // Get sync status
  Future<Map<String, dynamic>> getStatus() async {
    try {
      final pendingCount = await _syncQueue.getPendingCount();
      final online = await isOnline();

      return {
        'online': online,
        'pending': pendingCount,
        'syncing': _isSyncing,
        'interval_minutes': _syncInterval.inMinutes,
      };
    } catch (e) {
      return {
        'online': false,
        'pending': 0,
        'syncing': false,
        'error': e.toString(),
      };
    }
  }

  // Get pending count
  Future<int> getPendingCount() async {
    return await _syncQueue.getPendingCount();
  }

  // Clear all pending
  Future<void> clearQueue() async {
    final db = await DBHelper.getDatabase();
    await db.delete('sync_queue');
    _syncStream.add('🧹 Cleared all pending operations');
  }

  // Force sync now (for testing)
  Future<bool> syncNow() async {
    return await syncAll();
  }

  // Dispose (call when app closes)
  void dispose() {
    _stopSyncTimer();
    _syncStream.close();
    print('🛑 SyncManager disposed');
  }
}

// Global instance for easy access
SyncManager syncManager = SyncManager();
