// import 'package:equatable/equatable.dart';

// class EditOutfitState extends Equatable {
//   final String outfitId;
//   final Map<String, dynamic>? outfit;
//   final Map<String, dynamic>? currentUser;
//   final String name;
//   final String description;
//   final String? selectedCategory;
//   final String? selectedSeason;
//   final List<String> userCategories;
//   final bool isLoading;
//   final bool hasError;

//   const EditOutfitState({
//     required this.outfitId,
//     this.outfit,
//     this.currentUser,
//     this.name = '',
//     this.description = '',
//     this.selectedCategory,
//     this.selectedSeason,
//     this.userCategories = const [
//       'Casual',
//       'Formal',
//       'Streetwear',
//       'Work',
//       'Evening',
//       'Vacation'
//     ],
//     this.isLoading = true,
//     this.hasError = false,
//   });

//   @override
//   List<Object?> get props => [
//         outfitId,
//         outfit,
//         currentUser,
//         name,
//         description,
//         selectedCategory,
//         selectedSeason,
//         userCategories,
//         isLoading,
//         hasError,
//       ];

//   EditOutfitState copyWith({
//     String? outfitId,
//     Map<String, dynamic>? outfit,
//     Map<String, dynamic>? currentUser,
//     String? name,
//     String? description,
//     String? selectedCategory,
//     String? selectedSeason,
//     List<String>? userCategories,
//     bool? isLoading,
//     bool? hasError,
//   }) {
//     return EditOutfitState(
//       outfitId: outfitId ?? this.outfitId,
//       outfit: outfit ?? this.outfit,
//       currentUser: currentUser ?? this.currentUser,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       selectedCategory: selectedCategory ?? this.selectedCategory,
//       selectedSeason: selectedSeason ?? this.selectedSeason,
//       userCategories: userCategories ?? this.userCategories,
//       isLoading: isLoading ?? this.isLoading,
//       hasError: hasError ?? this.hasError,
//     );
//   }

//   bool get isValid => name.trim().isNotEmpty && selectedCategory != null && selectedCategory!.isNotEmpty;
// }

// ================================================================

// import 'package:equatable/equatable.dart';

// class EditOutfitState extends Equatable {
//   final String outfitId;
//   final Map<String, dynamic>? outfit;
//   final Map<String, dynamic>? currentUser;
//   final String name;
//   final String description;
//   final String? selectedCategory;
//   final String? selectedSeason;
//   final List<String> userCategories;
//   final bool isLoading;
//   final bool hasError;
//   final bool isDeleted;
//   final String? errorMessage;
//   final String? successMessage;
//   final List<Map<String, dynamic>> outfitItems;

//   const EditOutfitState({
//     required this.outfitId,
//     this.outfit,
//     this.currentUser,
//     this.name = '',
//     this.description = '',
//     this.selectedCategory,
//     this.selectedSeason,
//     this.userCategories = const [],
//     this.isLoading = true,
//     this.hasError = false,
//     this.isDeleted = false,
//     this.errorMessage,
//     this.successMessage,
//     this.outfitItems = const [],
//   });

//   @override
//   List<Object?> get props => [
//         outfitId,
//         outfit,
//         currentUser,
//         name,
//         description,
//         selectedCategory,
//         selectedSeason,
//         userCategories,
//         isLoading,
//         hasError,
//         isDeleted,
//         errorMessage,
//         successMessage,
//         outfitItems,
//       ];

