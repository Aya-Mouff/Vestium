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
  img.Image? _maskImage; // Separate mask for transparency
  
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
      final decodedImage = img.decodeImage(bytes);
      if (decodedImage == null) {
        throw Exception('Failed to decode image');
      }
      
      _editableImage = decodedImage;
      
      // Create a separate mask image (all opaque initially)
      _maskImage = img.Image(
        decodedImage.width,
        decodedImage.height,
      );
      
      // Fill mask with white (fully opaque)
      img.fill(_maskImage!, img.getColor(255, 255, 255, 255));

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
        eraserSize: widget.eraserSize, // Use current eraser size
      ));
    });
    
    // Apply erasing immediately
    _applyEraserAtPoint(localPosition);
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
    if (_maskImage == null || _imageSize == null) return;

    final renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final canvasSize = renderBox.size;

    // Convert canvas coordinates to image coordinates
    final scaleX = _maskImage!.width / canvasSize.width;
    final scaleY = _maskImage!.height / canvasSize.height;

    final imageX = (point.dx * scaleX).round();
    final imageY = (point.dy * scaleY).round();
    final radius = (widget.eraserSize * scaleX / 2).round();

    // Optimized circle erasing - only update mask
    final radiusSquared = radius * radius;
    for (int dy = -radius; dy <= radius; dy++) {
      final dySquared = dy * dy;
      for (int dx = -radius; dx <= radius; dx++) {
        if (dx * dx + dySquared <= radiusSquared) {
          final x = imageX + dx;
          final y = imageY + dy;

          if (x >= 0 && x < _maskImage!.width && 
              y >= 0 && y < _maskImage!.height) {
            // Set mask to transparent (black with alpha 0)
            _maskImage!.setPixelRgba(x, y, 0, 0, 0, 0);
          }
        }
      }
    }
  }

  Future<String> saveEditedImage() async {
    if (_editableImage == null || _maskImage == null) {
      throw Exception('No image to save');
    }

    try {
      // Create final image by applying mask to original
      final finalImage = img.Image(
        _editableImage!.width,
        _editableImage!.height,
      );

      // Apply mask to create transparent areas
      for (int y = 0; y < finalImage.height; y++) {
        for (int x = 0; x < finalImage.width; x++) {
          final pixel = _editableImage!.getPixel(x, y);
          final maskPixel = _maskImage!.getPixel(x, y);
          final maskAlpha = img.getAlpha(maskPixel);
          
          if (maskAlpha == 0) {
            // Transparent pixel
            finalImage.setPixelRgba(x, y, 0, 0, 0, 0);
          } else {
            // Keep original pixel
            finalImage.setPixel(x, y, pixel);
          }
        }
      }

      // Encode to PNG to preserve transparency
      final pngBytes = img.encodePng(finalImage);

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
            maskImage: _maskImage!,
            strokes: _strokes,
            currentPoint: _currentPoint,
            eraserSize: widget.eraserSize, // Use current size from widget
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
  final img.Image maskImage;
  final List<EraserStroke> strokes;
  final Offset? currentPoint;
  final double eraserSize;

  EraserPainter({
    required this.image,
    required this.maskImage,
    required this.strokes,
    this.currentPoint,
    required this.eraserSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the image with transparency applied
    canvas.saveLayer(null, Paint());
    
    // Draw the base image
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      image: image,
      fit: BoxFit.contain,
    );

    // Apply mask using blend mode
    final erasePaint = Paint()
      ..color = Colors.transparent
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.fill;

    // Draw all strokes as erased areas
    for (final stroke in strokes) {
      for (final point in stroke.points) {
        canvas.drawCircle(point, stroke.eraserSize / 2, erasePaint);
      }
    }

    canvas.restore();

    // Draw current eraser indicator with current size
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