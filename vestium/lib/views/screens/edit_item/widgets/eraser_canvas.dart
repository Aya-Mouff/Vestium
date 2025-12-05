import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
  img.Image? _maskImage;

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

  // -------------------
  // LOAD IMAGE
  // -------------------

  Future<void> _loadImage() async {
    setState(() => _isLoading = true);

    try {
      final file = File(widget.imagePath);
      final bytes = await file.readAsBytes();

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      _originalImage = frame.image;

      final decoded = img.decodeImage(bytes);
      if (decoded == null) throw Exception("Failed to decode image");

      _editableImage = decoded;

      _maskImage = img.Image(decoded.width, decoded.height);
      img.fill(_maskImage!, img.getColor(255, 255, 255, 255));

      _imageSize = Size(
        _originalImage!.width.toDouble(),
        _originalImage!.height.toDouble(),
      );

      setState(() => _isLoading = false);
    } catch (e) {
      print("Error loading image: $e");
      setState(() => _isLoading = false);
    }
  }

  // -------------------
  // TOUCH HANDLERS
  // -------------------

  void _onPanStart(DragStartDetails details) {
    final renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final local = renderBox.globalToLocal(details.globalPosition);

    setState(() {
      _currentPoint = local;
      _strokes.add(EraserStroke(points: [local], eraserSize: widget.eraserSize));
    });

    _applyEraserAtPoint(local);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final local = renderBox.globalToLocal(details.globalPosition);

    setState(() {
      _currentPoint = local;
      _strokes.last.points.add(local);
    });

    _applyEraserAtPoint(local);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() => _currentPoint = null);
    widget.onImageUpdated?.call();
  }

  // -------------------
  // FIX: MATCH Touch → Image Pixel
  // -------------------

  Rect _calculateImageRect(Size canvas, ui.Image image) {
    final imageAspect = image.width / image.height;
    final canvasAspect = canvas.width / canvas.height;

    double drawW, drawH;

    if (imageAspect > canvasAspect) {
      drawW = canvas.width;
      drawH = drawW / imageAspect;
    } else {
      drawH = canvas.height;
      drawW = drawH * imageAspect;
    }

    final offsetX = (canvas.width - drawW) / 2;
    final offsetY = (canvas.height - drawH) / 2;

    return Rect.fromLTWH(offsetX, offsetY, drawW, drawH);
  }

  void _applyEraserAtPoint(Offset point) {
    if (_maskImage == null || _originalImage == null) return;

    final renderBox = _canvasKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final canvasSize = renderBox.size;
    final imageRect = _calculateImageRect(canvasSize, _originalImage!);

    // Touch outside actual image → ignore
    if (!imageRect.contains(point)) return;

    // Normalize (0 → 1)
    final dx = (point.dx - imageRect.left) / imageRect.width;
    final dy = (point.dy - imageRect.top) / imageRect.height;

    // Convert to pixel coordinates
    final imageX = (dx * _maskImage!.width).round();
    final imageY = (dy * _maskImage!.height).round();
    final radius = (widget.eraserSize / imageRect.width * _maskImage!.width / 2).round();

    final r2 = radius * radius;

    for (int dy = -radius; dy <= radius; dy++) {
      final dy2 = dy * dy;
      for (int dx = -radius; dx <= radius; dx++) {
        if (dx * dx + dy2 <= r2) {
          final x = imageX + dx;
          final y = imageY + dy;
          if (x >= 0 && x < _maskImage!.width && y >= 0 && y < _maskImage!.height) {
            _maskImage!.setPixelRgba(x, y, 0, 0, 0, 0);
          }
        }
      }
    }
  }

  // -------------------
  // SAVING
  // -------------------

  Future<String> saveEditedImage() async {
    if (_editableImage == null || _maskImage == null) {
      throw Exception("No image to save");
    }

    final finalImage = img.Image(_editableImage!.width, _editableImage!.height);

    for (int y = 0; y < finalImage.height; y++) {
      for (int x = 0; x < finalImage.width; x++) {
        final pixel = _editableImage!.getPixel(x, y);
        final mask = _maskImage!.getPixel(x, y);
        final alpha = img.getAlpha(mask);

        if (alpha == 0) {
          finalImage.setPixelRgba(x, y, 0, 0, 0, 0);
        } else {
          finalImage.setPixel(x, y, pixel);
        }
      }
    }

    final png = img.encodePng(finalImage);

    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory(p.join(dir.path, 'vestium_images'));
    if (!await folder.exists()) folder.createSync(recursive: true);

    final path = p.join(folder.path, "edited_${DateTime.now().millisecondsSinceEpoch}.png");
    final file = File(path)..writeAsBytesSync(png);

    return path;
  }

  void clearStrokes() {
    setState(() {
      _strokes.clear();
      _currentPoint = null;
    });
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _originalImage == null) {
      return const Center(child: CircularProgressIndicator());
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
            mask: _maskImage!,
            strokes: _strokes,
            current: _currentPoint,
            eraserSize: widget.eraserSize,
          ),
          child: Container(),
        ),
      ),
    );
  }
}

class EraserStroke {
  final List<Offset> points;
  final double eraserSize;

  EraserStroke({required this.points, required this.eraserSize});
}

class EraserPainter extends CustomPainter {
  final ui.Image image;
  final img.Image mask;
  final List<EraserStroke> strokes;
  final Offset? current;
  final double eraserSize;

  EraserPainter({
    required this.image,
    required this.mask,
    required this.strokes,
    required this.current,
    required this.eraserSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(null, Paint());

    // DRAW IMAGE WITH SAME RECT AS LOGIC
    final rect = _calculateImageRect(size, image);

    paintImage(
      canvas: canvas,
      rect: rect,
      image: image,
      fit: BoxFit.contain,
    );

    final erasePaint = Paint()
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.fill;

    for (final s in strokes) {
      for (final p in s.points) {
        canvas.drawCircle(p, s.eraserSize / 2, erasePaint);
      }
    }

    canvas.restore();

    if (current != null) {
      final p = Paint()
        ..color = Colors.brown.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(current!, eraserSize / 2, p);
    }
  }

  @override
  bool shouldRepaint(covariant EraserPainter old) =>
      strokes != old.strokes || current != old.current || eraserSize != old.eraserSize;
}

// Duplicate helper for painter
Rect _calculateImageRect(Size canvas, ui.Image image) {
  final imageAspect = image.width / image.height;
  final canvasAspect = canvas.width / canvas.height;

  double w, h;

  if (imageAspect > canvasAspect) {
    w = canvas.width;
    h = w / imageAspect;
  } else {
    h = canvas.height;
    w = h * imageAspect;
  }

  return Rect.fromLTWH(
    (canvas.width - w) / 2,
    (canvas.height - h) / 2,
    w,
    h,
  );
}
