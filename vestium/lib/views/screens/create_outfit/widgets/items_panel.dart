// lib/views/screens/create_outfit/widgets/items_panel.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/create_outfit_cubit.dart';
import '../cubit/create_outfit_state.dart';
import 'item_widget.dart';
import 'package:vestium/databases/db_models.dart';

class ItemsPanel extends StatelessWidget {
  final CreateOutfitItemsLoaded state;
  final Size canvasSize;

  const ItemsPanel({super.key, required this.state, required this.canvasSize});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5)],
          ),
          child: Column(
            children: [
              // Handle
              _buildSheetHandle(),

              // Header
              _buildHeader(),

              // Items Grid
              Expanded(child: _buildItemsGrid(context, scrollController)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _buildHeader() {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            loc.createOutfitAddItems,
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C2C2C),
            ),
          ),
          Chip(
            backgroundColor: const Color(0xFFF5ECE7),
            label: Text(
              loc.createOutfitItemsCount(state.availableItems.length),
              style: const TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w500, color: Color(0xFF6B5344)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsGrid(BuildContext context, ScrollController scrollController) {
    return MasonryGridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: state.availableItems.length,
      itemBuilder: (context, index) {
        final item = state.availableItems[index];
        final isInOutfit = state.placedItems.any((pi) => pi.itemId == item.itemId);

        return GestureDetector(
          onTap: isInOutfit ? null : () => _addItemToOutfit(context, item),
          child: Stack(
            children: [
              // Item Card
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isInOutfit ? const Color(0xFF6B5344) : const Color(0xFFE8E8E8),
                    width: isInOutfit ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 4, offset: const Offset(0, 2)),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ItemWidget(item: item, isSelected: false, isDragging: false),
                ),
              ),

              // Check Badge
              if (isInOutfit)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Color(0xFF6B5344), shape: BoxShape.circle),
                    child: const Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                ),

              // Item Name
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .6),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    item.itemName ?? 'Item',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addItemToOutfit(BuildContext context, ItemModel item) {
    final loc = AppLocalizations.of(context)!;
    // Calculate smart position (not overlapping with existing items)
    final random = _getSmartPosition();

    BlocProvider.of<CreateOutfitCubit>(context).addItemToOutfitWithPosition(item, random);

    Navigator.pop(context);

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.createOutfitAddedToOutfit(item.itemName ?? 'Item')),
        backgroundColor: const Color(0xFF6B5344),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Offset _getSmartPosition() {
    // Try to find empty space
    const itemWidth = 100.0;
    const itemHeight = 120.0;
    const padding = 20.0;

    final random = Random();

    // Try 5 random positions
    for (int i = 0; i < 5; i++) {
      final candidate = Offset(
        random.nextDouble() * (canvasSize.width - itemWidth - padding * 2) + padding,
        random.nextDouble() * (canvasSize.height - itemHeight - padding * 2) + padding,
      );

      // Check if this position overlaps with existing items
      bool overlaps = false;
      for (final placedItem in state.placedItems) {
        final distance = (candidate - placedItem.position).distance;
        if (distance < itemWidth) {
          overlaps = true;
          break;
        }
      }

      if (!overlaps) {
        return candidate;
      }
    }

    // Fallback to random position
    return Offset(
      random.nextDouble() * (canvasSize.width - itemWidth - padding),
      random.nextDouble() * (canvasSize.height - itemHeight - padding),
    );
  }
}

// Add this helper class
class Random {
  double nextDouble() => math.Random().nextDouble();
}
