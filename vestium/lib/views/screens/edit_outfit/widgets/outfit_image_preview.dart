import 'package:flutter/material.dart';

class OutfitImagePreview extends StatelessWidget {
  final String imageUrl;

  const OutfitImagePreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF795548).withValues(alpha: .15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFD7CCC8),
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 64,
                  color: Color(0xFF795548),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}