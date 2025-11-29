import 'package:flutter/material.dart';
import 'post_card.dart';

class PostsList extends StatelessWidget {
  final List<Map<String, dynamic>> posts;
  final int initialIndex;
  final int currentUserId;

  const PostsList({
    super.key,
    required this.posts,
    required this.initialIndex,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final position = initialIndex * 450.0;
      controller.jumpTo(position);
    });

    return ListView.builder(
      controller: controller,
      itemCount: posts.length,
      itemBuilder: (context, index) =>
          PostCard(post: posts[index], postIndex: index, currentUserId: currentUserId, userId: posts[index]['userId']),
    );
  }
}
