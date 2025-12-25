import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import 'cubit/my_posts_screen_cubit.dart';
import 'cubit/my_posts_screen_state.dart';
import 'widgets/post_card.dart';
import 'widgets/delete_post_dialog.dart';
import '../../widgets/nav_bar.dart';

@RoutePage()
class MyPostsScreen extends StatelessWidget {
  final String postId;

  const MyPostsScreen({super.key, @PathParam('postId') required this.postId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyPostsScreenCubit()..loadUserPosts(postId),
      child: const _MyPostsScreenContent(),
    );
  }
}

class _MyPostsScreenContent extends StatefulWidget {
  const _MyPostsScreenContent();

  @override
  State<_MyPostsScreenContent> createState() => _MyPostsScreenContentState();
}

class _MyPostsScreenContentState extends State<_MyPostsScreenContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5ECE7),
      extendBody: true,
      appBar: _buildAppBar(),
      body: BlocConsumer<MyPostsScreenCubit, MyPostsScreenState>(listener: _stateListener, builder: _stateBuilder),
      bottomNavigationBar: const CustomNavBar(currentPage: 'profile', userId: 1),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final loc = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => context.router.pop(),
      ),
      title: Text(
        loc.myPostsTitle,
        style: const TextStyle(
          fontFamily: 'CormorantGaramond',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      centerTitle: true,
    );
  }

  void _stateListener(BuildContext context, MyPostsScreenState state) {
    final cubit = context.read<MyPostsScreenCubit>();

    if (state is MyPostsLoaded) {
      if (cubit.shouldScrollToFocusedPost()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(cubit.calculateScrollPosition());
          }
        });
      }
    }

    if (state is MyPostsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red, duration: const Duration(seconds: 2)),
      );
    }

    if (state is MyPostsDeleted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.message), duration: const Duration(seconds: 2)));
      // Navigate back after all posts deleted
      Future.delayed(const Duration(seconds: 2), () {
        if (context.mounted) {
          context.router.pop();
        }
      });
    }
  }

  Widget _stateBuilder(BuildContext context, MyPostsScreenState state) {
    if (state is MyPostsLoading) {
      return _buildLoadingState();
    }

    if (state is MyPostsError) {
      return _buildErrorState(state.message);
    }

    if (state is MyPostsLoaded) {
      return _buildLoadedState(context, state);
    }

    if (state is MyPostsDeleted) {
      return _buildDeletedState();
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildDeletedState() {
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            loc.myPostsAllDeleted,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Inter', fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(BuildContext context, MyPostsLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.posts.length,
      itemBuilder: (context, index) {
        final post = state.posts[index];
        final postId = post['id'] as String;
        final isLiked = state.isPostLiked(postId);
        final cubit = context.read<MyPostsScreenCubit>();

        return PostCard(
          post: post,
          isLiked: isLiked,
          onLikePressed: () => cubit.toggleLike(postId),
          onDeletePressed: () => _showDeleteDialog(context, postId, cubit),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String postId, MyPostsScreenCubit cubit) {
    DeletePostDialog.show(
      context,
      onDeletePressed: () {
        Navigator.of(context).pop();
        cubit.deletePost(postId);
      },
      onCancelPressed: () => Navigator.of(context).pop(),
    );
  }
}
