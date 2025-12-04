import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';
class PostHeader extends StatelessWidget {
  final Map<String, dynamic> post;
  final int userId;
  final int currentUserId;

  const PostHeader({super.key, required this.post, required this.userId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              userId == currentUserId
                  ? context.router.push(MyProfileRoute(
                      userId: currentUserId,
                    ))
                  : context.router.push(UserProfileRoute(
                    userId: userId,
                    currentUserId: currentUserId,
                  ));
            },
            child: CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(post['profileImage']),
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: () {

              userId == currentUserId
                  ? context.router.push(MyProfileRoute(
                      userId: currentUserId,
                    ))
                  : context.router.push(UserProfileRoute(
                    userId: userId,
                    currentUserId: currentUserId,
                  ));
            },
            child: Text(
              post['username'],
              style: const TextStyle(
                fontFamily: 'CormorantGaramond',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
