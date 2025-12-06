import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:vestium/databases/db_models.dart';

/// Model for an item placed in the outfit
class PlacedItemModel extends Equatable {
  final int itemId;
  final ItemModel item;
  final Offset position;

  const PlacedItemModel({
    required this.itemId,
    required this.item,
    this.position = const Offset(0, 0),
  });

  PlacedItemModel copyWith({int? itemId, ItemModel? item, Offset? position}) {
    return PlacedItemModel(
      itemId: itemId ?? this.itemId,
      item: item ?? this.item,
      position: position ?? this.position,
    );
  }

  @override
  List<Object?> get props => [itemId, item.itemId, position];
}

/// Base state for CreateOutfitCubit
abstract class CreateOutfitState extends Equatable {
  const CreateOutfitState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CreateOutfitInitial extends CreateOutfitState {
  const CreateOutfitInitial();
}

/// Loading state - fetching items
class CreateOutfitLoading extends CreateOutfitState {
  const CreateOutfitLoading();
}

/// Items loaded successfully
class CreateOutfitItemsLoaded extends CreateOutfitState {
  final List<ItemModel> availableItems;
  final List<PlacedItemModel> placedItems;
  final bool showAvailableItems;

  const CreateOutfitItemsLoaded({
    required this.availableItems,
    required this.placedItems,
    this.showAvailableItems = false,
  });

  CreateOutfitItemsLoaded copyWith({
    List<ItemModel>? availableItems,
    List<PlacedItemModel>? placedItems,
    bool? showAvailableItems,
  }) {
    return CreateOutfitItemsLoaded(
      availableItems: availableItems ?? this.availableItems,
      placedItems: placedItems ?? this.placedItems,
      showAvailableItems: showAvailableItems ?? this.showAvailableItems,
    );
  }

  @override
  List<Object?> get props => [availableItems, placedItems, showAvailableItems];
}

/// Saving state
class CreateOutfitSaving extends CreateOutfitState {
  const CreateOutfitSaving();
}

/// Outfit saved successfully
class CreateOutfitSaved extends CreateOutfitState {
  final OutfitModel outfit;

  const CreateOutfitSaved({required this.outfit});

  @override
  List<Object?> get props => [outfit.outfitId];
}

/// Error state
class CreateOutfitError extends CreateOutfitState {
  final String message;

  const CreateOutfitError(this.message);

  @override
  List<Object?> get props => [message];
}
