import 'package:flutter/material.dart';

class FollowingItem extends StatelessWidget {
  final String name;
  final String username;
  final String profileImage;
  final bool isFollowing;
  final VoidCallback onFollowTap;
  final int personUserId; // Changed from userId to personUserId
  final int currentUserId;

  const FollowingItem({
    super.key,
    required this.name,
    required this.username,
    required this.profileImage,
    required this.isFollowing,
    required this.onFollowTap,
    required this.personUserId, // Changed parameter name
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 381.26,
      height: 80.13,
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
            backgroundColor: const Color(0xFF8B6F5E),
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
                    color: Color(0xFF2C2C2C),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@$username',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          // Check if the current user is viewing their own profile OR if the person is themselves
          if (personUserId != currentUserId) // Changed to personUserId
            InkWell(
              onTap: onFollowTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: isFollowing ? 95.83 : 73.34,
                height: 35.99,
                decoration: BoxDecoration(
                  color:
                      isFollowing ? Colors.transparent : const Color(0xFF8B6F5E),
                  border: Border.all(
                    color: isFollowing
                        ? Colors.grey[300]!
                        : const Color(0xFF8B6F5E),
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
                      color: isFollowing ? Colors.grey[700] : Colors.white,
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