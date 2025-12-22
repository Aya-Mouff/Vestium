// manage_categories/cubit/manage_categories_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'manage_categories_state.dart';
import 'package:vestium/repo/item_category_repo.dart';
import 'package:vestium/databases/db_models.dart';
import '../../../../databases/services/outfit_category_service.dart';
import '../../../../repo/item_category_join_repo.dart';


class ManageCategoriesCubit extends Cubit<ManageCategoriesState> {
  final ItemCategoryRepo _itemCategoryRepo;
  final ItemCategoryJoinRepo _itemCategoryJoinRepo;

  ManageCategoriesCubit(
    this._itemCategoryRepo,
    this._itemCategoryJoinRepo,
  ) : super(ManageCategoriesState.initial());

  /// Load categories from DB and compute how many items each category has
  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final cats = await _itemCategoryRepo.getAll(); // List<ItemCategory>[file:2]

      final List<CategoryViewModel> viewModels = [];

      for (final c in cats) {
        if (c.categoryId == null) continue;

        // Get all item-category joins for this category
        final joins =
            await _itemCategoryJoinRepo.getItemsForCategory(c.categoryId!);
        final count = joins.length; // number of items in this category[file:5]

        viewModels.add(
          CategoryViewModel(
            id: c.categoryId,
            name: c.categoryName ?? 'Unnamed category',
            itemCount: count,
          ),
        );
      }

      emit(state.copyWith(
        categories: viewModels,
        isLoading: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load categories',
      ));
    }
  }

  /// Text field change
  void onNewCategoryNameChanged(String value) {
    emit(state.copyWith(newCategoryName: value));
  }

  /// Add a new category to DB and to state
  Future<void> addCategory() async {
    final name = state.newCategoryName.trim();
    if (name.isEmpty) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final id = await _itemCategoryRepo.insert(name); // new category_id[file:2]

      final newCat = CategoryViewModel(
        id: id,
        name: name,
        itemCount: 0, // starts with 0 items
      );

      final updated = List<CategoryViewModel>.from(state.categories)
        ..add(newCat);

      emit(state.copyWith(
        categories: updated,
        newCategoryName: '',
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to add category',
      ));
    }
  }

  /// Edit category name in DB and update state
  Future<void> editCategory(int index, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;

    final category = state.categories[index];
    if (category.id == null) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final updatedModel = ItemCategory(
        categoryId: category.id,
        categoryName: trimmed,
      );

      await _itemCategoryRepo.update(category.id!, updatedModel); // DB update[file:2]

      final updatedList = List<CategoryViewModel>.from(state.categories);
      updatedList[index] = category.copyWith(name: trimmed);

      emit(state.copyWith(
        categories: updatedList,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to edit category',
      ));
    }
  }

  /// Delete category from DB and remove from state
  Future<void> deleteCategory(int index) async {
    final category = state.categories[index];
    if (category.id == null) {
      final updated = List<CategoryViewModel>.from(state.categories)
        ..removeAt(index);
      emit(state.copyWith(categories: updated));
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _itemCategoryRepo.delete(category.id!); // DB delete[file:2]
      final updated = List<CategoryViewModel>.from(state.categories)
        ..removeAt(index);

      emit(state.copyWith(
        categories: updated,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to delete category',
      ));
    }
  }

  /// Call this after returning from an "edit/add item" screen
  Future<void> refreshCounts() async {
    await loadCategories();
  }
}
