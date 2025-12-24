import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_item_cubit.dart';
import 'eraser_canvas.dart';
import 'crop_canvas.dart';

class PhotoPreview extends StatefulWidget {
  final String imagePath;

  const PhotoPreview({super.key, required this.imagePath});

  @override
  State<PhotoPreview> createState() => PhotoPreviewState();
}

class PhotoPreviewState extends State<PhotoPreview> {
  final GlobalKey<EraserCanvasState> _eraserCanvasKey =
      GlobalKey<EraserCanvasState>();
  final GlobalKey<CropCanvasState> _cropCanvasKey =
      GlobalKey<CropCanvasState>();
  String _currentImagePath = '';
  String? _lastSavedPath; // Track the last saved edited image

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.imagePath;
  }

  @override
  void didUpdateWidget(PhotoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _currentImagePath = widget.imagePath;
      _lastSavedPath = null;
    }
  }

  Future<String?> saveEditedImage() async {
    try {
      final newPath = await _eraserCanvasKey.currentState?.saveEditedImage();
      if (newPath != null) {
        setState(() {
          _currentImagePath = newPath;
          _lastSavedPath = newPath; // Save the edited path
        });
        print('✅ Photo preview updated with new path: $newPath');
      }
      return newPath;
    } catch (e) {
      print('❌ Error saving edited image: $e');
      return null;
    }
  }

  Future<String?> confirmEdits() async {
    print('🔍 confirmEdits called');

    // Check if crop mode is active
    if (_cropCanvasKey.currentState != null) {
      print('🔍 Crop mode detected');
      try {
        final newPath = await _cropCanvasKey.currentState!.saveCroppedImage();
        print('💾 Saved cropped image path: $newPath');

        setState(() {
          _currentImagePath = newPath;
          _lastSavedPath = newPath;
        });
        print('✅ Cropped image applied: $newPath');
        return newPath;
      } catch (e) {
        print('❌ Error in crop confirmEdits: $e');
        return null;
      }
    }

    // Check if eraser mode is active
    if (_eraserCanvasKey.currentState == null) {
      print('❌ EraserCanvas state is null');
      return null;
    }

    print('🔍 Eraser mode detected');
    try {
      final newPath = await _eraserCanvasKey.currentState!.saveEditedImage();
      print('💾 Saved image path: $newPath');

      setState(() {
        _currentImagePath = newPath;
        _lastSavedPath = newPath;
      });
      print('✅ Edited image applied: $newPath');
      return newPath;
    } catch (e) {
      print('❌ Error in confirmEdits: $e');
      return null;
    }
  }

  Future<String?> saveCroppedImage() async {
    print('🔍 saveCroppedImage called');

    if (_cropCanvasKey.currentState == null) {
      print('❌ CropCanvas state is null');
      return null;
    }

    try {
      final newPath = await _cropCanvasKey.currentState!.saveCroppedImage();
      print('💾 Saved cropped image path: $newPath');

      setState(() {
        _currentImagePath = newPath;
        _lastSavedPath = newPath;
      });
      print('✅ Cropped image applied: $newPath');

      // Update cubit state with the new path
      if (mounted) {
        context.read<EditItemCubit>().setEditedImagePath(newPath);
      }

      return newPath;
    } catch (e) {
      print('❌ Error in saveCroppedImage: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving crop: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  void resetImage() {
    _eraserCanvasKey.currentState?.clearStrokes();
    _cropCanvasKey.currentState?.clearCrop();
    setState(() {
      _currentImagePath = widget.imagePath;
      _lastSavedPath = null;
    });
  }

  String getCurrentImagePath() => _lastSavedPath ?? _currentImagePath;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditItemCubit, EditItemState>(
      builder: (context, state) {
        // Determine which image path to display
        final displayPath = state.editedImagePath ?? _currentImagePath;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF795548,
                  ).withAlpha((0.15 * 255).toInt()),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Show crop canvas when cropping
                  if (state.isCropping)
                    CropCanvas(key: _cropCanvasKey, imagePath: displayPath)
                  // Show eraser canvas when removing background
                  else if (state.isRemovingBg)
                    EraserCanvas(
                      key: _eraserCanvasKey,
                      imagePath: displayPath,
                      eraserSize: state.eraserSize,
                    )
                  else
                    // Show normal image preview
                    _ImageDisplay(imagePath: displayPath),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ImageDisplay extends StatelessWidget {
  final String imagePath;

  const _ImageDisplay({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(imagePath),
      key: ValueKey(imagePath), // Force rebuild when path changes
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFFD7CCC8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: const Color(0xFF795548).withAlpha((0.6 * 255).toInt()),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Failed to load image',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                    color: Color(0xFF795548),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