//   EditOutfitState copyWith({
//     String? outfitId,
//     Map<String, dynamic>? outfit,
//     Map<String, dynamic>? currentUser,
//     String? name,
//     String? description,
//     String? selectedCategory,
//     String? selectedSeason,
//     List<String>? userCategories,
//     bool? isLoading,
//     bool? hasError,
//     bool? isDeleted,
//     String? errorMessage,
//     String? successMessage,
//     List<Map<String, dynamic>>? outfitItems,
//   }) {
//     return EditOutfitState(
//       outfitId: outfitId ?? this.outfitId,
//       outfit: outfit ?? this.outfit,
//       currentUser: currentUser ?? this.currentUser,
//       name: name ?? this.name,
//       description: description ?? this.description,
//       selectedCategory: selectedCategory ?? this.selectedCategory,
//       selectedSeason: selectedSeason ?? this.selectedSeason,
//       userCategories: userCategories ?? this.userCategories,
//       isLoading: isLoading ?? this.isLoading,
//       hasError: hasError ?? this.hasError,
//       isDeleted: isDeleted ?? this.isDeleted,
//       errorMessage: errorMessage ?? this.errorMessage,
//       successMessage: successMessage ?? this.successMessage,
//       outfitItems: outfitItems ?? this.outfitItems,
//     );
//   }

//   bool get isValid => name.trim().isNotEmpty && selectedCategory != null && selectedCategory!.isNotEmpty;
  
//   // Helper getters for easy access
//   String? get outfitImageUrl => outfit?['imageUrl'];
//   int get itemCount => outfitItems.length;
//   bool get hasImage => outfitImageUrl != null && outfitImageUrl!.isNotEmpty;
  
//   // Post-related getters
//   int get postCount => outfit?['postCount'] ?? 0;
//   bool get hasPosts => outfit?['hasPosts'] ?? false;
//   bool get canDelete => postCount == 0; // Can delete if no posts
// }

// ===============================================

import 'package:equatable/equatable.dart';

class EditOutfitState extends Equatable {
  final String outfitId;
  final Map<String, dynamic>? outfit;
  final Map<String, dynamic>? currentUser;
  final String name;
  final String description;
  final List<String> selectedCategories; // Changed from single to multiple
  final String? selectedSeason;
  final List<String> userCategories;
  final bool isLoading;
  final bool hasError;
  final bool isDeleted;
  final String? errorMessage;
  final String? successMessage;
  final List<Map<String, dynamic>> outfitItems;

  const EditOutfitState({
    required this.outfitId,
    this.outfit,
    this.currentUser,
    this.name = '',
    this.description = '',
    this.selectedCategories = const [],
    this.selectedSeason,
    this.userCategories = const [],
    this.isLoading = true,
    this.hasError = false,
    this.isDeleted = false,
    this.errorMessage,
    this.successMessage,
    this.outfitItems = const [],
  });

  @override
  List<Object?> get props => [
        outfitId,
        outfit,
        currentUser,
        name,
        description,
        selectedCategories,
        selectedSeason,
        userCategories,
        isLoading,
        hasError,
        isDeleted,
        errorMessage,
        successMessage,
        outfitItems,
      ];

  EditOutfitState copyWith({
    String? outfitId,
    Map<String, dynamic>? outfit,
    Map<String, dynamic>? currentUser,
    String? name,
    String? description,
    List<String>? selectedCategories,
    String? selectedSeason,
    List<String>? userCategories,
    bool? isLoading,
    bool? hasError,
    bool? isDeleted,
    String? errorMessage,
    String? successMessage,
    List<Map<String, dynamic>>? outfitItems,
  }) {
    return EditOutfitState(
      outfitId: outfitId ?? this.outfitId,
      outfit: outfit ?? this.outfit,
      currentUser: currentUser ?? this.currentUser,
      name: name ?? this.name,
      description: description ?? this.description,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      userCategories: userCategories ?? this.userCategories,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      isDeleted: isDeleted ?? this.isDeleted,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      outfitItems: outfitItems ?? this.outfitItems,
    );
  }

  bool get isValid =>
      name.trim().isNotEmpty && selectedCategories.isNotEmpty;

  // Helper getters
  String? get outfitImageUrl => outfit?['imageUrl'];
  int get itemCount => outfitItems.length;
  bool get hasImage => outfitImageUrl != null && outfitImageUrl!.isNotEmpty;

  // Post-related getters
  int get postCount => outfit?['postCount'] ?? 0;
  bool get hasPosts => outfit?['hasPosts'] ?? false;
  bool get canDelete => postCount == 0;
}