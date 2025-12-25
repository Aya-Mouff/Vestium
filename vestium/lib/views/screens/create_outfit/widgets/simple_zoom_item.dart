// lib/views/screens/create_outfit/widgets/simple_zoom_item.dart
import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../cubit/create_outfit_cubit.dart';
import '../cubit/create_outfit_state.dart';
import 'dart:io';

class SimpleZoomItem extends StatefulWidget {
  final PlacedItemModel placedItem;
  final Size canvasSize;
  final double canvasScale;
  final CreateOutfitCubit cubit;

  static bool hideZoomIndicators = false;

  const SimpleZoomItem({
    super.key,
    required this.placedItem,
    required this.canvasSize,
    required this.canvasScale,
    required this.cubit,
  });

  @override
  State<SimpleZoomItem> createState() => _SimpleZoomItemState();
}

class _SimpleZoomItemState extends State<SimpleZoomItem> {
  // LOCAL state for immediate visual feedback (no cubit updates during drag)
  Offset? _localPosition;
  double? _localScale;
  bool _isDragging = false;
  bool _isScaling = false;

  Offset _gestureStartPosition = Offset.zero;
  Offset _itemStartPosition = Offset.zero;
  double _scaleStartValue = 1.0;

  @override
  void didUpdateWidget(SimpleZoomItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset local state when not interacting
    if (!_isDragging && !_isScaling) {
      _localPosition = null;
      _localScale = null;
    }
  }

  // Use local state during interaction, cubit state otherwise
  Offset get effectivePosition => _localPosition ?? widget.placedItem.position;
  double get effectiveScale => _localScale ?? widget.placedItem.scale;

  @override
  Widget build(BuildContext context) {
    final itemWidth = 100 * effectiveScale;
    final itemHeight = 120 * effectiveScale;

    return Positioned(
      left: effectivePosition.dx,
      top: effectivePosition.dy,
      child: GestureDetector(
        onScaleStart: (details) {
          _gestureStartPosition = details.focalPoint;
          _itemStartPosition = widget.placedItem.position;
          _scaleStartValue = widget.placedItem.scale;
          widget.cubit.bringItemToFront(widget.placedItem.itemId);

          setState(() {
            _isDragging = false;
            _isScaling = false;
            _localPosition = widget.placedItem.position;
            _localScale = widget.placedItem.scale;
          });
        },
        onScaleUpdate: (details) {
          if (details.scale != 1.0 && details.pointerCount >= 2) {
            // SCALING (2+ fingers) - takes priority
            setState(() {
              _isScaling = true;
              _isDragging = false;
            });

            final scaleChange = details.scale - 1.0;
            final dampedScaleChange = scaleChange * 0.5;
            final newScale = (_scaleStartValue * (1.0 + dampedScaleChange)).clamp(0.3, 3.0);

            // Only update LOCAL state during gesture
            setState(() {
              _localScale = newScale;
            });
          } else if (details.pointerCount == 1) {
            // DRAGGING (1 finger)
            setState(() {
              _isDragging = true;
              _isScaling = false;
            });

            // Calculate total offset from start of gesture
            final totalDeltaX = (details.focalPoint.dx - _gestureStartPosition.dx) / widget.canvasScale;
            final totalDeltaY = (details.focalPoint.dy - _gestureStartPosition.dy) / widget.canvasScale;

            // Apply to original position
            final newPosition = Offset(
              (_itemStartPosition.dx + totalDeltaX).clamp(0.0, widget.canvasSize.width - itemWidth),
              (_itemStartPosition.dy + totalDeltaY).clamp(0.0, widget.canvasSize.height - itemHeight),
            );

            // Only update LOCAL state during gesture
            setState(() {
              _localPosition = newPosition;
            });
          }
        },
        onScaleEnd: (details) {
          // NOW update cubit once when gesture ends
          if (_localScale != null && _localScale != widget.placedItem.scale) {
            widget.cubit.updateItemScale(widget.placedItem.itemId, _localScale!);
          }
          if (_localPosition != null && _localPosition != widget.placedItem.position) {
            widget.cubit.updateItemPosition(widget.placedItem.itemId, _localPosition!);
          }

          setState(() {
            _isDragging = false;
            _isScaling = false;
            // Keep local state until next frame to avoid flicker
          });
        },
        onLongPress: () {
          _showItemOptions(context);
        },
        child: Container(
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isDragging ? const Color(0xFF8B6F47).withValues(alpha: .5) : Colors.transparent,
              width: _isDragging ? 3 : 0,
            ),
            boxShadow: _isDragging
                ? [BoxShadow(color: Colors.black.withValues(alpha: .2), blurRadius: 8, offset: const Offset(0, 4))]
                : null,
          ),
          child: ClipRRect(borderRadius: BorderRadius.circular(12), child: _buildImage()),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.placedItem.item.imagePath == null || widget.placedItem.item.imagePath!.isEmpty) {
      return _buildPlaceholder();
    }

    try {
      return Stack(
        children: [
          Image.file(
            File(widget.placedItem.item.imagePath!),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
          ),
          if (effectiveScale != 1.0 && !_isDragging && !_isScaling && !SimpleZoomItem.hideZoomIndicators)
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${(effectiveScale * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      );
    } catch (e) {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5ECE7),
      child: Center(child: Icon(Icons.photo, color: const Color(0xFFA1887F).withValues(alpha: .5), size: 32)),
    );
  }

  void _showItemOptions(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (dialogContext) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.zoom_in, color: Color(0xFF6B5344)),
            title: Text(loc.createOutfitZoomIn),
            onTap: () {
              final newScale = (widget.placedItem.scale * 1.1).clamp(0.3, 3.0);
              widget.cubit.updateItemScale(widget.placedItem.itemId, newScale);
              Navigator.pop(dialogContext);
            },
          ),
          ListTile(
            leading: const Icon(Icons.zoom_out, color: Color(0xFF6B5344)),
            title: Text(loc.createOutfitZoomOut),
            onTap: () {
              final newScale = (widget.placedItem.scale * 0.9).clamp(0.3, 3.0);
              widget.cubit.updateItemScale(widget.placedItem.itemId, newScale);
              Navigator.pop(dialogContext);
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh, color: Color(0xFF6B5344)),
            title: Text(loc.createOutfitResetSize),
            onTap: () {
              widget.cubit.updateItemScale(widget.placedItem.itemId, 1.0);
              Navigator.pop(dialogContext);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.layers, color: Color(0xFF6B5344)),
            title: Text(loc.createOutfitBringToFront),
            onTap: () {
              widget.cubit.bringItemToFront(widget.placedItem.itemId);
              Navigator.pop(dialogContext);
            },
          ),
          ListTile(
            leading: const Icon(Icons.layers_outlined, color: Color(0xFF6B5344)),
            title: Text(loc.createOutfitSendToBack),
            onTap: () {
              widget.cubit.sendItemToBack(widget.placedItem.itemId);
              Navigator.pop(dialogContext);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: Text(loc.createOutfitRemoveFromOutfit, style: const TextStyle(color: Colors.red)),
            onTap: () {
              widget.cubit.removeItemFromOutfit(widget.placedItem.itemId);
              Navigator.pop(dialogContext);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
