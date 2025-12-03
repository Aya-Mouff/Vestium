import 'package:flutter/material.dart';

class GalleryIconWidget extends StatelessWidget {
  const GalleryIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF795548).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: const Color(0xFF3E2723),
        ),
      ),
    );
  }
}