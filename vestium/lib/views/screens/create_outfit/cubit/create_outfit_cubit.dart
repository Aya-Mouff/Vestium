import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/databases/services/item_category_service.dart';
import 'package:vestium/databases/services/outfit_image_service.dart';
import 'package:vestium/repo/item_repo.dart';
import 'package:vestium/repo/outfit_repo.dart';
import 'package:vestium/repo/outfit_item_repo.dart';
import 'package:vestium/repo/item_category_repo.dart';
import 'package:vestium/repo/item_category_join_repo.dart';
import 'create_outfit_state.dart';

/// Cubit for managing outfit creation workflow with layering support
class CreateOutfitCubit extends Cubit<CreateOutfitState> {
  final ItemCategoryService _itemCategoryService;
  final OutfitRepo _outfitRepo = OutfitRepo();
  final OutfitItemRepo _outfitItemRepo = OutfitItemRepo();
  final int _userId;
  int _nextZIndex = 0; // Track next available z-index

  CreateOutfitCubit({
    required int userId,
    ItemCategoryService? itemCategoryService,
  }) : _userId = userId,
       _itemCategoryService =
           itemCategoryService ??
           ItemCategoryService(
             itemRepo: ItemRepo(),
             categoryRepo: ItemCategoryRepo(),
             joinRepo: ItemCategoryJoinRepo(),
           ),
       super(const CreateOutfitInitial());

  /// Load all available clothing items for current user
  Future<void> loadClothingItems() async {
    try {
      emit(const CreateOutfitLoading());

      final items = await _itemCategoryService.getItemsByUserId(_userId);

      print('✅ Loaded ${items.length} items for user $_userId');

      if (items.isEmpty) {
        emit(
          const CreateOutfitItemsLoaded(availableItems: [], placedItems: []),
        );
      } else {
        emit(
          CreateOutfitItemsLoaded(availableItems: items, placedItems: const []),
        );
      }
    } catch (e) {
      print('❌ Error loading items: $e');
      emit(CreateOutfitError('Failed to load items: $e'));
    }
  }

  /// Add an item to the outfit with default position
  void addItemToOutfit(ItemModel item) {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;

    final exists = currentState.placedItems.any(
      (pi) => pi.itemId == item.itemId,
    );
    if (exists) {
      print('⚠️ Item ${item.itemName} already in outfit');
      return;
    }

    final newPlacedItem = PlacedItemModel(
      itemId: item.itemId!,
      item: item,
      position: Offset(
        50 + (currentState.placedItems.length * 15).toDouble(),
        50 + (currentState.placedItems.length * 15).toDouble(),
      ),
      zIndex: _nextZIndex++,
      scale: 1.0, // Default scale
    );

    final updatedPlacedItems = [...currentState.placedItems, newPlacedItem];

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
    print('✅ Added ${item.itemName} to outfit (z-index: ${newPlacedItem.zIndex})');
  }

  /// Add an item to the outfit with specific position
  void addItemToOutfitWithPosition(ItemModel item, Offset position) {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;

    final exists = currentState.placedItems.any(
      (pi) => pi.itemId == item.itemId,
    );
    if (exists) {
      print('⚠️ Item ${item.itemName} already in outfit');
      return;
    }

    final newPlacedItem = PlacedItemModel(
      itemId: item.itemId!,
      item: item,
      position: position,
      zIndex: _nextZIndex++,
      scale: 1.0, // Default scale
    );

    final updatedPlacedItems = [...currentState.placedItems, newPlacedItem];

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
    print('✅ Added ${item.itemName} at $position (z-index: ${newPlacedItem.zIndex})');
  }

  /// Update item position on the canvas
  void updateItemPosition(int itemId, Offset newPosition) {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;

    final updatedPlacedItems = currentState.placedItems.map((placedItem) {
      if (placedItem.itemId == itemId) {
        return placedItem.copyWith(position: newPosition);
      }
      return placedItem;
    }).toList();

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
  }

  /// Update item scale (zoom individual item)
  void updateItemScale(int itemId, double newScale) {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;

    final updatedPlacedItems = currentState.placedItems.map((placedItem) {
      if (placedItem.itemId == itemId) {
        // Clamp scale between 0.3x and 3.0x
        final clampedScale = newScale.clamp(0.3, 3.0);
        return placedItem.copyWith(scale: clampedScale);
      }
      return placedItem;
    }).toList();

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
    print('✅ Updated item $itemId scale to ${newScale.toStringAsFixed(2)}x');
  }

  /// Bring item to front (increase z-index to be on top)
  void bringItemToFront(int itemId) {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;

    final updatedPlacedItems = currentState.placedItems.map((placedItem) {
      if (placedItem.itemId == itemId) {
        return placedItem.copyWith(zIndex: _nextZIndex++);
      }
      return placedItem;
    }).toList();

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
    print('✅ Brought item $itemId to front (new z-index: ${_nextZIndex - 1})');
  }

  /// Send item to back (decrease z-index to be behind others)
  void sendItemToBack(int itemId) {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;

    // Find minimum z-index and set this item below it
    final minZIndex = currentState.placedItems.isEmpty
        ? 0
        : currentState.placedItems.map((p) => p.zIndex).reduce((a, b) => a < b ? a : b);

    final updatedPlacedItems = currentState.placedItems.map((placedItem) {
      if (placedItem.itemId == itemId) {
        return placedItem.copyWith(zIndex: minZIndex - 1);
      }
      return placedItem;
    }).toList();

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
    print('✅ Sent item $itemId to back (new z-index: ${minZIndex - 1})');
  }

