// lib/edit_item_details_screen/services/edit_item_service.dart
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/repo/item_repo.dart';
import 'package:vestium/repo/item_category_repo.dart';
import 'package:vestium/repo/item_category_join_repo.dart';
import 'package:vestium/repo/outfit_repo.dart';
import 'package:vestium/repo/outfit_item_repo.dart';
import './item_category_service.dart';

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
  })  : _itemRepo = itemRepo ?? ItemRepo(),
        _outfitRepo = outfitRepo ?? OutfitRepo(),
        _outfitItemRepo = outfitItemRepo ?? OutfitItemRepo(),
        _categoryService = categoryService ?? ItemCategoryService(
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

  Future<void> saveItem(ItemModel item, List<String> selectedCategories) async {
    // Update item
    await _itemRepo.update(item.itemId!, item);

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

    await _categoryJoinRepo.updateItemCategories(item.itemId!, categoryIds);
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