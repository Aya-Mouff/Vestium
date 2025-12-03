import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> currentUser;
  const ProfileHeader({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    // Safely extract fields with null coalescing
    final profileImage =
        currentUser['pfp'] as String? ?? 'assets/images/logos/logo.png';
    final fullName = currentUser['fullName'] as String? ?? 'Unknown User';
    final bio = currentUser['bio'] as String? ?? 'No bio';

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(profileImage),
          onBackgroundImageError: (exception, stackTrace) {
            // Fallback if image not found
          },
        ),
        const SizedBox(height: 12),
        Text(
          fullName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
}
