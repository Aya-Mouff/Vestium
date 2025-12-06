// lib/services/outfit_category_service.dart
import 'package:vestium/repo/outfit_category_repo.dart';
import 'package:vestium/repo/outfit_category_join_repo.dart';
import '../db_models.dart';

class OutfitCategoryService {
  final OutfitCategoryRepo _categoryRepo = OutfitCategoryRepo();
  final OutfitCategoryJoinRepo _joinRepo = OutfitCategoryJoinRepo();

  // Initial categories that are created by default
  static List<String> getInitialCategories() {
    return [
      "Casual",
      "Formal", 
      "Workwear",
      "Athletic",
      "Party",
      "Date Night",
      "Vacation",
      "Seasonal"
    ];
  }

  // Ensure all initial categories exist in the database
  Future<void> ensureInitialCategories() async {
    final existingCategories = await getAllCategories();
    final existingNames = existingCategories.map((c) => c.categoryName ?? '').toList();
    
    for (final categoryName in getInitialCategories()) {
      if (!existingNames.contains(categoryName)) {
        await createCategory(categoryName);
      }
    }
  }

  // Get all categories
  Future<List<OutfitCategory>> getAllCategories() async {
    return await _categoryRepo.getAll();
  }

  // Create a new category
  Future<bool> createCategory(String categoryName) async {
    if (categoryName.isEmpty || categoryName.length > 50) {
      throw Exception('Category name must be between 1 and 50 characters');
    }
    
    // Check if category already exists
    final existingCategories = await getAllCategories();
    final exists = existingCategories.any((c) => 
      c.categoryName?.toLowerCase() == categoryName.toLowerCase()
    );
    
    if (exists) {
      throw Exception('Category "$categoryName" already exists');
    }
    
    final category = OutfitCategory(categoryName: categoryName);
    return await _categoryRepo.insert(category);
  }

  // Update an existing category
  Future<bool> updateCategory(int categoryId, String newName) async {
    // Check if category exists
    final allCategories = await getAllCategories();
    final categoryExists = allCategories.any((c) => c.categoryId == categoryId);
    
    if (!categoryExists) {
      throw Exception('Category not found');
    }
    
    // Check if new name already exists
    final nameExists = allCategories.any((c) => 
      c.categoryId != categoryId && 
      c.categoryName?.toLowerCase() == newName.toLowerCase()
    );
    
    if (nameExists) {
      throw Exception('Category "$newName" already exists');
    }
    
    final category = OutfitCategory(categoryId: categoryId, categoryName: newName);
    return await _categoryRepo.update(categoryId, category);
  }

  // Delete a category
  Future<bool> deleteCategory(int categoryId) async {
    // First delete all joins for this category
    await _joinRepo.deleteByCategoryId(categoryId);
    // Then delete the category
    return await _categoryRepo.delete(categoryId);
  }

  // Get categories for a specific outfit
  Future<List<OutfitCategory>> getCategoriesForOutfit(int outfitId) async {
    return await _joinRepo.getCategoriesForOutfit(outfitId);
  }

  // Get outfits by category
  Future<List<OutfitModel>> getOutfitsByCategory(int categoryId) async {
    return await _joinRepo.getOutfitsByCategory(categoryId);
  }

  // Add a category to an outfit
  Future<bool> addCategoryToOutfit(int outfitId, int categoryId) async {
    final join = OutfitCategoryJoin(outfitId: outfitId, categoryId: categoryId);
    return await _joinRepo.insert(join);
  }

  // Remove a category from an outfit
  Future<bool> removeCategoryFromOutfit(int outfitId, int categoryId) async {
    return await _joinRepo.delete(outfitId, categoryId);
  }

  // Set all categories for an outfit (replaces existing)
  Future<bool> setOutfitCategories(int outfitId, List<int> categoryIds) async {
    try {
      // Remove existing categories
      await _joinRepo.deleteByOutfitId(outfitId);
      
      // Add new categories
      for (final categoryId in categoryIds) {
        await addCategoryToOutfit(outfitId, categoryId);
      }
      return true;
    } catch (e) {
      print('Error setting outfit categories: $e');
      return false;
    }
  }

  // Get category IDs for an outfit
  Future<List<int>> getCategoryIdsForOutfit(int outfitId) async {
    final joins = await _joinRepo.getByOutfitId(outfitId);
    return joins.map((join) => join.categoryId).toList();
  }

  // Check if outfit has a specific category
  Future<bool> outfitHasCategory(int outfitId, int categoryId) async {
    final joins = await _joinRepo.getByOutfitId(outfitId);
    return joins.any((join) => join.categoryId == categoryId);
  }

  // Count outfits in a category
  Future<int> countOutfitsInCategory(int categoryId) async {
    final outfits = await getOutfitsByCategory(categoryId);
    return outfits.length;
  }

  // Get category by name
  Future<OutfitCategory?> getCategoryByName(String name) async {
    return await _categoryRepo.getByName(name);
  }

  // Get category by ID
  Future<OutfitCategory?> getCategoryById(int id) async {
    return await _categoryRepo.getById(id);
  }
}