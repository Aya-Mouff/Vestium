import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          // User info header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    context.router.push(UserProfileRoute(
                        userId: int.parse(post['userId'].toString()),
                        currentUserId: currentUserId,
                    ));
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(post['profileImage']),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    context.router.push(UserProfileRoute(
                        userId: int.parse(post['userId'].toString()),
                        currentUserId: currentUserId,
                    ));
                  },
                  child: Text(
                    post['username'],
                    style: const TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Post image
          ClipRRect(
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
                        return IconButton(
                          icon: isLiked
                              ? const Icon(Icons.favorite, size: 24, color: Colors.red)
                              : const Icon(Icons.favorite_border, size: 24),
                          onPressed: () {
                            if (currentUserId == -1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('You must be logged in to like posts!'),
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
                        context.router.push(CommentsRoute(
                          postId: int.parse(post['id'].toString()),
                          userId: currentUserId,
                        ));
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
                    return Text('$likesCount likes',
                        style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 13));
                  },
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
                              color: Colors.black)),
                      TextSpan(
                          text: post['caption'],
                          style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.black)),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Text('View all ${post['commentsCount']} comments',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
