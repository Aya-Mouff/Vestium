import 'package:flutter/material.dart';

class FollowerItem extends StatelessWidget {
  final String name;
  final String username;
  final String profileImage;
  final bool isFollowing;
  final VoidCallback onFollowTap;

  const FollowerItem({
    super.key,
    required this.name,
    required this.username,
    required this.profileImage,
    required this.isFollowing,
    required this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 381.26,
      height: 74.13,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF795548),
            backgroundImage:
                profileImage.isNotEmpty ? AssetImage(profileImage) : null,
            child: profileImage.isEmpty
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@$username',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF795548),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onFollowTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: isFollowing ? 95.83 : 73.34,
              height: 35.99,
              decoration: BoxDecoration(
                color: isFollowing ? Colors.transparent : const Color(0xFF795548),
                border: Border.all(
                  color: const Color(0xFF795548),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  isFollowing ? 'Following' : 'Follow',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isFollowing
                        ? const Color(0xFF795548)
                        : Colors.white,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
