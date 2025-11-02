import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';

@RoutePage()
class EditItemScreen extends StatefulWidget {
  final String imagePath;

  const EditItemScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  bool _isCropping = false;
  bool _isRemovingBg = false;
  double _eraserSize = 50.0;

  void _cropImage() {
    setState(() => _isCropping = true);
    // Implement crop functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Crop functionality - Coming soon'),
        backgroundColor: Color(0xFF795548),
      ),
    );
    setState(() => _isCropping = false);
  }

  void _removeBackground() {
    setState(() => _isRemovingBg = true);
  }

  void _cancelRemoveBg() {
    setState(() => _isRemovingBg = false);
  }

  void _saveAndContinue() {
    if (_isRemovingBg) {
      // If in remove BG mode, exit that mode
      _cancelRemoveBg();
    } else {
      // Navigate to next screen (add details screen)
      context.router.push(
      ItemDetailsRoute(imagePath: widget.imagePath),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_isRemovingBg) {
                        _cancelRemoveBg();
                      } else {
                        context.router.maybePop();
                      }
                    },
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFF3E2723),
                      size: 24,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Edit Item',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3E2723),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _saveAndContinue,
                    child: const Icon(
                      Icons.check,
                      color: Color(0xFF3E2723),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            // Photo Preview
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF795548).withValues(alpha: 0.15),
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
                      Image.file(
                        File(widget.imagePath),
                        fit: BoxFit.cover,
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
                                    color: const Color(0xFF795548).withValues(alpha: 0.6),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Actions
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(24),
              ),
              child: _isRemovingBg ? _buildRemoveBgControls() : _buildEditButtons(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButtons() {
    return Column(
      children: [
        // Action Buttons Row
        Row(
          children: [
            // Crop Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isCropping ? null : _cropImage,
                icon: const Icon(Icons.crop_rotate, size: 20),
                label: const Text(
                  'Crop',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 0.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD7CCC8),
                  foregroundColor: const Color(0xFF795548),
                  disabledBackgroundColor: const Color(0xFFD7CCC8).withValues(alpha: 0.5),
                  disabledForegroundColor: const Color(0xFF795548).withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Remove BG Button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isCropping ? null : _removeBackground,
                icon: const Icon(Icons.auto_fix_high, size: 20),
                label: const Text(
                  'Remove BG',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 0.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF795548),
                  foregroundColor: const Color(0xFFFFFFFF),
                  disabledBackgroundColor: const Color(0xFF795548).withValues(alpha: 0.5),
                  disabledForegroundColor: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Helper Text
        Text(
          'Drag corners to adjust crop area',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w200,
            color: const Color(0xFF795548).withValues(alpha: 0.7),
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildRemoveBgControls() {
    return Column(
      children: [
        // Eraser Size Label and Value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Eraser Size',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: const Color(0xFF795548).withValues(alpha: 0.8),
                letterSpacing: 0.2,
              ),
            ),
            Text(
              '${_eraserSize.round()}px',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w200,
                color: const Color(0xFF795548).withValues(alpha: 0.8),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Slider
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            activeTrackColor: const Color(0xFF795548),
            inactiveTrackColor: const Color(0xFFD7CCC8),
            thumbColor: const Color(0xFF795548),
            overlayColor: const Color(0xFF795548).withValues(alpha: 0.2),
          ),
          child: Slider(
            value: _eraserSize,
            min: 10,
            max: 100,
            onChanged: (value) {
              setState(() {
                _eraserSize = value;
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        // Instruction Text
        Text(
          'Tap to remove background automatically',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            fontWeight: FontWeight.w200,
            color: const Color(0xFF795548).withValues(alpha: 0.7),
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}