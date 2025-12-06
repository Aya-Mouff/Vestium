// post_actions.dart - Fixed version
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
  final int postId;

  const PostActions({
    super.key,
    required this.post,
    required this.userId,
    required this.currentUserId,
    required this.postId,
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
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  final isLiked = post['isLiked'] as bool;
                  
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
                      // Fixed: using toggleLike method
                      context.read<HomeCubit>().toggleLike(postId, currentUserId);
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
                      postId: postId,
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
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final likesCount = post['likesCount'] as int;
              
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
                      color: Colors.black),
                ),
              ],
            ),
          )
          : const SizedBox.shrink(),

          const SizedBox(height: 8),

          // Comments count
          GestureDetector(
            onTap: () {
              context.router.push(
                CommentsRoute(
                  postId: postId,
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