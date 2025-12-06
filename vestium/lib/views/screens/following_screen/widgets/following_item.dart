import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';

class FollowingItem extends StatelessWidget {
  final String name;
  final String username;
  final String profileImage;
  final bool isFollowing;
  final VoidCallback onFollowTap;
  final int personUserId; // The ID of the person in the list
  final int currentUserId; // The ID of the current logged-in user

  const FollowingItem({
    super.key,
    required this.name,
    required this.username,
    required this.profileImage,
    required this.isFollowing,
    required this.onFollowTap,
    required this.personUserId,
    required this.currentUserId,
  });

  void _navigateToProfile(BuildContext context) {
    if (personUserId == currentUserId) {
      // Navigate to MyProfileScreen for current user
      context.router.push(
        MyProfileRoute(
          userId: currentUserId,
        ),
      );
    } else {
      // Navigate to UserProfileScreen for other users
      context.router.push(
        UserProfileRoute(
          userId: personUserId,
          currentUserId: currentUserId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = personUserId == currentUserId;

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
          // Profile Image - Make it clickable
          GestureDetector(
            onTap: () => _navigateToProfile(context),
            child: CircleAvatar(
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
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Name - Make it clickable
                GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C2C2C),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Username - Make it clickable
                GestureDetector(
                  onTap: () => _navigateToProfile(context),
                  child: Text(
                    '@$username',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Only show follow button if it's not the current user
          if (!isCurrentUser)
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