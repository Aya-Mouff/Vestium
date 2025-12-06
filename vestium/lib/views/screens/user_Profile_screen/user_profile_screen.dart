import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/user_profile_screen_cubit.dart';
import 'cubit/user_profile_screen_state.dart';
import '../../../../repo/user_repo.dart';
import '../../../../repo/post_repo.dart';
import '../../../../repo/follow_repo.dart';
import 'widgets/user_header.dart';
import 'widgets/user_stats.dart';
import 'widgets/posts_grid.dart';
import '../../widgets/nav_bar.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class UserProfileScreen extends StatelessWidget {
  final int userId;
  final int currentUserId;

  const UserProfileScreen({
    super.key,
    required this.userId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProfileCubit(
        userRepo: UserRepo(),
        postRepo: PostRepo(),
        followRepo: FollowRepo(),
        currentUserId: currentUserId,
      )..loadProfile(userId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          title: BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoaded) {
                return Text(
                  state.user.username ?? 'User',
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                );
              }
              return const Text("");
            },
          ),
        ),
        body: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<UserProfileCubit>().loadProfile(userId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is UserProfileLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<UserProfileCubit>().loadProfile(userId);
                },
                color: const Color(0xFF795548),
                backgroundColor: const Color(0xFFF5ECE7),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      UserHeader(user: state.user),
                      const SizedBox(height: 16),
                      UserStats(
                        posts: state.posts.length,
                        followers: state.followersCount, 
                        following: state.followingCount,
                        userId: userId,
                        currentUserId: currentUserId,
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: SizedBox(
                          width: double.infinity, 
                          child: ElevatedButton(
                            onPressed: () => context
                                .read<UserProfileCubit>()
                                .toggleFollow(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: state.isFollowing
                                  ? Colors.white
                                  : const Color(0xFF795548),
                              side: state.isFollowing
                                  ? const BorderSide(color: Colors.grey)
                                  : BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              minimumSize: const Size(double.infinity, 40),
                            ),
                            child: Text(
                              state.isFollowing ? "Following" : "Follow",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: state.isFollowing ? Colors.black87 : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: PostsGrid(
                          posts: state.posts,
                          profileUserId: userId,
                          currentUserId: currentUserId,
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: CustomNavBar(
          currentPage: 'home',
          userId: currentUserId,
        ),
      ),
    );
  }
}