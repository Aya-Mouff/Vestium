import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';

class PostHeader extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.router.push(UserProfileRoute(
                userId: post['userId'].toString(),
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
              context.router.push(UserProfileRoute(
                userId: post['userId'].toString(),
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
