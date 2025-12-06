import 'dart:io';
import 'package:flutter/material.dart';

class ProfileEditMode extends StatelessWidget {
  final String? profileImage;
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController bioController;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final VoidCallback onImagePick;

  const ProfileEditMode({
    super.key,
    this.profileImage,
    required this.nameController,
    required this.usernameController,
    required this.bioController,
    required this.onCancel,
    required this.onSave,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Stack(
            children: [
              ClipOval(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF795548),
                  ),
                  child: profileImage != null && profileImage!.isNotEmpty
                      ? Image(
                          image: _getImageProvider(profileImage!),
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onImagePick,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF795548),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildField('Name', nameController, 'My Name'),
          const SizedBox(height: 16),
          _buildField('Username', usernameController, 'my_username'),
          const SizedBox(height: 16),
          _buildField(
            'Bio',
            bioController,
            'Fashion enthusiast ✨ | Style inspiration',
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onCancel,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF795548),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF795548),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
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

  Widget _buildField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF3E2723),
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF3E2723),
            fontFamily: 'Inter',
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF795548),
              fontFamily: 'Inter',
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}