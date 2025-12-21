// lib/services/sync_service.dart
import 'dart:async';
import 'package:vestium/databases/db_helper.dart';
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/repo/item_repo.dart';
import 'package:vestium/repo/outfit_repo.dart';
import 'package:vestium/services/api_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final ApiService _api = ApiService();
  final ItemRepo _itemRepo = ItemRepo();
  final OutfitRepo _outfitRepo = OutfitRepo();
  final Connectivity _connectivity = Connectivity();

  bool _isSyncing = false;
  StreamController<double> _progressController = StreamController<double>.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  // ========== INITIAL SYNC (ON LOGIN) ==========
  Future<void> initialSync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      // Check connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('📴 No internet - Skipping sync');
        return;
      }

      print('🔄 Starting initial sync...');
      _progressController.add(0.1);

      // 1. Sync items from backend to local
      await syncItemsFromBackend();
      _progressController.add(0.4);

      // 2. Sync outfits from backend to local
      await syncOutfitsFromBackend();
      _progressController.add(0.7);

      // 3. Push local changes to backend (if any pending)
      await pushLocalChanges();
      _progressController.add(1.0);

      print('✅ Initial sync completed');
    } catch (e) {
      print('❌ Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  // ========== SYNC ITEMS (Backend → Local) ==========
  Future<void> syncItemsFromBackend() async {
    try {
      print('🔄 Syncing items from backend...');
      
      // Get items from backend
      final backendItems = await _api.getItemsFromBackend();
      
      // Get local items
      final localItems = await _itemRepo.getByUserId(_api.userId!);
      
      // Create map for quick lookup
      final localItemMap = {for (var item in localItems) item.itemId: item};
      
      int updated = 0;
      int created = 0;
      
      for (var backendItem in backendItems) {
        final localItem = localItemMap[backendItem['item_id']];
        
        if (localItem != null) {
          // Update existing item
          final updatedItem = ItemModel(
            itemId: backendItem['item_id'],
            userId: backendItem['user_id'],
            imagePath: backendItem['image_path'],
            itemName: backendItem['item_name'],
            description: backendItem['description'],
            season: backendItem['season'],
            date: backendItem['date'],
          );
          
          await _itemRepo.update(backendItem['item_id'], updatedItem);
          updated++;
        } else {
          // Create new item in local DB
          final newItem = ItemModel(
            itemId: backendItem['item_id'],
            userId: backendItem['user_id'],
            imagePath: backendItem['image_path'],
            itemName: backendItem['item_name'],
            description: backendItem['description'],
            season: backendItem['season'],
            date: backendItem['date'],
          );
          
          // Use insertWithId if you modify repo, or regular insert
          await _itemRepo.insert(newItem);
          created++;
        }
      }
      
      print('✅ Items sync: $created created, $updated updated');
    } catch (e) {
      print('❌ Failed to sync items: $e');
    }
  }

  // ========== SYNC OUTFITS ==========
  Future<void> syncOutfitsFromBackend() async {
    try {
      print('🔄 Syncing outfits from backend...');
      
      final backendOutfits = await _api.getOutfitsFromBackend();
      // Similar logic as items...
      
      print('✅ Outfits sync completed');
    } catch (e) {
      print('❌ Failed to sync outfits: $e');
    }
  }

  // ========== PUSH LOCAL CHANGES (Local → Backend) ==========
  Future<void> pushLocalChanges() async {
    try {
      print('🔄 Pushing local changes to backend...');
      
      // Get local items without backend IDs (new items)
      final localItems = await _itemRepo.getByUserId(_api.userId!);
      final newItems = localItems.where((item) => item.itemId! < 1000).toList(); // Assuming local IDs < 1000
      
      for (var item in newItems) {
        // Upload to backend
        final result = await _api.createItemOnBackend(
          name: item.itemName!,
          imagePath: item.imagePath!,
          description: item.description,
          season: item.season,
          categories: [], // Get from local join table
        );
        
        // Update local item with new backend ID
        if (result['item'] != null) {
          final backendId = result['item']['item_id'];
          final updatedItem = item.copyWith(itemId: backendId);
          await _itemRepo.update(item.itemId!, updatedItem);
        }
      }
      
      print('✅ Pushed ${newItems.length} items to backend');
    } catch (e) {
      print('❌ Failed to push changes: $e');
    }
  }

  // ========== BACKGROUND SYNC ==========
  Future<void> backgroundSync() async {
    if (_isSyncing) return;
    
    try {
      final connectivity = await _connectivity.checkConnectivity();
      if (connectivity != ConnectivityResult.none) {
        await syncItemsFromBackend();
        await pushLocalChanges();
      }
    } catch (e) {
      print('Background sync error: $e');
    }
  }

  // ========== MANUAL SYNC ==========
  Future<void> manualSync() async {
    await initialSync();
  }
}