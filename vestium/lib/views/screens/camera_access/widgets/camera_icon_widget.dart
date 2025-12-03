import 'package:flutter/material.dart';

class CameraIconWidget extends StatelessWidget {
  const CameraIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF795548).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.camera_alt_outlined,
          size: 56,
          color: const Color(0xFF795548),
        ),
      ),
    );
  }
}