import 'dart:io';
import 'package:flutter/material.dart';

class ProfileViewMode extends StatelessWidget {
  final String displayName;
  final String displayUsername;
  final String? profileImage;
  final VoidCallback onEdit;

  const ProfileViewMode({
    super.key,
    required this.displayName,
    required this.displayUsername,
    this.profileImage,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF795548),
              ),
              child: profileImage != null && profileImage!.isNotEmpty
                  ? Image(
                      image: _getImageProvider(profileImage!),
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            displayName.isNotEmpty
                                ? displayName[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        displayName.isNotEmpty
                            ? displayName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3E2723),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@$displayUsername',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF795548),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF795548),
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider _getImageProvider(String path) {
    // Check if it's a file path
    if (File(path).existsSync()) {
      return FileImage(File(path));
    }
    // Check if it starts with common file path indicators
    if (path.startsWith('/') || 
        path.contains('data/user') || 
        path.contains('storage/emulated') ||
        path.contains('cache')) {
      return FileImage(File(path));
    }
    // Otherwise treat as asset
    return AssetImage(path);
  }
}