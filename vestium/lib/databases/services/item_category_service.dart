import 'package:vestium/repo/item_repo.dart';
import 'package:vestium/repo/item_category_repo.dart';
import 'package:vestium/repo/item_category_join_repo.dart';
import 'package:vestium/databases/db_models.dart';

class ItemCategoryService {
  final ItemRepo _itemRepo;
  final ItemCategoryRepo _categoryRepo;
  final ItemCategoryJoinRepo _joinRepo;

  ItemCategoryService({
    required ItemRepo itemRepo,
    required ItemCategoryRepo categoryRepo,
    required ItemCategoryJoinRepo joinRepo,
  })  : _itemRepo = itemRepo,
        _categoryRepo = categoryRepo,
        _joinRepo = joinRepo;

  Future<List<ItemModel>> getItemsByUserId(int userId) async {
    return await _itemRepo.getByUserId(userId);
  }

  Future<List<ItemModel>> getItemsByUserIdAndCategory(
    int userId,
    String categoryName,
  ) async {
    try {
      // Get category by name
      final category = await _categoryRepo.getByName(categoryName);
      if (category == null || category.categoryId == null) {
        print('⚠️ Category "$categoryName" not found');
        return [];
      }

      // Get items for this category through join table
      final categoryJoins = await _joinRepo.getItemsForCategory(category.categoryId!);
      
      // Get all user items
      final allUserItems = await _itemRepo.getByUserId(userId);
      
      // Filter: only include items that have this category
      final filteredItems = <ItemModel>[];
      
      for (final item in allUserItems) {
        if (item.itemId == null) continue;
        
        // Check if this item has the selected category
        final hasCategory = categoryJoins.any((join) => join.itemId == item.itemId);
        
        if (hasCategory) {
          filteredItems.add(item);
        }
      }
      
      return filteredItems;
    } catch (e) {
      print('❌ Error filtering items by category: $e');
      return [];
    }
  }

  Future<List<ItemCategory>> getAllCategories() async {
    return await _categoryRepo.getAll();
  }

  Future<List<ItemCategory>> getCategoriesForItem(int itemId) async {
    try {
      final joins = await _joinRepo.getCategoriesForItem(itemId);
      final categories = <ItemCategory>[];
      
      for (final join in joins) {
        final category = await _categoryRepo.getById(join.categoryId);
        if (category != null) {
          categories.add(category);
        }
      }
      
      return categories;
    } catch (e) {
      print('❌ Error getting categories for item: $e');
      return [];
    }
  }
}