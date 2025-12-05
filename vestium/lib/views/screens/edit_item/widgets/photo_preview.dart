import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/edit_item_cubit.dart';
import 'eraser_canvas.dart';

class PhotoPreview extends StatefulWidget {
  final String imagePath;

  const PhotoPreview({super.key, required this.imagePath});

  @override
  State<PhotoPreview> createState() => PhotoPreviewState();
}

class PhotoPreviewState extends State<PhotoPreview> {
  final GlobalKey<EraserCanvasState> _eraserCanvasKey = GlobalKey<EraserCanvasState>();
  String _currentImagePath = '';
  String? _lastSavedPath; // Track the last saved edited image
  // In photo_preview.dart - make sure this method exists in PhotoPreviewState

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
    
    if (_eraserCanvasKey.currentState == null) {
      print('❌ EraserCanvas state is null');
      return null;
    }

    try {
      final newPath = await _eraserCanvasKey.currentState!.saveEditedImage();
      print('💾 Saved image path: $newPath');
      
      if (newPath != null) {
        setState(() {
          _currentImagePath = newPath;
          _lastSavedPath = newPath;
        });
        print('✅ Edited image applied: $newPath');
        return newPath;
      } else {
        print('❌ saveEditedImage returned null');
        return null;
      }
    } catch (e) {
      print('❌ Error in confirmEdits: $e');
      return null;
    }
  }


  void resetImage() {
    _eraserCanvasKey.currentState?.clearStrokes();
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
        // Use edited image path from state if available and not in remove BG mode
        final displayPath = !state.isRemovingBg && state.editedImagePath != null
            ? state.editedImagePath!
            : _currentImagePath;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF795548).withAlpha((0.15 * 255).toInt()),
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
                  // Show eraser canvas when removing background
                  if (state.isRemovingBg)
                    EraserCanvas(
                      key: _eraserCanvasKey,
                      imagePath: displayPath,
                      eraserSize: state.eraserSize,
                    )
                  else
                    // Show normal image preview with proper refresh
                    _ImageDisplay(imagePath: displayPath),
                  
                  // Instruction overlay when in eraser mode
                  if (state.isRemovingBg)
                    Positioned(
                      top: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF795548).withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.touch_app,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Touch the image to erase background',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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