
import 'package:equatable/equatable.dart';
import 'package:vestium/databases/db_models.dart';

class WardrobeState extends Equatable {
  final String selectedFilter;
  final bool isLoading;
  final List<ItemModel> items;
  final List<ItemCategory> categories;
  final String? errorMessage;

  const WardrobeState({
    this.selectedFilter = 'All',
    this.isLoading = false,
    this.items = const [],
    this.categories = const [],
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    selectedFilter,
    isLoading,
    items,
    categories,
    errorMessage,
  ];

  WardrobeState copyWith({
    String? selectedFilter,
    bool? isLoading,
    List<ItemModel>? items,
    List<ItemCategory>? categories,
    String? errorMessage,
  }) {
    return WardrobeState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      categories: categories ?? this.categories,
      errorMessage: errorMessage,
    );
  }
}