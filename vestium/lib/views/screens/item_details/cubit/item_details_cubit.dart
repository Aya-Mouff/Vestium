// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'item_details_state.dart';

// class ItemDetailsCubit extends Cubit<ItemDetailsState> {
//   ItemDetailsCubit({required String imagePath})
//       : super(ItemDetailsState(imagePath: imagePath));

//   void updateName(String name) {
//     emit(state.copyWith(name: name));
//   }

//   void updateDescription(String description) {
//     emit(state.copyWith(description: description));
//   }

//   void updateSeason(String? season) {
//     emit(state.copyWith(selectedSeason: season));
//   }

//   void toggleCategory(String category) {
//     final newCategories = Set<String>.from(state.selectedCategories);
//     if (newCategories.contains(category)) {
//       newCategories.remove(category);
//     } else {
//       newCategories.add(category);
//     }
//     emit(state.copyWith(selectedCategories: newCategories));
//   }

//   void setSubmitting(bool submitting) {
//     emit(state.copyWith(isSubmitting: submitting));
//   }
// }

// =====================================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import 'package:vestium/repo/item_repo.dart';
import 'package:vestium/repo/item_category_repo.dart';
import 'package:vestium/repo/item_category_join_repo.dart';
import 'package:vestium/databases/services/file_service.dart';
import 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
  final ItemRepo _itemRepo = ItemRepo();
  final ItemCategoryRepo _categoryRepo = ItemCategoryRepo();
  final ItemCategoryJoinRepo _categoryJoinRepo = ItemCategoryJoinRepo();

  ItemDetailsCubit({required String imagePath})
      : super(ItemDetailsState(imagePath: imagePath));

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateSeason(String? season) {
    emit(state.copyWith(selectedSeason: season));
  }

  void toggleCategory(String category) {
    final newCategories = Set<String>.from(state.selectedCategories);
    if (newCategories.contains(category)) {
      newCategories.remove(category);
    } else {
      newCategories.add(category);
    }
    emit(state.copyWith(selectedCategories: newCategories));
  }

  void setSubmitting(bool submitting) {
    emit(state.copyWith(isSubmitting: submitting));
  }

  Future<void> saveItem() async {
    // Validate
    if (!state.isValid) {
      emit(state.copyWith(
        errorMessage: 'Please enter item name and select at least one category',
      ));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      // Get current user - CRITICAL for multi-user support
      final currentUser = CurrentUserService.currentUser;
      if (currentUser == null || currentUser.userId == null) {
        throw Exception('No user logged in. Please login first.');
      }

      print('💾 Starting to save item for user ID: ${currentUser.userId}');
      print('📷 Original image path: ${state.imagePath}');

      // 1. SAVE IMAGE TO PERSISTENT STORAGE
      print('💾 Saving image to persistent storage...');
      final persistentImagePath = await FileService.saveImageToAppDirectory(state.imagePath);
      print('✅ Image saved to: $persistentImagePath');

      // 2. GET CATEGORY IDs FOR ALL SELECTED CATEGORIES
      final List<int> categoryIds = [];
      final List<String> categoryNames = [];
      
      for (final categoryName in state.selectedCategories) {
        final category = await _categoryRepo.getByName(categoryName);
        if (category != null && category.categoryId != null) {
          categoryIds.add(category.categoryId!);
          categoryNames.add(categoryName);
          print('✅ Found category ID: ${category.categoryId} for "$categoryName"');
        } else {
          print('⚠️ Category "$categoryName" not found in database');
        }
      }

      if (categoryIds.isEmpty) {
        throw Exception('No valid categories selected');
      }

      // 3. CREATE ITEM MODEL (no categoryId field anymore)
      final item = ItemModel(
        userId: currentUser.userId!,  // THIS LINKS ITEM TO SPECIFIC USER
        imagePath: persistentImagePath,  // Use the persistent path
        itemName: state.name.trim(),
        description: state.description.trim(),  // Keep description clean
        season: state.selectedSeason,
        date: DateTime.now().toIso8601String(),
      );

      // 4. SAVE ITEM TO DATABASE
      print('💾 Saving item to database...');
      final itemId = await _itemRepo.insert(item);
      print('✅ Database insert successful, Item ID: $itemId');
      
      // 5. SAVE CATEGORIES TO JOIN TABLE
      print('💾 Saving categories to join table...');
      for (final categoryId in categoryIds) {
        await _categoryJoinRepo.addCategoryToItem(itemId, categoryId);
        print('✅ Linked category ID $categoryId to item ID $itemId');
      }
      print('✅ All categories saved to join table');
      
      // 6. CREATE SAVED ITEM WITH GENERATED ID
      final savedItem = item.copyWith(itemId: itemId);
      
      // 7. EMIT SUCCESS STATE
      emit(state.copyWith(
        isSubmitting: false,
        itemSaved: true,
        item: savedItem,
        imagePath: persistentImagePath, // Update state with persistent path
      ));

      print('✅ Item saved successfully for user ${currentUser.userId}');
      print('📝 Item name: ${state.name}');
      print('🏷️ Selected categories: ${state.selectedCategories.join(", ")}');
      print('🏷️ Category IDs: $categoryIds');
      print('🗂️ Database item ID: $itemId');
      print('📁 Persistent image path: $persistentImagePath');
      print('🔗 Item-category relationships saved in join table');

    } catch (e) {
      print('❌ Error saving item: $e');
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Failed to save item: ${e.toString()}',
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
