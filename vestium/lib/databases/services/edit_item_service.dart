// lib/edit_item_details_screen/services/edit_item_service.dart
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/repo/item_repo.dart';
import 'package:vestium/repo/item_category_repo.dart';
import 'package:vestium/repo/item_category_join_repo.dart';
import 'package:vestium/repo/outfit_repo.dart';
import 'package:vestium/repo/outfit_item_repo.dart';
import './item_category_service.dart';
import 'dart:io';

class EditItemService {
  final ItemRepo _itemRepo;
  final OutfitRepo _outfitRepo;
  final OutfitItemRepo _outfitItemRepo;
  final ItemCategoryService _categoryService;
  final ItemCategoryRepo _categoryRepo;
  final ItemCategoryJoinRepo _categoryJoinRepo;

  EditItemService({
    ItemRepo? itemRepo,
    OutfitRepo? outfitRepo,
    OutfitItemRepo? outfitItemRepo,
    ItemCategoryService? categoryService,
    ItemCategoryRepo? categoryRepo,
    ItemCategoryJoinRepo? categoryJoinRepo,
  }) : _itemRepo = itemRepo ?? ItemRepo(),
       _outfitRepo = outfitRepo ?? OutfitRepo(),
       _outfitItemRepo = outfitItemRepo ?? OutfitItemRepo(),
       _categoryService =
           categoryService ??
           ItemCategoryService(
             itemRepo: ItemRepo(),
             categoryRepo: ItemCategoryRepo(),
             joinRepo: ItemCategoryJoinRepo(),
           ),
       _categoryRepo = categoryRepo ?? ItemCategoryRepo(),
       _categoryJoinRepo = categoryJoinRepo ?? ItemCategoryJoinRepo();

  Future<ItemModel?> loadItem(int itemId) async {
    return await _itemRepo.getById(itemId);
  }

  Future<List<String>> loadAvailableCategories() async {
    final categories = await _categoryService.getAllCategories();
    if (categories.isEmpty) {
      // Return initial categories if none in database
      final initialCategories = [
        'Tops',
        'Bottoms',
        'Dresses',
        'Outerwear',
        'Shoes',
        'Accessories',
      ];
      return initialCategories;
    }
    return categories.map((c) => c.categoryName ?? '').toList();
  }

  Future<List<String>> loadItemCategories(int itemId) async {
    final categories = await _categoryService.getCategoriesForItem(itemId);
    return categories.map((c) => c.categoryName ?? '').toList();
  }

  Future<void> saveItem(
    ItemModel item,
    List<String> selectedCategories, {
    String? editedImagePath,
  }) async {
    // Handle edited image if provided
    ItemModel itemToSave = item;
    if (editedImagePath != null &&
        editedImagePath.isNotEmpty &&
        editedImagePath != item.imagePath) {
      // The edited image is different from the original
      final editedFile = File(editedImagePath);
      print('📁 Edited image path: $editedImagePath');
      print('📁 Original image path: ${item.imagePath}');
      print('📁 Edited file exists: ${await editedFile.exists()}');

      if (await editedFile.exists()) {
        try {
          // Update the item to use the edited image path directly
          // This matches the remove-background flow
          itemToSave = item.copyWith(imagePath: editedImagePath);
          print('✅ Item updated to use edited image path: $editedImagePath');

          // Delete the old original image file if it exists
          try {
            final originalFile = File(item.imagePath ?? '');
            if (item.imagePath != null &&
                item.imagePath!.isNotEmpty &&
                await originalFile.exists()) {
              print('🗑️ Deleting old original image: ${item.imagePath}');
              await originalFile.delete();
              print('✅ Original image deleted');
            }
          } catch (e) {
            print('⚠️ Failed to delete original image: $e');
          }
        } catch (e) {
          print('❌ Error handling edited image: $e');
          print('❌ Stack trace: ${StackTrace.current}');
          itemToSave = item;
        }
      } else {
        print('⚠️ Edited image file not found at: $editedImagePath');
      }
    }

    // Update item in database
    print('💾 Saving item to database with imagePath: ${itemToSave.imagePath}');
    await _itemRepo.update(itemToSave.itemId!, itemToSave);
    print('✅ Item saved to database');

    // Update categories
    final categoryIds = <int>[];
    for (final categoryName in selectedCategories) {
      var category = await _categoryRepo.getByName(categoryName);
      if (category == null) {
        final newId = await _categoryRepo.insert(categoryName);
        category = ItemCategory(categoryId: newId, categoryName: categoryName);
      }
      categoryIds.add(category.categoryId!);
    }

    await _categoryJoinRepo.updateItemCategories(
      itemToSave.itemId!,
      categoryIds,
    );

    // Verify the image file was saved correctly
    if (itemToSave.imagePath != null && itemToSave.imagePath!.isNotEmpty) {
      final finalFile = File(itemToSave.imagePath!);
      if (await finalFile.exists()) {
        final fileSize = await finalFile.length();
        print('✅ Image file verified: ${itemToSave.imagePath}');
        print('✅ Image file size: $fileSize bytes');
      } else {
        print(
          '❌ WARNING: Image file not found after save: ${itemToSave.imagePath}',
        );
      }
    }
  }

  Future<DeleteResult> deleteItem(int itemId) async {
    // Check if item is used in any outfits
    final outfitItems = await _outfitItemRepo.getAll();
    final outfitsUsingItem = outfitItems
        .where((oi) => oi.itemId == itemId)
        .toList();

    if (outfitsUsingItem.isNotEmpty) {
      // Get outfit details - fetch all outfits and find matching ones
      final allOutfits = await _outfitRepo.getAll();
      final outfitDetails = <Map<String, dynamic>>[];

      for (final oi in outfitsUsingItem) {
        final outfit = allOutfits.firstWhere(
          (outfit) => outfit.outfitId == oi.outfitId,
          orElse: () => OutfitModel(), // Fallback if not found
        );

        if (outfit.outfitId != null) {
          // Create display name - use ID to distinguish duplicates
          final displayName = outfit.outfitName ?? 'Unnamed Outfit';
          final outfitId = outfit.outfitId!;

          outfitDetails.add({
            'id': outfitId,
            'name': displayName,
            'display': '$displayName (#$outfitId)', // Add ID to distinguish
          });
        }
      }

      return DeleteResult.blocked(outfitDetails);
    }

    // If not used, delete
    await _itemRepo.delete(itemId);
    await _categoryJoinRepo.removeAllCategoriesFromItem(itemId);

    return DeleteResult.success();
  }
}

class DeleteResult {
  final bool isSuccess;
  final bool isBlocked;
  final List<Map<String, dynamic>>? blockingOutfits;
  final String? error;

  DeleteResult.success()
    : isSuccess = true,
      isBlocked = false,
      blockingOutfits = null,
      error = null;

  DeleteResult.blocked(List<Map<String, dynamic>> outfits)
    : isSuccess = false,
      isBlocked = true,
      blockingOutfits = outfits,
      error = null;

  DeleteResult.error(String errorMessage)
    : isSuccess = false,
      isBlocked = false,
      blockingOutfits = null,
      error = errorMessage;
}
