import 'package:equatable/equatable.dart';

class OutfitCategoryViewModel extends Equatable {
  final int? id;
  final String name;
  final int outfitCount;

  const OutfitCategoryViewModel({
    this.id,
    required this.name,
    required this.outfitCount,
  });

  OutfitCategoryViewModel copyWith({
    int? id,
    String? name,
    int? outfitCount,
  }) {
    return OutfitCategoryViewModel(
      id: id ?? this.id,
      name: name ?? this.name,
      outfitCount: outfitCount ?? this.outfitCount,
    );
  }

  @override
  List<Object?> get props => [id, name, outfitCount];
}

class ManageOutfitCategoriesState extends Equatable {
  final List<OutfitCategoryViewModel> categories;
  final bool isLoading;
  final String? errorMessage;
  final String newCategoryName;

  const ManageOutfitCategoriesState({
    required this.categories,
    required this.isLoading,
    required this.errorMessage,
    required this.newCategoryName,
  });

  factory ManageOutfitCategoriesState.initial() {
    return const ManageOutfitCategoriesState(
      categories: [],
      isLoading: false,
      errorMessage: null,
      newCategoryName: '',
    );
  }

  ManageOutfitCategoriesState copyWith({
    List<OutfitCategoryViewModel>? categories,
    bool? isLoading,
    String? errorMessage,
    String? newCategoryName,
  }) {
    return ManageOutfitCategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      newCategoryName: newCategoryName ?? this.newCategoryName,
    );
  }

  @override
  List<Object?> get props => [categories, isLoading, errorMessage, newCategoryName];
}
