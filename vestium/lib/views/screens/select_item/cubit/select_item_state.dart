import 'package:equatable/equatable.dart';

class SelectItemState extends Equatable {
  final Map<String, dynamic>? selectedGalleryItem;
  final List<Map<String, dynamic>> galleryItems;
  final bool isLoading;
  final String? error;

  const SelectItemState({
    this.selectedGalleryItem,
    this.galleryItems = const [],
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        selectedGalleryItem,
        galleryItems,
        isLoading,
        error,
      ];

  SelectItemState copyWith({
    Map<String, dynamic>? selectedGalleryItem,
    List<Map<String, dynamic>>? galleryItems,
    bool? isLoading,
    String? error,
  }) {
    return SelectItemState(
      selectedGalleryItem: selectedGalleryItem ?? this.selectedGalleryItem,
      galleryItems: galleryItems ?? this.galleryItems,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}