import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';
import 'dart:io';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;
  final Map<int, dynamic> usersMap;
  final int currentUserId;

  const CommentItem({
    super.key,
    required this.comment,
    required this.usersMap,
    required this.currentUserId,
  });

  String getTimeAgo(String createdAt) {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final diff = now.difference(dateTime);

      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (e) {
      return 'Recently';
    }
  }

  Widget _buildProfileImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: AssetImage(imagePath),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback handled by CircleAvatar child
        },
      );
    } else {
      return CircleAvatar(
        radius: 20,
        backgroundImage: FileImage(File(imagePath)),
        onBackgroundImageError: (exception, stackTrace) {
          // Fallback handled by CircleAvatar child
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int uid = comment['userId'] ?? 0;
    final user = usersMap[uid];

    final username = user?['username'] ?? 'unknown';
    final profileImage = user?['profileImage'] ?? 'assets/images/icons/person.jpg';
    final commentText = comment['text'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.router.push(UserProfileRoute(userId: uid, currentUserId: currentUserId)),
            child: _buildProfileImage(profileImage),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => context.router.push(UserProfileRoute(userId: uid, currentUserId: currentUserId)),
                        child: Text(
                          username,
                          style: const TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        commentText,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  getTimeAgo(comment['createdAt'] ?? DateTime.now().toIso8601String()),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}