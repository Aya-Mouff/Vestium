// Create a new file: lib/models/placed_item_model.dart
import 'dart:ui';
import '../../../databases/db_models.dart';

class PlacedItemModel {
  final int itemId;
  final ItemModel item;
  final Offset position;

  PlacedItemModel({
    required this.itemId,
    required this.item,
    required this.position,
  });

  PlacedItemModel copyWith({
    int? itemId,
    ItemModel? item,
    Offset? position,
  }) {
    return PlacedItemModel(
      itemId: itemId ?? this.itemId,
      item: item ?? this.item,
      position: position ?? this.position,
    );
  }
}