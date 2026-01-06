import 'package:flutter_bloc/flutter_bloc.dart';
import 'manage_outfit_categories_state.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import '../../../../databases/services/outfit_category_service.dart';


class ManageOutfitCategoriesCubit extends Cubit<ManageOutfitCategoriesState> {
  final OutfitCategoryService _service;

  ManageOutfitCategoriesCubit(this._service)
      : super(ManageOutfitCategoriesState.initial());

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final userId = CurrentUserService.currentUserId;
      if (userId == null) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: 'No current user',
        ));
        return;
      }

      // Ensure default categories for this user if you want
      await _service.ensureInitialCategoriesForUser(userId);

      final cats = await _service.getAllCategoriesForUser(userId);

      final List<OutfitCategoryViewModel> viewModels = [];
      for (final c in cats) {
        if (c.categoryId == null) continue;
        final count = await _service.countOutfitsInCategory(c.categoryId!);
        viewModels.add(
          OutfitCategoryViewModel(
            id: c.categoryId,
            name: c.categoryName ?? 'Unnamed category',
            outfitCount: count,
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
        errorMessage: 'Failed to load outfit categories',
      ));
    }
  }

  void onNewCategoryNameChanged(String value) {
    emit(state.copyWith(newCategoryName: value));
  }

  Future<void> addCategory() async {
    final name = state.newCategoryName.trim();
    if (name.isEmpty) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final userId = CurrentUserService.currentUserId;
      if (userId == null) throw Exception('No current user');

      await _service.createCategoryForUser(userId, name);
      await loadCategories();
      emit(state.copyWith(newCategoryName: '', isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> editCategory(int index, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) return;

    final category = state.categories[index];
    if (category.id == null) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _service.updateCategory(category.id!, trimmed);
      await loadCategories();
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> deleteCategory(int index) async {
    final category = state.categories[index];
    if (category.id == null) return;

    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _service.deleteCategory(category.id!);
      await loadCategories();
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> refreshCounts() async {
    await loadCategories();
  }
}
