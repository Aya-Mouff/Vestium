import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final bool isLiked;
  final VoidCallback onLikePressed;
  final VoidCallback onCommentPressed;
  final VoidCallback onDeletePressed;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onLikePressed,
    required this.onCommentPressed,
    required this.onDeletePressed,
  });

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
          _buildUserHeader(),
          _buildPostImage(),
          _buildPostDetails(context),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage(post['profileImage']),
          ),
          const SizedBox(width: 12),
          Text(
            post['username'],
            style: const TextStyle(
              fontFamily: 'CormorantGaramond',
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
      ),
      child: Image.asset(
        post['imageUrl'],
        width: double.infinity,
        height: 400,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildPostDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionButtons(context, int.parse(post['userId'].toString())),
          const SizedBox(height: 8),
          _buildLikesCount(),
          const SizedBox(height: 4),
          _buildCaption(),
          const SizedBox(height: 8),
          _buildCommentsCount(),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, int userId) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            size: 24,
            color: isLiked ? Colors.red : Colors.black87,
          ),
          onPressed: onLikePressed,
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.mode_comment_outlined, size: 24),
          onPressed: (){
            context.router.push(CommentsRoute(
              postId: int.parse(post['id'].toString()),
              userId: userId,
              ));
          },
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 24, color: Colors.red),
          onPressed: onDeletePressed,
        ),
      ],
    );
  }

  Widget _buildLikesCount() {
    return Text(
      '${post['likesCount']} likes',
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
    );
  }

  Widget _buildCaption() {
    return RichText(
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
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsCount() {
    return Text(
      'View all ${post['commentsCount']} comments',
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        color: Colors.grey.shade600,
      ),
    );
  }
}