  /// Remove an item from the outfit
  void removeItemFromOutfit(int itemId) {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;
    final updatedPlacedItems = currentState.placedItems
        .where((item) => item.itemId != itemId)
        .toList();

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
    print('✅ Removed item $itemId from outfit');
  }

  /// Replace an item in the outfit
  void replaceItemInOutfit(int oldItemId, ItemModel newItem) {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;

    final updatedPlacedItems = currentState.placedItems.map((placedItem) {
      if (placedItem.itemId == oldItemId) {
        return PlacedItemModel(
          itemId: newItem.itemId!,
          item: newItem,
          position: placedItem.position,
          zIndex: placedItem.zIndex, // Preserve z-index
          scale: placedItem.scale, // Preserve scale
        );
      }
      return placedItem;
    }).toList();

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
    print('✅ Replaced item $oldItemId with ${newItem.itemName}');
  }

  /// Clear all items from outfit
  void clearOutfit() {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;
    _nextZIndex = 0; // Reset z-index counter
    emit(currentState.copyWith(placedItems: const []));
    print('✅ Outfit cleared');
  }

  /// Save the outfit to database
  Future<bool> saveOutfit({
    required String outfitName,
    String? description,
    String? season,
    int? categoryId,
  }) async {
    try {
      if (state is! CreateOutfitItemsLoaded) {
        throw Exception('Invalid state for saving outfit');
      }

      final currentState = state as CreateOutfitItemsLoaded;

      if (currentState.placedItems.isEmpty) {
        throw Exception('Outfit must contain at least one item');
      }

      if (outfitName.trim().isEmpty) {
        throw Exception('Outfit name is required');
      }

      emit(const CreateOutfitSaving());

      final now = DateTime.now().toIso8601String();
      final outfit = OutfitModel(
        userId: _userId,
        outfitName: outfitName.trim(),
        description: description?.isNotEmpty == true ? description : null,
        season: season ?? 'All',
        date: now,
      );

      await _outfitRepo.insert(outfit);
      print('✅ Outfit "$outfitName" inserted into database');

      final allOutfits = await _outfitRepo.getByUserId(_userId);
      final savedOutfit = allOutfits.lastWhere(
        (o) => o.outfitName == outfit.outfitName && o.date == outfit.date,
        orElse: () => allOutfits.last,
      );

      if (savedOutfit.outfitId == null) {
        throw Exception('Failed to get outfit ID');
      }

      // Add items to outfit_item junction table (sorted by z-index)
      final sortedItems = currentState.sortedPlacedItems;
      print('📝 Adding ${sortedItems.length} items to outfit ${savedOutfit.outfitId}...');
      
      for (int i = 0; i < sortedItems.length; i++) {
        final placedItem = sortedItems[i];
        final outfitItem = OutfitItem(
          outfitId: savedOutfit.outfitId!,
          itemId: placedItem.itemId,
        );
        await _outfitItemRepo.insert(outfitItem);
        print('  ✅ Item ${i + 1}/${sortedItems.length}: ${placedItem.item.itemName} (z-index: ${placedItem.zIndex})');
      }

      // Save outfit image
      try {
        final firstItemImagePath = sortedItems.first.item.imagePath;
        if (firstItemImagePath != null && firstItemImagePath.isNotEmpty) {
          await OutfitImageService.saveOutfitImage(
            firstItemImagePath,
            outfitId: savedOutfit.outfitId!,
            userId: _userId,
          );
          print('✅ Outfit image saved');
        }
      } catch (e) {
        print('⚠️ Warning: Could not save outfit image: $e');
      }

      emit(CreateOutfitSaved(outfit: savedOutfit));
      print('✅ Outfit saved successfully with ID: ${savedOutfit.outfitId}');

      return true;
    } catch (e) {
      print('❌ Error saving outfit: $e');
      emit(CreateOutfitError('Failed to save outfit: $e'));
      return false;
    }
  }

  /// Toggle item selection visibility
  void toggleItemsVisibility() {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;
    emit(
      currentState.copyWith(
        showAvailableItems: !currentState.showAvailableItems,
      ),
    );
  }

  void centerAllItems(Size canvasSize) {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;
    if (currentState.placedItems.isEmpty) return;

    const itemWidth = 100.0;
    const itemHeight = 120.0;

    final centerX = canvasSize.width / 2;
    final centerY = canvasSize.height / 2;

    final totalWidth =
        (currentState.placedItems.length * itemWidth) +
        ((currentState.placedItems.length - 1) * 20);

    double startX = centerX - (totalWidth / 2);

    final updatedPlacedItems = <PlacedItemModel>[];

    for (int i = 0; i < currentState.placedItems.length; i++) {
      final placedItem = currentState.placedItems[i];
      final newPosition = Offset(
        startX + (i * (itemWidth + 20)),
        centerY - (itemHeight / 2),
      );

      updatedPlacedItems.add(placedItem.copyWith(position: newPosition));
    }

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
    print('✅ All items centered');
  }
}