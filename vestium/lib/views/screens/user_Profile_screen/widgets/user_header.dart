import 'package:flutter/material.dart';
import 'dart:io';
import '../../../../databases/db_models.dart';

class UserHeader extends StatelessWidget {
  final User user; // Changed from Map<String, dynamic> to User

  const UserHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfileImage(user.pfp ?? 'assets/images/icons/person.jpg'),
        const SizedBox(height: 12),
        Text(
          user.fullName ?? '',
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          user.bio ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildProfileImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      // Asset image
      return CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage(imagePath),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback to default if asset doesn't exist
        },
      );
    } else {
      // File from device storage
      return CircleAvatar(
        radius: 40,
        backgroundImage: FileImage(File(imagePath)),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback to default if file doesn't exist
        },
      );
    }
  }
}