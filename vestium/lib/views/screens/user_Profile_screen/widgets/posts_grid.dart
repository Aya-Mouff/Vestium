import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';
import '../../../../databases/db_models.dart';

class PostsGrid extends StatelessWidget {
  final List<PostModel> posts;
  final int profileUserId;
  final int currentUserId;

  const PostsGrid({
    super.key,
    required this.posts,
    required this.profileUserId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Text('No posts yet', style: TextStyle(color: Colors.grey.shade600)),
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
      ),
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: () {
            context.router.push(
              PostsDetailsRoute(
                postId: post.postId!,
                userId: profileUserId,
                currentUserId: currentUserId,
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(post.imagePath!, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
