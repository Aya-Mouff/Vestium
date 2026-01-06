// lib/views/screens/create_outfit/widgets/advanced_outfit_editor.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/create_outfit_cubit.dart';
import '../cubit/create_outfit_state.dart';
import 'dart:io';

class AdvancedOutfitEditor extends StatefulWidget {
  final CreateOutfitItemsLoaded state;
  final Size canvasSize;

  const AdvancedOutfitEditor({
    super.key,
    required this.state,
    required this.canvasSize,
  });

  @override
  State<AdvancedOutfitEditor> createState() => _AdvancedOutfitEditorState();
}

class _AdvancedOutfitEditorState extends State<AdvancedOutfitEditor> {
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;
  final bool _showGrid = true;

  @override
  void initState() {
    super.initState();
    _transformationController.addListener(_onTransformChanged);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformChanged);
    _transformationController.dispose();
    super.dispose();
  }

  void _onTransformChanged() {
    final matrix = _transformationController.value;
    _currentScale = matrix.getMaxScaleOnAxis();
  }

  void _handleItemTap(int itemId) {
    print('✅ Item $itemId tapped');
    // You could add selection logic here
  }

  void _handleItemDrag(int itemId, Offset newPosition) {
    // Apply scale correction for zoom
    final correctedPosition = Offset(
      newPosition.dx / _currentScale,
      newPosition.dy / _currentScale,
    );
    
    context.read<CreateOutfitCubit>().updateItemPosition(
      itemId,
      correctedPosition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Interactive Canvas
        InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: const EdgeInsets.all(double.infinity),
          minScale: 0.5,
          maxScale: 3.0,
          child: Container(
            width: widget.canvasSize.width,
            height: widget.canvasSize.height,
            color: Colors.white,
            child: Stack(
              children: [
                // Grid
                if (_showGrid) _buildGrid(),
                
                // Items
                ...widget.state.placedItems.map((placedItem) {
                  return Positioned(
                    left: placedItem.position.dx * _currentScale,
                    top: placedItem.position.dy * _currentScale,
                    child: _buildDraggableItem(placedItem),
                  );
                }),
              ],
            ),
          ),
        ),

        // Debug overlay to show what's happening
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Debug Info',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Scale: ${_currentScale.toStringAsFixed(2)}x',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  'Items: ${widget.state.placedItems.length}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableItem(PlacedItemModel placedItem) {
    return GestureDetector(
      onTap: () {
        _handleItemTap(placedItem.itemId);
        print('📱 Tapped item at position: ${placedItem.position}');
      },
      onPanStart: (details) {
        print('🟡 Drag started for item ${placedItem.itemId}');
      },
      onPanUpdate: (details) {
        // Calculate new position
        final newPosition = Offset(
          placedItem.position.dx + (details.delta.dx / _currentScale),
          placedItem.position.dy + (details.delta.dy / _currentScale),
        );
        
        _handleItemDrag(placedItem.itemId, newPosition);
      },
      onPanEnd: (details) {
        print('🟢 Drag ended for item ${placedItem.itemId}');
      },
      child: Container(
        width: 100,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF6B5344),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _buildItemImage(placedItem.item.imagePath),
        ),
      ),
    );
  }

  Widget _buildItemImage(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5ECE7),
      child: Center(
        child: Icon(
          Icons.photo,
          size: 32,
          color: const Color(0xFFA1887F).withValues(alpha: .5),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    const gridSize = 20.0;
    const gridColor = Color(0xFFF0F0F0);

    return CustomPaint(
      size: widget.canvasSize,
      painter: _GridPainter(gridSize: gridSize, gridColor: gridColor),
    );
  }
}

class _GridPainter extends CustomPainter {
  final double gridSize;
  final Color gridColor;

  const _GridPainter({required this.gridSize, required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
