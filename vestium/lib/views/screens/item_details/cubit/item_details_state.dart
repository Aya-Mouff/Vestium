// import 'package:equatable/equatable.dart';

// class ItemDetailsState extends Equatable {
//   final String imagePath;
//   final String name;
//   final String description;
//   final String? selectedSeason;
//   final Set<String> selectedCategories;
//   final bool isSubmitting;

//   const ItemDetailsState({
//     required this.imagePath,
//     this.name = '',
//     this.description = '',
//     this.selectedSeason,
//     this.selectedCategories = const {},
//     this.isSubmitting = false,
//   });

//   @override
//   List<Object?> get props => [
//         imagePath,
//         name,
//         description,
//         selectedSeason,
//         selectedCategories,
//         isSubmitting,
//       ];

//   ItemDetailsState copyWith({
//     String? imagePath,
//     String? name,
//     String? description,
//     String? selectedSeason,
//     Set<String>? selectedCategories,
//     bool? isSubmitting,
//   }) {
//     return ItemDetailsState(
//       imagePath: imagePath ?? this.imagePath,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       selectedSeason: selectedSeason ?? this.selectedSeason,
//       selectedCategories: selectedCategories ?? this.selectedCategories,
//       isSubmitting: isSubmitting ?? this.isSubmitting,
//     );
//   }

//   bool get isValid => name.trim().isNotEmpty && selectedCategories.isNotEmpty;
// }

// ======================================================================

import 'package:equatable/equatable.dart';
import 'package:vestium/databases/db_models.dart';

class ItemDetailsState extends Equatable {
  final String imagePath;
  final String name;
  final String description;
  final String? selectedSeason;
  final Set<String> selectedCategories;
  final bool isSubmitting;
  final ItemModel? item;
  final bool itemSaved;
  final String? errorMessage;

  const ItemDetailsState({
    required this.imagePath,
    this.name = '',
    this.description = '',
    this.selectedSeason,
    this.selectedCategories = const {},
    this.isSubmitting = false,
    this.item,
    this.itemSaved = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        imagePath,
        name,
        description,
        selectedSeason,
        selectedCategories,
        isSubmitting,
        item,
        itemSaved,
        errorMessage,
      ];

  ItemDetailsState copyWith({
    String? imagePath,
    String? name,
    String? description,
    String? selectedSeason,
    Set<String>? selectedCategories,
    bool? isSubmitting,
    ItemModel? item,
    bool? itemSaved,
    String? errorMessage,
  }) {
    return ItemDetailsState(
      imagePath: imagePath ?? this.imagePath,
      name: name ?? this.name,
      description: description ?? this.description,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      item: item ?? this.item,
      itemSaved: itemSaved ?? this.itemSaved,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isValid => name.trim().isNotEmpty && selectedCategories.isNotEmpty;
}