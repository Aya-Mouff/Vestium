// lib/edit_item_details_screen/cubit/edit_item_details_state.dart
import 'package:equatable/equatable.dart';
import 'package:vestium/databases/db_models.dart';

class EditItemDetailsState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final bool isDeleting;
  final bool itemSaved;
  final bool itemDeleted;
  final String? errorMessage;
  final ItemModel? item;
  final String name;
  final String description;
  final String selectedSeason;
  final List<String> allCategories;
  final List<String> selectedCategories;

  const EditItemDetailsState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.isDeleting = false,
    this.itemSaved = false,
    this.itemDeleted = false,
    this.errorMessage,
    this.item,
    this.name = '',
    this.description = '',
    this.selectedSeason = '',
    this.allCategories = const [],
    this.selectedCategories = const [],
  });

  factory EditItemDetailsState.initial() => const EditItemDetailsState();

  EditItemDetailsState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    bool? isDeleting,
    bool? itemSaved,
    bool? itemDeleted,
    String? errorMessage,
    ItemModel? item,
    String? name,
    String? description,
    String? selectedSeason,
    List<String>? allCategories,
    List<String>? selectedCategories,
  }) {
    return EditItemDetailsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isDeleting: isDeleting ?? this.isDeleting,
      itemSaved: itemSaved ?? this.itemSaved,
      itemDeleted: itemDeleted ?? this.itemDeleted,
      errorMessage: errorMessage ?? this.errorMessage,
      item: item ?? this.item,
      name: name ?? this.name,
      description: description ?? this.description,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      allCategories: allCategories ?? this.allCategories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }

  bool get isValid => name.trim().isNotEmpty && selectedCategories.isNotEmpty;

  @override
  List<Object?> get props => [
        isLoading,
        isSubmitting,
        isDeleting,
        itemSaved,
        itemDeleted,
        errorMessage,
        item,
        name,
        description,
        selectedSeason,
        allCategories,
        selectedCategories,
      ];
}