import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CropCanvas extends StatefulWidget {
  final String imagePath;

  const CropCanvas({super.key, required this.imagePath});

  @override
  State<CropCanvas> createState() => CropCanvasState();
}

class CropCanvasState extends State<CropCanvas> {
  final GlobalKey _canvasKey = GlobalKey();

  ui.Image? _originalImage;
  img.Image? _editableImage;
  bool _isLoading = true;
  Size? _imageSize;

  // Normalized crop area (0.0 to 1.0)
  double _cropLeft = 0.1;
  double _cropTop = 0.1;
  double _cropRight = 0.9;
  double _cropBottom = 0.9;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CropCanvas oldWidget) {
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

      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      _originalImage = frame.image;

      final decoded = img.decodeImage(bytes);
      if (decoded == null) throw Exception("Failed to decode image");

      _editableImage = decoded;

      _imageSize = Size(
        _originalImage!.width.toDouble(),
        _originalImage!.height.toDouble(),
      );

      setState(() => _isLoading = false);
    } catch (e) {
      print("Error loading image for crop: $e");
      setState(() => _isLoading = false);
    }
  }

  void clearCrop() {
    setState(() {
      _cropLeft = 0.1;
      _cropTop = 0.1;
      _cropRight = 0.9;
      _cropBottom = 0.9;
    });
  }

  Future<String> saveCroppedImage() async {
    if (_editableImage == null) {
      throw Exception("No image to crop");
    }

    try {
      print('🎬 saveCroppedImage started');

      // Calculate crop rectangle in image pixels
      final cropWidth = (_cropRight - _cropLeft) * _imageSize!.width;
      final cropHeight = (_cropBottom - _cropTop) * _imageSize!.height;
      final cropX = (_cropLeft * _imageSize!.width).toInt();
      final cropY = (_cropTop * _imageSize!.height).toInt();

      print(
        '📐 Crop dimensions: x=$cropX, y=$cropY, w=${cropWidth.toInt()}, h=${cropHeight.toInt()}',
      );
      print(
        '🖼️ Original image size: ${_editableImage!.width}x${_editableImage!.height}',
      );

      // Crop the image
      final croppedImage = img.copyCrop(
        _editableImage!,
        cropX,
        cropY,
        cropWidth.toInt(),
        cropHeight.toInt(),
      );
      print('✂️ Image cropped: ${croppedImage.width}x${croppedImage.height}');

      // Encode to PNG bytes
      final pngBytes = img.encodePng(croppedImage);
      print('📦 PNG encoded: ${pngBytes.length} bytes');

      if (pngBytes.isEmpty) {
        throw Exception('PNG encoding resulted in empty bytes');
      }

      // Save to application documents directory (same as eraser)
      final dir = await getApplicationDocumentsDirectory();
      print('📁 App documents dir: ${dir.path}');

      final folder = Directory(p.join(dir.path, 'vestium_images'));
      print('📁 Checking vestium_images folder: ${folder.path}');

      if (!await folder.exists()) {
        print('📁 Creating vestium_images folder...');
        await folder.create(recursive: true);
        print('✅ vestium_images folder created');
      } else {
        print('✅ vestium_images folder exists');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final path = p.join(folder.path, "cropped_$timestamp.png");
      print('💾 Saving to: $path');

      // Write file with better error handling
      final file = File(path);
      await file.writeAsBytes(pngBytes);
      print('✅ File written to disk');

      // Verify the file was actually written
      final fileExists = await file.exists();
      print('🔍 File exists check: $fileExists');

      if (!fileExists) {
        throw Exception('File was not actually written to disk at: $path');
      }

      final fileSize = await file.length();
      print('📊 File size: $fileSize bytes');

      if (fileSize == 0) {
        throw Exception('File was written but is empty');
      }

      print('✅ Cropped image successfully saved to: $path');
      return path;
    } catch (e) {
      print('❌ Error saving cropped image: $e');
      print('❌ Stack trace: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Crop error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF795548)),
      );
    }

    return GestureDetector(
      onPanUpdate: (details) {
        // Allow dragging handles to adjust crop area
        final renderBox =
            _canvasKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox == null) return;

        final size = renderBox.size;
        final delta = details.delta;

        setState(() {
          // Simplified: drag anywhere in crop area to move it, or drag handles to resize
          // For now, allow corner dragging based on position
          final localPos = renderBox.globalToLocal(details.globalPosition);

          // Detect which area was touched (simplified edge detection)
          final leftEdge = _cropLeft * size.width;
          final rightEdge = _cropRight * size.width;
          final topEdge = _cropTop * size.height;
          final bottomEdge = _cropBottom * size.height;

          // Handle size tolerance
          const tolerance = 30.0;

          final nearLeft = (localPos.dx - leftEdge).abs() < tolerance;
          final nearRight = (rightEdge - localPos.dx).abs() < tolerance;
          final nearTop = (localPos.dy - topEdge).abs() < tolerance;
          final nearBottom = (bottomEdge - localPos.dy).abs() < tolerance;

          if (nearLeft) {
            _cropLeft = (_cropLeft + delta.dx / size.width).clamp(
              0.0,
              _cropRight - 0.1,
            );
          }
          if (nearRight) {
            _cropRight = (_cropRight + delta.dx / size.width).clamp(
              _cropLeft + 0.1,
              1.0,
            );
          }
          if (nearTop) {
            _cropTop = (_cropTop + delta.dy / size.height).clamp(
              0.0,
              _cropBottom - 0.1,
            );
          }
          if (nearBottom) {
            _cropBottom = (_cropBottom + delta.dy / size.height).clamp(
              _cropTop + 0.1,
              1.0,
            );
          }
        });
      },
      child: Stack(
        key: _canvasKey,
        fit: StackFit.expand,
        children: [
          if (_originalImage != null)
            RawImage(image: _originalImage)
          else
            Container(color: Colors.grey[300]),
          _buildCropOverlay(),
        ],
      ),
    );
  }

  Widget _buildCropOverlay() {
    return CustomPaint(
      painter: CropOverlayPainter(
        cropLeft: _cropLeft,
        cropTop: _cropTop,
        cropRight: _cropRight,
        cropBottom: _cropBottom,
      ),
    );
  }
}

