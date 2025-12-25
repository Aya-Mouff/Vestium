import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import 'cubit/posts_details_screen_cubit.dart';
import 'widgets/posts_list.dart';
import '../../widgets/nav_bar.dart';
import 'cubit/posts_details_screen_state.dart';

@RoutePage()
class PostsDetailsScreen extends StatelessWidget {
  final int userId;
  final int currentUserId;
  final int postId;

  const PostsDetailsScreen({super.key, required this.userId, required this.currentUserId, required this.postId});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => PostsDetailsCubit()..loadPosts(userId: userId, postId: postId, currentUserId: currentUserId),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            loc.postsDetailsTitle,
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: _PostsListView(userId: userId, postId: postId, currentUserId: currentUserId),
        bottomNavigationBar: CustomNavBar(currentPage: 'home', userId: currentUserId),
      ),
    );
  }
}

// A separate widget that handles loading posts once
class _PostsListView extends StatelessWidget {
  final int userId;
  final int postId;
  final int currentUserId;

  const _PostsListView({required this.userId, required this.postId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostsDetailsCubit, PostsDetailsState>(
      buildWhen: (previous, current) => previous is! PostsDetailsLoaded && current is PostsDetailsLoaded,
      builder: (context, state) {
        if (state is PostsDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostsDetailsLoaded) {
          return PostsList(posts: state.posts, initialIndex: state.initialIndex, currentUserId: currentUserId);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
