// lib/views/screens/create_outfit/widgets/item_gesture_handler.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/create_outfit_cubit.dart';
import '../cubit/create_outfit_state.dart';
//import '../placed_item_model.dart';
import 'item_widget.dart';

class ItemGestureHandler extends StatefulWidget {
  final PlacedItemModel placedItem;
  final Size canvasSize;

  const ItemGestureHandler({super.key, required this.placedItem, required this.canvasSize});

  @override
  State<ItemGestureHandler> createState() => _ItemGestureHandlerState();
}

class _ItemGestureHandlerState extends State<ItemGestureHandler> {
  bool _isDragging = false;
  bool _isSelected = false;
  Offset _dragOffset = Offset.zero;

  // Store the position when drag starts for accurate calculation
  Offset _dragStartPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      onLongPress: () {
        final loc = AppLocalizations.of(context)!;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.createOutfitRemoveItemTitle),
            content: Text(loc.createOutfitRemoveItemMessage),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: Text(loc.createOutfitCancel)),
              TextButton(
                onPressed: () {
                  context.read<CreateOutfitCubit>().removeItemFromOutfit(widget.placedItem.itemId);
                  Navigator.pop(context);
                },
                child: Text(loc.createOutfitRemove, style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      child: Draggable<PlacedItemModel>(
        data: widget.placedItem,
        feedback: Transform.scale(
          scale: 1.05,
          child: Opacity(
            opacity: 0.8,
            child: ItemWidget(item: widget.placedItem.item, isSelected: true, isDragging: true),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.4,
          child: ItemWidget(item: widget.placedItem.item, isSelected: _isSelected, isDragging: false),
        ),
        onDragStarted: () {
          setState(() {
            _isDragging = true;
            _isSelected = true;
            _dragStartPosition = widget.placedItem.position;
            _dragOffset = Offset.zero;
          });
        },
        onDragUpdate: (details) {
          setState(() {
            _dragOffset = details.delta;
          });

          // Calculate new position with boundaries
          final newPosition = _calculateNewPosition(_dragStartPosition + details.delta);

          // Update position through cubit
          context.read<CreateOutfitCubit>().updateItemPosition(widget.placedItem.itemId, newPosition);
        },
        onDragEnd: (details) {
          final currentPosition = widget.placedItem.position;
          final snappedPosition = _snapToGrid(currentPosition);

          // Apply grid snapping on drag end
          context.read<CreateOutfitCubit>().updateItemPosition(widget.placedItem.itemId, snappedPosition);

          setState(() {
            _isDragging = false;
            _dragOffset = Offset.zero;
            _dragStartPosition = Offset.zero;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.translationValues(_dragOffset.dx, _dragOffset.dy, 0),
          child: ItemWidget(item: widget.placedItem.item, isSelected: _isSelected, isDragging: _isDragging),
        ),
      ),
    );
  }

  // Calculate new position with boundary checking
  Offset _calculateNewPosition(Offset proposedPosition) {
    const itemWidth = 100.0;
    const itemHeight = 120.0;
    const padding = 10.0;

    double clampedX = proposedPosition.dx.clamp(padding, widget.canvasSize.width - itemWidth - padding);

    double clampedY = proposedPosition.dy.clamp(padding, widget.canvasSize.height - itemHeight - padding);

    return Offset(clampedX, clampedY);
  }

  // Snap position to grid (20px grid)
  Offset _snapToGrid(Offset position) {
    const gridSize = 20.0;

    double snappedX = (position.dx / gridSize).round() * gridSize;
    double snappedY = (position.dy / gridSize).round() * gridSize;

    // Make sure snapped position is still within bounds
    return _calculateNewPosition(Offset(snappedX, snappedY));
  }
}
