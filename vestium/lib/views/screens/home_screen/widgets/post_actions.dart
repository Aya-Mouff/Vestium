import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_screen_cubit.dart';
import '../cubit/home_screen_state.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../app_router.dart';

class PostActions extends StatelessWidget {
  final Map<String, dynamic> post;
  final int? userId;
  final int currentUserId;
  final int postIndex;

  const PostActions({
    super.key,
    required this.post,
    required this.userId,
    required this.currentUserId,
    required this.postIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Like button
              BlocSelector<HomeCubit, HomeState, bool>(
                selector: (state) {
                  if (state is HomeLoaded) {
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
                      context.read<HomeCubit>().toggleLike(postIndex, currentUserId);
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  );
                },
              ),
              const SizedBox(width: 8),

              // Comment button
              IconButton(
                icon: const Icon(Icons.mode_comment_outlined, size: 24),
                onPressed: () {
                  context.router.push(
                    CommentsRoute(
                      postId: post['id'], // already int
                      userId: currentUserId,
                    ),
                  );
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Likes count
          BlocSelector<HomeCubit, HomeState, int>(
            selector: (state) {
              if (state is HomeLoaded) {
                return state.posts[postIndex]['likesCount'] as int;
              }
              return post['likesCount'] as int;
            },
            builder: (context, likesCount) {
              return Text(
                '$likesCount likes',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              );
            },
          ),

          const SizedBox(height: 4),

          // Caption
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${post['username']} ',
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black),
                ),
                TextSpan(
                  text: post['caption'],
                  style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.black),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Comments count
          GestureDetector(
            onTap: () {
              context.router.push(
                CommentsRoute(
                  postId: post['id'], // already int
                  userId: currentUserId,
                ),
              );
            },
            child: Text(
              "View all ${post['commentsCount']} comments",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
