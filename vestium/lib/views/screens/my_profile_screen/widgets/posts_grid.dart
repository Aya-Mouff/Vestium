import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';
import 'dart:io';

class PostsGrid extends StatelessWidget {
  final List<dynamic> posts;
  const PostsGrid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No posts yet',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final post = posts[index];
        final imagePath = post['imageUrl'];
        
        return GestureDetector(
          onTap: () => context.pushRoute(MyPostsRoute(postId: post['id'])),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildPostImage(imagePath),
          ),
        );
      },
    );
  }

  Widget _buildPostImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFE9D9CF),
            child: const Center(
              child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 40),
            ),
          );
        },
      );
    } else {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFFE9D9CF),
            child: const Center(
              child: Icon(Icons.photo, color: Color(0xFF7B5247), size: 40),
            ),
          );
        },
      );
    }
  }
}