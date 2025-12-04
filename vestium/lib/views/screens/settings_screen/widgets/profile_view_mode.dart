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
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF795548),
              image: profileImage != null && profileImage!.isNotEmpty
                  ? DecorationImage(
                      image: AssetImage(profileImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profileImage == null || profileImage!.isEmpty
                ? Center(
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
                  )
                : null,
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
}
