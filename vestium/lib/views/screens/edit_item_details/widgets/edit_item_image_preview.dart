// lib/edit_item_details_screen/widgets/edit_item_image_preview.dart
import 'dart:io';
import 'package:flutter/material.dart';

class EditItemImagePreview extends StatelessWidget {
  final String? imagePath;

  const EditItemImagePreview({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 340,
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
        child: imagePath != null && imagePath!.isNotEmpty
            ? FutureBuilder<bool>(
                future: _checkIfFileExists(imagePath!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: const Color(0xFFF5ECE7),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF795548),
                        ),
                      ),
                    );
                  }
                  
                  if (snapshot.hasError || !(snapshot.data ?? false)) {
                    return _buildPlaceholder();
                  }
                  
                  return Image.file(
                    File(imagePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholder();
                    },
                  );
                },
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Future<bool> _checkIfFileExists(String path) async {
    try {
      final file = File(path);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: const Color(0xFFF5ECE7),
      child: const Center(
        child: Icon(
          Icons.photo,
          size: 48,
          color: Color(0xFF795548),
        ),
      ),
    );
  }
}