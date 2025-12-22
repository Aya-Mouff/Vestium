// lib/services/outfit_category_service.dart
import 'package:vestium/repo/outfit_category_repo.dart';
import 'package:vestium/repo/outfit_category_join_repo.dart';
import '../../databases/db_models.dart';

class OutfitCategoryService {
  final OutfitCategoryRepo _categoryRepo = OutfitCategoryRepo();
  final OutfitCategoryJoinRepo _joinRepo = OutfitCategoryJoinRepo();

  // Initial categories that are created by default for each user
  static List<String> getInitialCategories() {
    return [
      "Casual",
      "Formal",
      "Workwear",
      "Athletic",
      "Party",
      "Date Night",
      "Vacation",
      "Seasonal",
    ];
  }

  // ========== PER-USER CATEGORY HELPERS ==========

  // Get all categories for a specific user
  Future<List<OutfitCategory>> getAllCategoriesForUser(int userId) async {
    return await _categoryRepo.getAll(userId); // uses user_id filter in repo
  }

  // Global (no filter) – only for internal checks like updateCategory
  Future<List<OutfitCategory>> getAllCategoriesGlobal() async {
    return await _categoryRepo.getAllGlobal();
  }

  // Ensure initial categories exist for this user
  Future<void> ensureInitialCategoriesForUser(int userId) async {
    final existingCategories = await getAllCategoriesForUser(userId);
    final existingNames = existingCategories
        .map((c) => (c.categoryName ?? '').toLowerCase())
        .toList();

    for (final categoryName in getInitialCategories()) {
      if (!existingNames.contains(categoryName.toLowerCase())) {
        await createCategoryForUser(userId, categoryName);
      }
    }
  }

  // Create a new category for this user
  Future<bool> createCategoryForUser(int userId, String categoryName) async {
    if (categoryName.isEmpty || categoryName.length > 50) {
      throw Exception('Category name must be between 1 and 50 characters');
    }

    // Check if category already exists for this user
    final existingCategories = await getAllCategoriesForUser(userId);
    final exists = existingCategories.any(
      (c) => c.categoryName?.toLowerCase() == categoryName.toLowerCase(),
    );

    if (exists) {
      throw Exception('Category "$categoryName" already exists');
    }

    final category = OutfitCategory(
      userId: userId,
      categoryName: categoryName,
    );
    return await _categoryRepo.insert(category);
  }

  // ========== (OPTIONAL) LEGACY GLOBAL CREATE – AVOID USING ==========

  Future<bool> createCategory(String categoryName) async {
    // This version does NOT set userId; prefer createCategoryForUser()
    final category = OutfitCategory(categoryName: categoryName);
    return await _categoryRepo.insert(category);
  }

  // ========== UPDATE / DELETE (WORK FOR ANY CATEGORY ID) ==========

  Future<bool> updateCategory(int categoryId, String newName) async {
    // Load all categories (all users) to find this one
    final allCategories = await getAllCategoriesGlobal();
    final categoryExists =
        allCategories.any((c) => c.categoryId == categoryId);

    if (!categoryExists) {
      throw Exception('Category not found');
    }

    // Find this category and its user
    final thisCategory = allCategories.firstWhere(
      (c) => c.categoryId == categoryId,
      orElse: () => OutfitCategory(),
    );
    final userId = thisCategory.userId;

    // Ensure name is unique for that user
    if (userId != null) {
      final userCategories = await getAllCategoriesForUser(userId);
      final nameExists = userCategories.any(
        (c) =>
            c.categoryId != categoryId &&
            c.categoryName?.toLowerCase() == newName.toLowerCase(),
      );
      if (nameExists) {
        throw Exception('Category "$newName" already exists');
      }
    }

    final category = OutfitCategory(
      categoryId: categoryId,
      userId: userId,
      categoryName: newName,
    );
    return await _categoryRepo.update(categoryId, category);
  }

  Future<bool> deleteCategory(int categoryId) async {
    // First delete all joins for this category
    await _joinRepo.deleteByCategoryId(categoryId);
    // Then delete the category
    return await _categoryRepo.delete(categoryId);
  }

  // ========== JOIN / COUNTS (NO CHANGE) ==========

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
      await _joinRepo.deleteByOutfitId(outfitId);
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

  // Get category by name (global; if you need user specific, add userId)
  Future<OutfitCategory?> getCategoryByName(String name) async {
    return await _categoryRepo.getByName(name);
  }

  // Get category by ID
  Future<OutfitCategory?> getCategoryById(int id) async {
    return await _categoryRepo.getById(id);
  }
}
