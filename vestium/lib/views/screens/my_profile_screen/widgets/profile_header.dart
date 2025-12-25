import 'package:flutter/material.dart';
import 'package:vestium/l10n/app_localizations.dart';
import 'dart:io';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> currentUser;
  const ProfileHeader({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final fullName = currentUser['fullName'] as String? ?? loc.myProfileUnknownUser;
    final bio = currentUser['bio'] as String? ?? loc.myProfileNoBio;
    final profileImage = currentUser['pfp'] as String? ?? 'assets/images/icons/person.jpg';

    return Column(
      children: [
        _buildProfileImage(profileImage),
        const SizedBox(height: 12),
        Text(
          fullName,
          style: const TextStyle(fontFamily: 'CormorantGaramond', fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          bio,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildProfileImage(String imagePath) {
    // Determine the type of image and create appropriate widget
    if (imagePath.startsWith('assets/')) {
      // Asset image
      return CircleAvatar(
        radius: 40,
        backgroundImage: AssetImage(imagePath),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback to default person icon if asset doesn't exist
        },
      );
    } else {
      // File from device storage
      return CircleAvatar(
        radius: 40,
        backgroundImage: FileImage(File(imagePath)),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback to default person icon if file doesn't exist
        },
      );
    }
  }
}
