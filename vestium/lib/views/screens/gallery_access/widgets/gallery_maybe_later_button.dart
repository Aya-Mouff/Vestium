import 'package:flutter/material.dart';

class GalleryMaybeLaterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const GalleryMaybeLaterButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF795548),
        disabledForegroundColor: const Color(0xFF795548).withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: const Text(
        'Maybe Later',
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}