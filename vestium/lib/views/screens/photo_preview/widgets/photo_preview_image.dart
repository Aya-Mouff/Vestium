import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';

class PhotoPreviewImage extends StatelessWidget {
  final String imagePath;

  const PhotoPreviewImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              final loc = AppLocalizations.of(context)!;
              return Container(
                color: const Color(0xFFD7CCC8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: const Color(0xFF795548).withValues(alpha: .6)),
                      const SizedBox(height: 16),
                      Text(
                        loc.photoPreviewLoadError,
                        style: const TextStyle(fontFamily: 'Inter', fontSize: 15, color: Color(0xFF795548)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
