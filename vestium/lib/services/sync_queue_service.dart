// lib/services/sync_queue_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:vestium/repo/sync_queue_repo.dart';
import '../databases/db_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncQueueService {
  static final SyncQueueService _instance = SyncQueueService._internal();
  factory SyncQueueService() => _instance;
  SyncQueueService._internal();

  final SyncQueueRepo _repo = SyncQueueRepo();
  int? _currentUserId;

  Future<void> init() async {
    await _repo.init();
    // Get current user ID from shared preferences
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getInt('user_id');
  }

  void setUserId(int userId) {
    _currentUserId = userId;
  }

  // ========== QUEUE METHODS FOR YOUR REPOSITORIES ==========

  Future<void> queueCreateItem(
    Map<String, dynamic> itemData, {
    int? localId,
  }) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'create',
      entityType: 'item',
      entityData: itemData,
      entityId: localId, // Use localId for creates
    );
  }

  Future<void> queueUpdateItem(Map<String, dynamic> itemData) async {
    if (_currentUserId == null) return;

    final itemId = itemData['item_id'] ?? itemData['itemId'];
    if (itemId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'update',
      entityType: 'item',
      entityId: itemId,
      entityData: itemData,
    );
  }

  Future<void> queueDeleteItem(int itemId) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'delete',
      entityType: 'item',
      entityId: itemId,
      entityData: {'item_id': itemId},
    );
  }

  Future<void> queueCreateOutfit(
    Map<String, dynamic> outfitData, {
    int? localId,
  }) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'create',
      entityType: 'outfit',
      entityData: outfitData,
      entityId: localId,
    );
  }

  Future<void> queueUpdateOutfit(Map<String, dynamic> outfitData) async {
    if (_currentUserId == null) return;

    final outfitId = outfitData['outfit_id'] ?? outfitData['outfitId'];
    if (outfitId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'update',
      entityType: 'outfit',
      entityId: outfitId,
      entityData: outfitData,
    );
  }

  Future<void> queueDeleteOutfit(int outfitId) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'delete',
      entityType: 'outfit',
      entityId: outfitId,
      entityData: {'outfit_id': outfitId},
    );
  }

  Future<void> queueCreatePost(
    Map<String, dynamic> postData, {
    int? localId,
  }) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'create',
      entityType: 'post',
      entityData: postData,
      entityId: localId,
    );
  }

  Future<void> queueUpdatePost(Map<String, dynamic> postData) async {
    if (_currentUserId == null) return;

    final postId = postData['post_id'] ?? postData['postId'];
    if (postId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'update',
      entityType: 'post',
      entityId: postId,
      entityData: postData,
    );
  }

  Future<void> queueDeletePost(int postId) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'delete',
      entityType: 'post',
      entityId: postId,
      entityData: {'post_id': postId},
    );
  }

  Future<void> queueCreateComment(Map<String, dynamic> commentData) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'create',
      entityType: 'comment',
      entityData: commentData,
      entityId: null,
    );
  }

  Future<void> queueCreateLike(Map<String, dynamic> likeData) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'create',
      entityType: 'like',
      entityData: likeData,
      entityId: null,
    );
  }

  Future<void> queueDeleteLike(Map<String, dynamic> likeData) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'delete',
      entityType: 'like',
      entityData: likeData,
      entityId: null,
    );
  }

  Future<void> queueFollow(Map<String, dynamic> followData) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'create',
      entityType: 'follow',
      entityData: followData,
      entityId: null,
    );
  }

  Future<void> queueUnfollow(Map<String, dynamic> followData) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'delete',
      entityType: 'follow',
      entityData: followData,
      entityId: null,
    );
  }

  Future<void> queueCreateItemCategory(
    Map<String, dynamic> categoryData, {
    int? localId,
  }) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'create',
      entityType: 'item_category',
      entityData: categoryData,
      entityId: localId,
    );
  }

  Future<void> queueUpdateItemCategory(
    Map<String, dynamic> categoryData,
  ) async {
    if (_currentUserId == null) return;

    final categoryId =
        categoryData['category_id'] ?? categoryData['categoryId'];
    if (categoryId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'update',
      entityType: 'item_category',
      entityId: categoryId,
      entityData: categoryData,
    );
  }

  Future<void> queueDeleteItemCategory(int categoryId) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'delete',
      entityType: 'item_category',
      entityId: categoryId,
      entityData: {'category_id': categoryId},
    );
  }

  Future<void> queueCreateOutfitCategory(
    Map<String, dynamic> categoryData, {
    int? localId,
  }) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'create',
      entityType: 'outfit_category',
      entityData: categoryData,
      entityId: localId,
    );
  }

  Future<void> queueUpdateOutfitCategory(
    Map<String, dynamic> categoryData,
  ) async {
    if (_currentUserId == null) return;

    final categoryId =
        categoryData['category_id'] ?? categoryData['categoryId'];
    if (categoryId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'update',
      entityType: 'outfit_category',
      entityId: categoryId,
      entityData: categoryData,
    );
  }

  Future<void> queueDeleteOutfitCategory(int categoryId) async {
    if (_currentUserId == null) return;

    await _queueOperation(
      userId: _currentUserId!,
      action: 'delete',
      entityType: 'outfit_category',
      entityId: categoryId,
      entityData: {'category_id': categoryId},
    );
  }

  // ========== PRIVATE QUEUE METHOD ==========

  Future<void> _queueOperation({
    required int userId,
    required String action,
    required String entityType,
    required Map<String, dynamic> entityData,
    int? entityId,
  }) async {
    try {
      // Convert entityData Map to JSON string
      final entityDataJson = json.encode(entityData);

      final syncEntry = SyncQueueModel(
        userId: userId,
        action: action,
        entityType: entityType,
        entityId: entityId,
        entityData: entityDataJson, // Store as JSON string
        createdAt: DateTime.now().toIso8601String(),
        processed: false,
        retryCount: 0,
      );

      await _repo.insert(syncEntry);
      print('✅ Queued $action for $entityType (user: $userId)');
    } catch (e) {
      print('❌ Failed to queue operation: $e');
    }
  }

  // ========== SYNC MANAGER ACCESS METHODS ==========

  Future<List<SyncQueueModel>> getPendingOperations() async {
    if (_currentUserId == null) return [];
    return await _repo.getPendingOperations();
  }

  Future<void> markAsProcessed(int queueId) async {
    // Need to create a full SyncQueueModel with all required fields
    // First, get the existing entry
    final db = await _repo.getDatabase();
    final results = await db.query(
      'sync_queue',
      where: 'queue_id = ?',
      whereArgs: [queueId],
    );

    if (results.isNotEmpty) {
      final existing = SyncQueueModel.fromMap(results.first);

      // Create updated entry
      final updatedEntry = SyncQueueModel(
        queueId: existing.queueId,
        userId: existing.userId,
        action: existing.action,
        entityType: existing.entityType,
        entityId: existing.entityId,
        entityData: existing.entityData,
        createdAt: existing.createdAt,
        processed: true,
        processedAt: DateTime.now().toIso8601String(),
        retryCount: existing.retryCount,
      );

      await _repo.update(queueId, updatedEntry);
    }
  }

  Future<int> getPendingCount() async {
    return await _repo.getPendingCount();
  }

  // Helper to get database instance from repo
  Future<Database> getDatabase() async {
    return await _repo.getDatabase();
  }
}
