import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
import 'package:vestium/databases/db_models.dart';
// import 'package:vestium/repo/outfit_category_repo.dart';

/// Base state for SaveOutfitCubit
abstract class SaveOutfitState extends Equatable {
  const SaveOutfitState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SaveOutfitInitial extends SaveOutfitState {
  const SaveOutfitInitial();
}

/// Loading state - fetching categories
class SaveOutfitLoading extends SaveOutfitState {
  const SaveOutfitLoading();
}

/// Data loaded successfully
class SaveOutfitDataLoaded extends SaveOutfitState {
  final List<OutfitCategory> allCategories;
  final List<int> selectedCategoryIds;
  final String outfitName;
  final String description;
  final String? selectedSeason;
  final int itemsCount;
  final bool isSaving;

  const SaveOutfitDataLoaded({
    required this.allCategories,
    this.selectedCategoryIds = const [],
    this.outfitName = '',
    this.description = '',
    this.selectedSeason,
    required this.itemsCount,
    this.isSaving = false,
  });

  SaveOutfitDataLoaded copyWith({
    List<OutfitCategory>? allCategories,
    List<int>? selectedCategoryIds,
    String? outfitName,
    String? description,
    String? selectedSeason,
    int? itemsCount,
    bool? isSaving,
  }) {
    return SaveOutfitDataLoaded(
      allCategories: allCategories ?? this.allCategories,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      outfitName: outfitName ?? this.outfitName,
      description: description ?? this.description,
      selectedSeason: selectedSeason ?? this.selectedSeason,
      itemsCount: itemsCount ?? this.itemsCount,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  List<Object?> get props => [
        allCategories,
        selectedCategoryIds,
        outfitName,
        description,
        selectedSeason,
        itemsCount,
        isSaving,
      ];
}

/// Saving state
class SaveOutfitSaving extends SaveOutfitState {
  const SaveOutfitSaving();
}

/// Outfit saved successfully
class SaveOutfitSaved extends SaveOutfitState {
  final OutfitModel outfit;

  const SaveOutfitSaved({required this.outfit});

  @override
  List<Object?> get props => [outfit.outfitId];
}

/// Error state
class SaveOutfitError extends SaveOutfitState {
  final String message;

  const SaveOutfitError(this.message);

  @override
  List<Object?> get props => [message];
}