class CropOverlayPainter extends CustomPainter {
  final double cropLeft;
  final double cropTop;
  final double cropRight;
  final double cropBottom;

  CropOverlayPainter({
    required this.cropLeft,
    required this.cropTop,
    required this.cropRight,
    required this.cropBottom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Darken outside areas
    final darkPaint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    final cropRect = Rect.fromLTRB(
      cropLeft * size.width,
      cropTop * size.height,
      cropRight * size.width,
      cropBottom * size.height,
    );

    // Draw dark overlays on all four sides
    canvas.drawRect(
      Rect.fromLTRB(0, 0, size.width, cropTop * size.height),
      darkPaint,
    );
    canvas.drawRect(
      Rect.fromLTRB(0, cropBottom * size.height, size.width, size.height),
      darkPaint,
    );
    canvas.drawRect(
      Rect.fromLTRB(
        0,
        cropTop * size.height,
        cropLeft * size.width,
        cropBottom * size.height,
      ),
      darkPaint,
    );
    canvas.drawRect(
      Rect.fromLTRB(
        cropRight * size.width,
        cropTop * size.height,
        size.width,
        cropBottom * size.height,
      ),
      darkPaint,
    );

    // Draw grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    final cellWidth = cropRect.width / 3;
    final cellHeight = cropRect.height / 3;

    // Vertical lines
    canvas.drawLine(
      Offset(cropRect.left + cellWidth, cropRect.top),
      Offset(cropRect.left + cellWidth, cropRect.bottom),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left + cellWidth * 2, cropRect.top),
      Offset(cropRect.left + cellWidth * 2, cropRect.bottom),
      gridPaint,
    );

    // Horizontal lines
    canvas.drawLine(
      Offset(cropRect.left, cropRect.top + cellHeight),
      Offset(cropRect.right, cropRect.top + cellHeight),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropRect.left, cropRect.top + cellHeight * 2),
      Offset(cropRect.right, cropRect.top + cellHeight * 2),
      gridPaint,
    );

    // Draw border of crop area
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(cropRect, borderPaint);
  }

  @override
  bool shouldRepaint(CropOverlayPainter oldDelegate) {
    return oldDelegate.cropLeft != cropLeft ||
        oldDelegate.cropTop != cropTop ||
        oldDelegate.cropRight != cropRight ||
        oldDelegate.cropBottom != cropBottom;
  }
}
