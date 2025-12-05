import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vestium/repo/item_repo.dart';
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import 'package:vestium/databases/services/file_service.dart';

part 'edit_item_state.dart';

class EditItemCubit extends Cubit<EditItemState> {
  final ItemRepo _itemRepo = ItemRepo();

  EditItemCubit() : super(const EditItemState());

  // === Editing Mode Controls ===
  
  void startCropping() {
    emit(state.copyWith(isCropping: true));
  }

  void stopCropping() {
    emit(state.copyWith(isCropping: false));
  }

  void startRemovingBg() {
    emit(state.copyWith(isRemovingBg: true));
  }

  void cancelRemoveBg() {
    emit(state.copyWith(isRemovingBg: false));
  }

  // === Eraser Controls ===
  
  void updateEraserSize(double size) {
    emit(state.copyWith(eraserSize: size));
  }

  // === Image Path Management ===
  
  void setEditedImagePath(String path) {
    emit(state.copyWith(editedImagePath: path));
    print('📝 Edited image path updated in state: $path');
  }

  void clearEditedImage() {
    emit(state.copyWith(editedImagePath: null));
    print('🗑️ Edited image path cleared from state');
  }

  // === Database Operations ===
  
  /// Save the current edited image to the database as a new item
  /// Returns the item ID if successful, null otherwise
  Future<int?> saveItemToDatabase({
    required String imagePath,
    required String itemName,
    required String description,
    required String season,
    required List<int> categoryIds,
  }) async {
    try {
      emit(state.copyWith(isSaving: true, errorMessage: null));

      // Get current user
      final userId = CurrentUserService.currentUserId;
      if (userId == null) {
        emit(state.copyWith(
          isSaving: false,
          errorMessage: 'No user logged in',
        ));
        return null;
      }

      // Use edited image path if available, otherwise use original
      final finalImagePath = state.editedImagePath ?? imagePath;

      // Verify image exists
      if (!await FileService.imageExists(finalImagePath)) {
        emit(state.copyWith(
          isSaving: false,
          errorMessage: 'Image file not found',
        ));
        return null;
      }

      // Create item model
      final item = ItemModel(
        userId: userId,
        imagePath: finalImagePath,
        itemName: itemName,
        description: description,
        season: season,
        date: DateTime.now().toIso8601String(),
      );

      // Insert into database
      final itemId = await _itemRepo.insert(item);
      
      print('✅ Item saved to database with ID: $itemId');
      print('📸 Image path: $finalImagePath');

      // If categories provided, save them (you'll need ItemCategoryJoinRepo)
      // await _saveItemCategories(itemId, categoryIds);

      emit(state.copyWith(
        isSaving: false,
        lastSavedItemId: itemId,
      ));

      return itemId;
    } catch (e) {
      print('❌ Error saving item to database: $e');
      emit(state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save item: ${e.toString()}',
      ));
      return null;
    }
  }

  /// Update an existing item with the edited image
  Future<bool> updateItemImage({
    required int itemId,
    required String newImagePath,
  }) async {
    try {
      emit(state.copyWith(isSaving: true, errorMessage: null));

      // Get existing item
      final existingItem = await _itemRepo.getById(itemId);
      if (existingItem == null) {
        emit(state.copyWith(
          isSaving: false,
          errorMessage: 'Item not found',
        ));
        return false;
      }

      // Delete old image if it exists and is different
      if (existingItem.imagePath != null && 
          existingItem.imagePath != newImagePath) {
        await FileService.deleteImage(existingItem.imagePath!);
      }

      // Update item with new image path
      final updatedItem = existingItem.copyWith(imagePath: newImagePath);
      await _itemRepo.update(itemId, updatedItem);

      print('✅ Item $itemId updated with new image: $newImagePath');

      emit(state.copyWith(
        isSaving: false,
        lastSavedItemId: itemId,
      ));

      return true;
    } catch (e) {
      print('❌ Error updating item image: $e');
      emit(state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to update item: ${e.toString()}',
      ));
      return false;
    }
  }

  /// Load an existing item for editing
  Future<ItemModel?> loadItemForEditing(int itemId) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      final item = await _itemRepo.getById(itemId);
      
      if (item == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'Item not found',
        ));
        return null;
      }

      emit(state.copyWith(
        isLoading: false,
        currentItemId: itemId,
      ));

      return item;
    } catch (e) {
      print('❌ Error loading item: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load item: ${e.toString()}',
      ));
      return null;
    }
  }

  /// Delete an item and its image
  Future<bool> deleteItem(int itemId) async {
    try {
      // Get item to delete its image
      final item = await _itemRepo.getById(itemId);
      if (item?.imagePath != null) {
        await FileService.deleteImage(item!.imagePath!);
      }

      // Delete from database
      await _itemRepo.delete(itemId);
      
      print('✅ Item $itemId deleted');
      return true;
    } catch (e) {
      print('❌ Error deleting item: $e');
      emit(state.copyWith(errorMessage: 'Failed to delete item: ${e.toString()}'));
      return false;
    }
  }

  // === Helper Methods ===

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  String? getFinalImagePath(String originalPath) {
    return state.editedImagePath ?? originalPath;
  }

  bool hasEditedImage() {
    return state.editedImagePath != null;
  }
}