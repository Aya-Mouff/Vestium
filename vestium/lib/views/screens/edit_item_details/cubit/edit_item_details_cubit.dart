// lib/edit_item_details_screen/cubit/edit_item_details_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:vestium/databases/db_models.dart';
import 'edit_item_details_state.dart';
import 'package:vestium/databases/services/edit_item_service.dart';

class EditItemDetailsCubit extends Cubit<EditItemDetailsState> {
  final EditItemService _service;
  final int _itemId;
  final String? editedImagePath;

  EditItemDetailsCubit({
    required int itemId,
    this.editedImagePath,
    EditItemService? service,
  }) : _itemId = itemId,
       _service = service ?? EditItemService(),
       super(EditItemDetailsState.initial()) {
    _loadItemData();
  }

  Future<void> _loadItemData() async {
    emit(state.copyWith(isLoading: true, editedImagePath: editedImagePath));

    try {
      // Load item
      final item = await _service.loadItem(_itemId);
      if (item == null) {
        emit(state.copyWith(isLoading: false, errorMessage: 'Item not found'));
        return;
      }

      // Load all available categories
      final allCategories = await _service.loadAvailableCategories();

      // Load current item categories
      final currentCategories = await _service.loadItemCategories(_itemId);

      emit(
        state.copyWith(
          isLoading: false,
          item: item,
          name: item.itemName ?? '',
          description: item.description ?? '',
          selectedSeason: item.season ?? '',
          allCategories: allCategories,
          selectedCategories: currentCategories,
          editedImagePath: editedImagePath,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load item: $e',
        ),
      );
    }
  }

  void updateName(String name) {
    emit(state.copyWith(name: name));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateSeason(String season) {
    emit(state.copyWith(selectedSeason: season));
  }

  void toggleCategory(String category) {
    final newCategories = List<String>.from(state.selectedCategories);

    if (newCategories.contains(category)) {
      newCategories.remove(category);
    } else {
      newCategories.add(category);
    }

    emit(state.copyWith(selectedCategories: newCategories));
  }

  Future<void> saveItem() async {
    emit(state.copyWith(isSubmitting: true));

    try {
      // Update item
      final updatedItem = state.item!.copyWith(
        itemName: state.name.trim(),
        description: state.description.trim(),
        season: state.selectedSeason,
        //dateModified: DateTime.now().toIso8601String(),
      );

      await _service.saveItem(
        updatedItem,
        state.selectedCategories,
        editedImagePath: state.editedImagePath,
      );

      emit(
        state.copyWith(isSubmitting: false, itemSaved: true, item: updatedItem),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Failed to save item: $e',
        ),
      );
    }
  }

  Future<DeleteResult> deleteItem() async {
    emit(state.copyWith(isDeleting: true));

    try {
      final result = await _service.deleteItem(_itemId);

      if (result.isSuccess) {
        emit(state.copyWith(isDeleting: false, itemDeleted: true));
      } else {
        emit(state.copyWith(isDeleting: false));
      }

      return result;
    } catch (e) {
      emit(
        state.copyWith(
          isDeleting: false,
          errorMessage: 'Failed to delete item: $e',
        ),
      );
      return DeleteResult.error(e.toString());
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void updateEditedImagePath(String path) {
    emit(state.copyWith(editedImagePath: path));
  }
}
