import 'package:flutter_bloc/flutter_bloc.dart';
import 'select_item_state.dart';

class SelectItemCubit extends Cubit<SelectItemState> {
  SelectItemCubit() : super(const SelectItemState());

  void selectGalleryItem(Map<String, dynamic> galleryItem) {
    final isCurrentlySelected = state.selectedGalleryItem != null && 
        state.selectedGalleryItem!['id'] == galleryItem['id'];
    
    emit(state.copyWith(
      selectedGalleryItem: isCurrentlySelected ? null : galleryItem,
    ));
  }

  void addGalleryItem(String imagePath) {
    final newGalleryItem = {
      'id': 'gallery_${DateTime.now().millisecondsSinceEpoch}',
      'filePath': imagePath,
      'name': 'Gallery Image',
      'date': 'Just now',
    };

    final updatedItems = List<Map<String, dynamic>>.from(state.galleryItems)
      ..add(newGalleryItem);

    emit(state.copyWith(
      galleryItems: updatedItems,
      selectedGalleryItem: newGalleryItem,
    ));
  }

  void clearSelection() {
    emit(state.copyWith(selectedGalleryItem: null));
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}