import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/app_router.dart';

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
        return GestureDetector(
          onTap: () => context.pushRoute(MyPostsRoute(postId:post['id'])),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              post['imageUrl'],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
