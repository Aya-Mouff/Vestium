import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import 'dart:io';
import '../../../../app_router.dart';
import '../cubit/posts_details_screen_cubit.dart';
import '../cubit/posts_details_screen_state.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final int postIndex;
  final int userId;
  final int currentUserId;

  const PostCard({
    super.key,
    required this.post,
    required this.postIndex,
    required this.userId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          // User info header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.router.push(
                      UserProfileRoute(userId: int.parse(post['userId'].toString()), currentUserId: currentUserId),
                    );
                  },
                  child: CircleAvatar(radius: 18, backgroundImage: _getProfileImage(post['profileImage'])),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    context.router.push(
                      UserProfileRoute(userId: int.parse(post['userId'].toString()), currentUserId: currentUserId),
                    );
                  },
                  child: Text(
                    post['username'],
                    style: const TextStyle(fontFamily: 'CormorantGaramond', fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          // Post image
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
            child: _buildPostImage(post['imageUrl']),
          ),

          // Action buttons and stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heart and comment buttons
                Row(
                  children: [
                    // BlocSelector only listens to this post's likes
                    BlocSelector<PostsDetailsCubit, PostsDetailsState, bool>(
                      selector: (state) {
                        if (state is PostsDetailsLoaded) {
                          final postData = state.posts[postIndex];
                          final likedBy = List<int>.from(postData['likedBy'] ?? []);
                          return likedBy.contains(currentUserId);
                        }
                        return false;
                      },
                      builder: (context, isLiked) {
                        final loc = AppLocalizations.of(context)!;
                        return IconButton(
                          icon: isLiked
                              ? const Icon(Icons.favorite, size: 24, color: Colors.red)
                              : const Icon(Icons.favorite_border, size: 24),
                          onPressed: () {
                            if (currentUserId == -1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(loc.postsDetailsMustLoginToLike),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }
                            context.read<PostsDetailsCubit>().toggleLike(postIndex, currentUserId);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        );
                      },
                    ),

                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.mode_comment_outlined, size: 24),
                      onPressed: () {
                        context.router.push(
                          CommentsRoute(postId: int.parse(post['id'].toString()), userId: currentUserId),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Likes count
                BlocSelector<PostsDetailsCubit, PostsDetailsState, int>(
                  selector: (state) {
                    if (state is PostsDetailsLoaded) {
                      return state.posts[postIndex]['likesCount'] as int;
                    }
                    return post['likesCount'] as int;
                  },
                  builder: (context, likesCount) {
                    final loc = AppLocalizations.of(context)!;
                    return Text(
                      loc.postsDetailsLikesCount(likesCount),
                      style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 13),
                    );
                  },
                ),

                const SizedBox(height: 4),
                post['caption'] != ''
                    ? RichText(
                        text: TextSpan(
                          children: [
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
                      )
                    : const SizedBox.shrink(),

                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    context.router.push(CommentsRoute(postId: int.parse(post['id'].toString()), userId: currentUserId));
                  },
                  child: Builder(
                    builder: (context) {
                      final loc = AppLocalizations.of(context)!;
                      return Text(
                        loc.postsDetailsViewAllComments(post['commentsCount']),
                        style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: Colors.grey.shade600),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create profile image
  ImageProvider _getProfileImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      // Asset image
      return AssetImage(imagePath);
    } else {
      // File system image
      final file = File(imagePath);
      if (file.existsSync()) {
        return FileImage(file);
      } else {
        // Fallback to default asset if file doesn't exist
        return const AssetImage('assets/images/icons/person.jpg');
      }
    }
  }

  // Helper method to build post image widget
  Widget _buildPostImage(String imageUrl) {
    if (imageUrl.startsWith('assets/')) {
      // Asset image
      return Image.asset(
        imageUrl,
        width: double.infinity,
        height: 400,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 400,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
          );
        },
      );
    } else {
      // File system image
      return FutureBuilder<bool>(
        future: File(imageUrl).exists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: double.infinity,
              height: 400,
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            return Image.file(
              File(imageUrl),
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                );
              },
            );
          } else {
            // File doesn't exist, show default
            final loc = AppLocalizations.of(context)!;
            return Container(
              width: double.infinity,
              height: 400,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(loc.postsDetailsImageNotFound, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            );
          }
        },
      );
    }
  }
}
