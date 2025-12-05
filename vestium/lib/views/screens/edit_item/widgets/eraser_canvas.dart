import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Interactive canvas widget for finger-based background erasing
class EraserCanvas extends StatefulWidget {
  final String imagePath;
  final double eraserSize;
  final VoidCallback? onImageUpdated;

  const EraserCanvas({
    super.key,
    required this.imagePath,
    required this.eraserSize,
    this.onImageUpdated,
  });

  @override
  State<EraserCanvas> createState() => EraserCanvasState();
}

class EraserCanvasState extends State<EraserCanvas> {
  final GlobalKey _canvasKey = GlobalKey();
  ui.Image? _originalImage;
  img.Image? _editableImage;
  List<EraserStroke> _strokes = [];
  Offset? _currentPoint;
  bool _isLoading = true;
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(EraserCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() => _isLoading = true);

    try {
      final file = File(widget.imagePath);
      final bytes = await file.readAsBytes();

      // Load for Flutter rendering
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      _originalImage = frame.image;

      // Load for editing with image package
      _editableImage = img.decodeImage(bytes);

      _imageSize = Size(
        _originalImage!.width.toDouble(),
        _originalImage!.height.toDouble(),
      );

      setState(() => _isLoading = false);
    } catch (e) {
      print('Error loading image: $e');
      setState(() => _isLoading = false);
    }
  }

  void _onPanStart(DragStartDetails details) {
    final renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(details.globalPosition);
    setState(() {
      _currentPoint = localPosition;
      _strokes.add(EraserStroke(
        points: [localPosition],
        eraserSize: widget.eraserSize,
      ));
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final localPosition = renderBox.globalToLocal(details.globalPosition);
    
    setState(() {
      _currentPoint = localPosition;
      if (_strokes.isNotEmpty) {
        _strokes.last.points.add(localPosition);
      }
    });

    // Apply erasing in real-time
    _applyEraserAtPoint(localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _currentPoint = null;
    });
    widget.onImageUpdated?.call();
  }

  void _applyEraserAtPoint(Offset point) {
    if (_editableImage == null || _imageSize == null) return;

    final renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final canvasSize = renderBox.size;

    // Convert canvas coordinates to image coordinates
    final scaleX = _editableImage!.width / canvasSize.width;
    final scaleY = _editableImage!.height / canvasSize.height;

    final imageX = (point.dx * scaleX).round();
    final imageY = (point.dy * scaleY).round();
    final radius = (widget.eraserSize * scaleX).round();

    // Erase pixels in circular area
    for (int dy = -radius; dy <= radius; dy++) {
      for (int dx = -radius; dx <= radius; dx++) {
        if (dx * dx + dy * dy <= radius * radius) {
          final x = imageX + dx;
          final y = imageY + dy;

          if (x >= 0 && x < _editableImage!.width && 
              y >= 0 && y < _editableImage!.height) {
            // Set alpha to 0 (transparent)
            final pixel = _editableImage!.getPixel(x, y);
            final r = img.getRed(pixel);
            final g = img.getGreen(pixel);
            final b = img.getBlue(pixel);
            // Use getColor() to get the color, then create new color with alpha = 0
            _editableImage!.setPixelRgba(x, y, r, g, b, 0);
          }
        }
      }
    }
  }

  Future<String> saveEditedImage() async {
    if (_editableImage == null) {
      throw Exception('No image to save');
    }

    try {
      // Encode to PNG to preserve transparency
      final pngBytes = img.encodePng(_editableImage!);

      // Save to app directory
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(p.join(appDir.path, 'vestium_images'));
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'edited_item_$timestamp.png';
      final newPath = p.join(imagesDir.path, filename);

      final file = File(newPath);
      await file.writeAsBytes(pngBytes);

      print('✅ Edited image saved: $newPath');
      return newPath;
    } catch (e) {
      print('❌ Error saving edited image: $e');
      rethrow;
    }
  }

  void clearStrokes() {
    setState(() {
      _strokes.clear();
      _currentPoint = null;
    });
    _loadImage(); // Reload original image
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _originalImage == null) {
      return Container(
        color: const Color(0xFFD7CCC8),
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF795548),
          ),
        ),
      );
    }

    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: RepaintBoundary(
        key: _canvasKey,
        child: CustomPaint(
          painter: EraserPainter(
            image: _originalImage!,
            editableImage: _editableImage!,
            strokes: _strokes,
            currentPoint: _currentPoint,
            eraserSize: widget.eraserSize,
          ),
          child: Container(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _originalImage?.dispose();
    super.dispose();
  }
}

class EraserStroke {
  final List<Offset> points;
  final double eraserSize;

  EraserStroke({
    required this.points,
    required this.eraserSize,
  });
}

class EraserPainter extends CustomPainter {
  final ui.Image image;
  final img.Image editableImage;
  final List<EraserStroke> strokes;
  final Offset? currentPoint;
  final double eraserSize;

  EraserPainter({
    required this.image,
    required this.editableImage,
    required this.strokes,
    this.currentPoint,
    required this.eraserSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the edited image with transparency
    final bytes = img.encodePng(editableImage);
    
    // For real-time display, we'll draw the original and apply masking
    canvas.saveLayer(null, Paint());
    
    // Draw the image
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      image: image,
      fit: BoxFit.contain,
    );

    // Draw eraser strokes as transparent areas
    final erasePaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.fill;

    for (final stroke in strokes) {
      for (final point in stroke.points) {
        canvas.drawCircle(point, stroke.eraserSize / 2, erasePaint);
      }
    }

    canvas.restore();

    // Draw current eraser indicator
    if (currentPoint != null) {
      final indicatorPaint = Paint()
        ..color = const Color(0xFF795548).withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(currentPoint!, eraserSize / 2, indicatorPaint);
    }
  }

  @override
  bool shouldRepaint(EraserPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentPoint != currentPoint ||
        oldDelegate.eraserSize != eraserSize;
  }
}