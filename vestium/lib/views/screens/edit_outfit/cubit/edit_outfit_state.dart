import 'package:equatable/equatable.dart';

class EditOutfitState extends Equatable {
  final String outfitId;
  final Map<String, dynamic>? outfit;
  final Map<String, dynamic>? currentUser;
  final String name;
  final String description;
  final String? selectedCategory;
  final String? selectedSeason;
  final List<String> userCategories;
  final bool isLoading;
  final bool hasError;

  const EditOutfitState({
    required this.outfitId,
    this.outfit,
    this.currentUser,
    this.name = '',
    this.description = '',
    this.selectedCategory,
    this.selectedSeason,
    this.userCategories = const [
      'Casual',
      'Formal',
      'Streetwear',
      'Work',
      'Evening',
      'Vacation'
    ],
    this.isLoading = true,
    this.hasError = false,
  });

  @override
  List<Object?> get props => [
        outfitId,
        outfit,
        currentUser,
        name,
        description,
        selectedCategory,
        selectedSeason,
        userCategories,
        isLoading,
        hasError,
      ];

  EditOutfitState copyWith({
    String? outfitId,
    Map<String, dynamic>? outfit,
    Map<String, dynamic>? currentUser,
    String? name,
    String? description,
    String? selectedCategory,
    String? selectedSeason,
    List<String>? userCategories,
    bool? isLoading,
    bool? hasError,
  }) {
    return EditOutfitState(
      outfitId: outfitId ?? this.outfitId,
      outfit: outfit ?? this.outfit,
      currentUser: currentUser ?? this.currentUser,
      name: name ?? this.name,
      description: description ?? this.description,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      userCategories: userCategories ?? this.userCategories,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }

  bool get isValid => name.trim().isNotEmpty && selectedCategory != null && selectedCategory!.isNotEmpty;
}