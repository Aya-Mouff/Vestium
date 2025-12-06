import 'package:flutter_bloc/flutter_bloc.dart';
import 'manage_categories_state.dart';

class ManageCategoriesCubit extends Cubit<ManageCategoriesState> {
  ManageCategoriesCubit() : super(ManageCategoriesState.initial());

  void newCategoryNameChanged(String value) {
    emit(state.copyWith(newCategoryName: value));
  }

  void addCategory() {
    if (state.newCategoryName.isEmpty) return;

    final updated = List<Category>.from(state.categories)
      ..add(Category(name: state.newCategoryName, itemCount: 0));

    emit(state.copyWith(
      categories: updated,
      newCategoryName: '',
    ));
  }

  void editCategory(int index, String newName) {
    if (newName.isEmpty) return;

    final updated = List<Category>.from(state.categories);
    final old = updated[index];
    updated[index] = Category(name: newName, itemCount: old.itemCount);

    emit(state.copyWith(categories: updated));
  }

  void deleteCategory(int index) {
    final updated = List<Category>.from(state.categories)..removeAt(index);
    emit(state.copyWith(categories: updated));
  }
}
