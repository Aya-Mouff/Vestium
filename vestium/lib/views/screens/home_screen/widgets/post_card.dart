import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';
import 'post_header.dart';
import 'post_actions.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;

  const PostCard({super.key, required this.post});

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
          PostHeader(post: post),

          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.asset(
              post['imageUrl'],
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),

          PostActions(post: post),
        ],
      ),
    );
  }
}
