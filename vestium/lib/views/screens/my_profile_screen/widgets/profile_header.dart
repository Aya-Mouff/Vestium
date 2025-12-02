import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> currentUser;
  const ProfileHeader({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(radius: 40, backgroundImage: AssetImage(currentUser['profileImage'])),
        const SizedBox(height: 12),
        Text(currentUser['fullName'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(currentUser['bio'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 8),
      ],
    );
  }
}
