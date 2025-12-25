import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/l10n/app_localizations.dart';
import '../../../../databases/services/user_profile_service.dart';
import '../../../../app_router.dart'; // Added for navigation
import 'dart:io';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final bool isLiked;
  final VoidCallback onLikePressed;
  final VoidCallback onDeletePressed;

  const PostCard({
    super.key,
    required this.post,
    required this.isLiked,
    required this.onLikePressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    // Use ValueKey to help Flutter identify this widget
    return Container(
      key: ValueKey('post_${post['id']}'),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), spreadRadius: 2, blurRadius: 5, offset: const Offset(3, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildUserHeader(), _buildPostImage(context), _buildPostDetails(context)],
      ),
    );
  }

  Widget _buildUserHeader() {
    return FutureBuilder<String?>(
      future: UserProfileService.getUserProfileImagePath(int.parse(post['userId'].toString())),
      builder: (context, snapshot) {
        final loc = AppLocalizations.of(context)!;
        String profileImagePath = snapshot.data ?? 'assets/images/icons/person.jpg';
        bool isAsset = profileImagePath.startsWith('assets/');

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: isAsset
                    ? AssetImage(profileImagePath) as ImageProvider
                    : FileImage(File(profileImagePath)),
              ),
              const SizedBox(width: 12),
              Text(
                post['username'] ?? loc.myPostsDefaultUser,
                style: const TextStyle(fontFamily: 'CormorantGaramond', fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostImage(BuildContext context) {
    final imagePath = post['imageUrl'] ?? 'assets/default_post.png';
    final isAsset = imagePath.startsWith('assets/');

    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
      child: isAsset
          ? Image.asset(imagePath, width: double.infinity, height: 400, fit: BoxFit.cover)
          : Image.file(File(imagePath), width: double.infinity, height: 400, fit: BoxFit.cover),
    );
  }

  Widget _buildPostDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionButtons(context),
          const SizedBox(height: 8),
          _buildLikesCount(),
          const SizedBox(height: 4),
          post['caption'] != null && post['caption'].toString().isNotEmpty ? _buildCaption() : const SizedBox.shrink(),
          const SizedBox(height: 8),
          _buildCommentsCount(context),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Like button with immediate visual feedback
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
          onPressed: () => _navigateToComments(context),
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
    return Builder(
      builder: (context) {
        final loc = AppLocalizations.of(context)!;
        return Text(
          loc.myPostsLikesCount(post['likesCount'] ?? 0),
          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 13),
        );
      },
    );
  }

  Widget _buildCaption() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: post['caption'] ?? '',
            style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w400, fontSize: 13, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsCount(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final commentsCount = post['commentsCount'] ?? 0;

    return GestureDetector(
      onTap: () => _navigateToComments(context),
      child: Text(
        loc.myPostsViewComments(commentsCount),
        style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.grey.shade600),
      ),
    );
  }

  void _navigateToComments(BuildContext context) {
    final postId = post['postId'] ?? int.tryParse(post['id'].toString());
    final userId = post['userId'];

    if (postId != null && userId != null) {
      context.router.push(
        CommentsRoute(
          postId: postId is int ? postId : int.parse(postId.toString()),
          userId: userId is int ? userId : int.parse(userId.toString()),
        ),
      );
    }
  }
}
