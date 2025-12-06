import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/nav_bar.dart';
import '../../../app_router.dart';
import '../../../repo/follow_repo.dart';
import '../../../repo/user_repo.dart';
import 'cubit/search_cubit.dart';
import 'cubit/search_state.dart';
import 'widgets/recent_list.dart';
import 'widgets/search_result_item.dart';
import 'widgets/search_header.dart';

@RoutePage()
class SearchScreen extends StatelessWidget {
  final int userId;

  const SearchScreen({
    super.key,
    @PathParam('userId') required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(
        FollowRepo(),
        UserRepo(),
        currentUserId: userId,
      ),
      child: _SearchView(userId: userId),
    );
  }
}

class _SearchView extends StatefulWidget {
  final int userId;

  const _SearchView({super.key, required this.userId});

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<SearchCubit>().updateQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToProfile({
    required int profileUserId,
    required int currentUserId,
  }) {
    if (profileUserId == currentUserId) {
      // Navigate to MyProfileScreen for current user
      context.router.push(
        MyProfileRoute(
          userId: currentUserId,
        ),
      );
    } else {
      // Navigate to UserProfileScreen for other users
      context.router.push(
        UserProfileRoute(
          userId: profileUserId,
          currentUserId: currentUserId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final cubit = context.read<SearchCubit>();

        // keep controller in sync with state.query (for recent taps)
        if (_searchController.text != state.query) {
          _searchController.text = state.query;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5ECE7),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchHeader(
                  controller: _searchController,
                  isSearching: state.isSearching,
                  onClear: () {
                    _searchController.clear();
                    cubit.clearQuery();
                  },
                ),
                SizedBox(height: state.isSearching ? 16 : 24),
                if (!state.isSearching)
                  Expanded(
                    child: RecentList(
                      recentUsers: state.recentUsers,
                      onTapRecent: cubit.useRecent,
                      onRemoveRecent: cubit.removeRecent,
                      onClearAll: cubit.clearAllRecent,
                    ),
                  )
                else
                  _buildResults(state, cubit),
              ],
            ),
          ),
          bottomNavigationBar: CustomNavBar(
            currentPage: 'search',
            userId: widget.userId,
          ),
        );
      },
    );
  }

  Widget _buildResults(SearchState state, SearchCubit cubit) {
    if (state.isLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.errorMessage != null) {
      return Expanded(
        child: Center(
          child: Text(
            state.errorMessage!,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF795548),
              fontFamily: 'Inter',
            ),
          ),
        ),
      );
    }

    if (state.filteredUsers.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No results found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching for something else',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.filteredUsers.length,
        itemBuilder: (context, index) {
          final user = state.filteredUsers[index];
          return SearchResultItem(
            user: user,
            currentUserId: widget.userId, // Pass currentUserId
            onTapUser: () {
              cubit.addRecentFromUser(user);

              // `id` comes from SearchCubit.loadAllUsers
              final profileUserId = int.tryParse(user['id'].toString()) ?? 0;
              if (profileUserId == 0) return;

              _navigateToProfile(
                profileUserId: profileUserId,
                currentUserId: widget.userId,
              );
            },
            onToggleFollow: () => cubit.toggleFollow(index),
          );
        },
      ),
    );
  }
}