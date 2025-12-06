// post_header.dart
import 'dart:io';
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
              backgroundImage: _getProfileImage(post['profileImage']),
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

  ImageProvider _getProfileImage(String imagePath) {
    // Check if it's a file path
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    }
    final file = File(imagePath);
      if (file.existsSync()) {
        return FileImage(file);
      }else{
        return const AssetImage('assets/images/icons/person.jpg');
      }
    
  }
}