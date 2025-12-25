// home_screen.dart - Fixed version with working pull-to-refresh
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/l10n/app_localizations.dart';
import 'cubit/home_screen_cubit.dart';
import 'cubit/home_screen_state.dart';
import '../../widgets/nav_bar.dart';
import 'widgets/post_card.dart';
import '../../../app_router.dart';
import '../../../databases/services/current_user_service.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  final int? userId;

  const HomeScreen({super.key, @PathParam('userId') required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showNewPostsIndicator = false;
  late HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = HomeCubit();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    // Show new posts indicator when scrolling down
    if (_scrollController.offset > 100) {
      if (mounted && !_showNewPostsIndicator) {
        setState(() {
          _showNewPostsIndicator = true;
        });
      }
    } else {
      if (mounted && _showNewPostsIndicator) {
        setState(() {
          _showNewPostsIndicator = false;
        });
      }
    }

    // Load more posts when reaching bottom
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMorePosts();
    }
  }

  Future<void> _refreshFeed() async {
    print('Refresh triggered');
    final loc = AppLocalizations.of(context)!;

    try {
      // Clear any existing errors
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      print('Calling cubit.refreshPosts()');
      await _cubit.refreshPosts();
      print('Cubit refresh completed');
    } catch (e) {
      print('Refresh error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.homeRefreshFailed(e.toString())), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _loadMorePosts() async {
    if (!_cubit.isLoadingMore && _cubit.hasMore) {
      await _cubit.loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Image.asset("assets/images/logos/logo.png"),
          title: Text(loc.homeAppTitle, style: const TextStyle(fontFamily: 'AlexBrush', fontSize: 25)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.black87),
              onPressed: () {
                context.router.push(NotificationsRoute(userId: widget.userId));
              },
            ),
          ],
        ),
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            final hasNewPosts = _cubit.hasNewPosts;

            return Stack(
              children: [
                // Use Flutter's built-in RefreshIndicator
                RefreshIndicator(
                  onRefresh: _refreshFeed,
                  displacement: 40.0,
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // Posts list
                      if (state is HomeLoaded)
                        SliverList(
                          delegate: SliverChildBuilderDelegate((context, index) {
                            if (index < state.posts.length) {
                              final post = state.posts[index];
                              return PostCard(
                                post: post,
                                userId: post['userId'],
                                currentUserId: widget.userId ?? CurrentUserService.currentUserId ?? 0,
                              );
                            }
                            return null;
                          }, childCount: state.posts.length),
                        ),

                      // Loading more indicator
                      if (state is HomeLoaded && _cubit.isLoadingMore)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),

                      // End of feed message with safe area
                      if (state is HomeLoaded && !state.hasMorePosts && !_cubit.isLoadingMore)
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  loc.homeReachedEndOfFeed,
                                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ),
                              // Safe area at bottom
                              SafeArea(
                                top: false,
                                child: Container(
                                  height: MediaQuery.of(context).padding.bottom + 80,
                                  color: const Color(0xFFF5ECE7),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Loading indicator
                      if (state is HomeLoading)
                        const SliverFillRemaining(child: Center(child: CircularProgressIndicator())),

                      // Error state
                      if (state is HomeError)
                        SliverFillRemaining(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(state.message, style: const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: () {
                                      _cubit.loadPosts();
                                    },
                                    child: Text(loc.homeRetryButton),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      // Empty state
                      if (state is HomeLoaded && state.posts.isEmpty)
                        SliverFillRemaining(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                loc.homeNoPostsYet,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(SnackBar(content: Text(loc.homeSearchTabHint)));
                                },
                                child: Text(loc.homeFindUsersButton),
                              ),
                              // Safe area at bottom
                              SafeArea(
                                top: false,
                                child: Container(height: MediaQuery.of(context).padding.bottom + 80),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // New posts indicator
                if (hasNewPosts && _showNewPostsIndicator)
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_upward, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              loc.homeNewPosts,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 16),
                              onPressed: () {
                                _cubit.clearNewPostsBuffer();
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: CustomNavBar(currentPage: 'home', userId: widget.userId!),
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    _scrollController.dispose();
    super.dispose();
  }
}
