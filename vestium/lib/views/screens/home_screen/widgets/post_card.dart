// post_card.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'post_header.dart';
import 'post_actions.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final int? userId;
  final int currentUserId;

  const PostCard({super.key, required this.post, required this.userId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(post: post, userId: userId!, currentUserId: currentUserId),

          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: _buildPostImage(post['imageUrl']),
          ),

          PostActions(
            post: post, 
            userId: userId, 
            currentUserId: currentUserId, 
            postId: post['id']
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage(String imageUrl) {
    // Check if it's a file path
    if (imageUrl.startsWith('/') || imageUrl.contains('.')) {
      final file = File(imageUrl);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: double.infinity,
          height: 400,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/images/default_post.png',
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            );
          },
        );
      }
    }
    
    // Otherwise treat it as an asset
    return Image.asset(
      imageUrl,
      width: double.infinity,
      height: 400,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/default_post.png',
          width: double.infinity,
          height: 400,
          fit: BoxFit.cover,
        );
      },
    );
  }
}