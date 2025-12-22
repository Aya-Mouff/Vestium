// lib/views/screens/create_outfit/widgets/outfit_canvas.dart
import 'package:flutter/material.dart';
import '../cubit/create_outfit_state.dart';
import 'item_gesture_handler.dart';

class OutfitCanvas extends StatelessWidget {
  final CreateOutfitItemsLoaded state;
  final Size canvasSize;
  final TransformationController transformationController;
  final bool showGrid;

  const OutfitCanvas({
    super.key,
    required this.state,
    required this.canvasSize,
    required this.transformationController,
    required this.showGrid,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: transformationController,
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.5,
      maxScale: 3.0,
      child: Container(
        width: canvasSize.width,
        height: canvasSize.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Grid Background
            if (showGrid) _buildGrid(),

            // All Placed Items
            ...state.placedItems.map((placedItem) {
              return Positioned(
                left: placedItem.position.dx,
                top: placedItem.position.dy,
                child: ItemGestureHandler(
                  placedItem: placedItem,
                  canvasSize: canvasSize,
                ),
              );
            }),  // ← ADD .toList() HERE
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    const gridSize = 20.0;
    const gridColor = Color(0xFFE8E8E8);

    return CustomPaint(
      size: canvasSize,
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