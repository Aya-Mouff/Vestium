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

/// Cubit for managing outfit creation workflow
class CreateOutfitCubit extends Cubit<CreateOutfitState> {
  final ItemCategoryService _itemCategoryService;
  final OutfitRepo _outfitRepo = OutfitRepo();
  final OutfitItemRepo _outfitItemRepo = OutfitItemRepo();
  final int _userId;

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

      // Fetch items from database for current user using ItemCategoryService
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

    // Check if item already exists
    final exists = currentState.placedItems.any(
      (pi) => pi.itemId == item.itemId,
    );
    if (exists) {
      print('⚠️  Item ${item.itemName} already in outfit');
      return;
    }

    final newPlacedItem = PlacedItemModel(
      itemId: item.itemId!,
      item: item,
      position: Offset(
        50 + (currentState.placedItems.length * 15).toDouble(),
        50 + (currentState.placedItems.length * 15).toDouble(),
      ),
    );

    final updatedPlacedItems = [...currentState.placedItems, newPlacedItem];

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
    print(
      '✅ Added ${item.itemName} to outfit (total: ${updatedPlacedItems.length})',
    );
  }

  /// Add an item to the outfit with specific position (for drag and drop)
  void addItemToOutfitWithPosition(ItemModel item, Offset position) {
    if (state is! CreateOutfitItemsLoaded) return;

    final currentState = state as CreateOutfitItemsLoaded;

    // Check if item already exists
    final exists = currentState.placedItems.any(
      (pi) => pi.itemId == item.itemId,
    );
    if (exists) {
      print('⚠️  Item ${item.itemName} already in outfit');
      return;
    }

    final newPlacedItem = PlacedItemModel(
      itemId: item.itemId!,
      item: item,
      position: position,
    );

    final updatedPlacedItems = [...currentState.placedItems, newPlacedItem];

    emit(currentState.copyWith(placedItems: updatedPlacedItems));
    print('✅ Added ${item.itemName} to outfit at position $position');
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

      // Create outfit model
      final now = DateTime.now().toIso8601String();
      final outfit = OutfitModel(
        userId: _userId,
        outfitName: outfitName.trim(),
        description: description?.isNotEmpty == true ? description : null,
        // categoryId: categoryId,
        season: season ?? 'All',
        date: now,
      );

      // Insert outfit into database
      await _outfitRepo.insert(outfit);
      print('✅ Outfit "$outfitName" inserted into database');

      // Get the inserted outfit to get its ID
      final allOutfits = await _outfitRepo.getByUserId(_userId);
      final savedOutfit = allOutfits.lastWhere(
        (o) => o.outfitName == outfit.outfitName && o.date == outfit.date,
        orElse: () => allOutfits.last,
      );

      if (savedOutfit.outfitId == null) {
        throw Exception('Failed to get outfit ID');
      }

      // Add items to outfit_item junction table
      print(
        '📝 Adding ${currentState.placedItems.length} items to outfit ${savedOutfit.outfitId}...',
      );
      for (int i = 0; i < currentState.placedItems.length; i++) {
        final placedItem = currentState.placedItems[i];
        final outfitItem = OutfitItem(
          outfitId: savedOutfit.outfitId!,
          itemId: placedItem.itemId,
        );
        await _outfitItemRepo.insert(outfitItem);
        print(
          '  ✅ Item ${i + 1}/${currentState.placedItems.length}: itemId ${placedItem.itemId} (${placedItem.item.itemName}) added to outfit',
        );
      }

      print(
        '✅ Successfully added all ${currentState.placedItems.length} items to outfit ${savedOutfit.outfitId}',
      );

      // Save outfit image using the first item's image as the outfit image
      try {
        final firstItemImagePath =
            currentState.placedItems.first.item.imagePath;
        if (firstItemImagePath != null && firstItemImagePath.isNotEmpty) {
          await OutfitImageService.saveOutfitImage(
            firstItemImagePath,
            outfitId: savedOutfit.outfitId!,
            userId: _userId,
          );
          print('✅ Outfit image saved for outfit ${savedOutfit.outfitId}');
        }
      } catch (e) {
        print('⚠️  Warning: Could not save outfit image: $e');
        // Don't fail the entire save if image save fails
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
}
