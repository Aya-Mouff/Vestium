import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';

class PostActions extends StatelessWidget {
  final Map<String, dynamic> post;
  final int? userId;

  const PostActions({super.key, required this.post, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: const Icon(Icons.mode_comment_outlined),
                onPressed: () {
                  context.router.push(
                    CommentsRoute(postId: int.parse(post['id']), userId: userId!),
          );
                },
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            '${post['likesCount']} likes',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${post['username']} ',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: post['caption'],
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          GestureDetector(
            onTap: () {
              context.router.pushNamed('/comments/${post['id']}');
            },
            child: Text(
              "View all ${post['commentsCount']} comments",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
