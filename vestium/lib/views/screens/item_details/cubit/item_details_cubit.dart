import 'package:flutter_bloc/flutter_bloc.dart';
import 'item_details_state.dart';

class ItemDetailsCubit extends Cubit<ItemDetailsState> {
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
}