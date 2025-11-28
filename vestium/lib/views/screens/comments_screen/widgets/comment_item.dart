import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;
  final Map<int, dynamic> usersMap;

  const CommentItem({
    super.key,
    required this.comment,
    required this.usersMap,
  });

  String getTimeAgo(String createdAt) {
    final dateTime = DateTime.parse(createdAt);
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final int uid = comment['userId'];
    final user = usersMap[uid];

    final username = user?['username'] ?? 'unknown';
    final profileImage = user?['profileImage'] ?? 'assets/images/dummyData/profile-pic-women.jpg';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.router.push(UserProfileRoute(userId: uid)),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(profileImage),
            ),
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
                        onTap: () => context.router.push(UserProfileRoute(userId: uid)),
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
                        comment['text'],
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
                  getTimeAgo(comment['createdAt']),
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
