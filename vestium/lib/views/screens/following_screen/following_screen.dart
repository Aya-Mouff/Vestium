import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repo/follow_repo.dart';
import '../../../repo/user_repo.dart';
import 'cubit/following_cubit.dart';
import 'cubit/following_state.dart';
import 'widgets/following_search_bar.dart';
import 'widgets/following_item.dart';

@RoutePage()
class FollowingScreen extends StatelessWidget {
  final int userId;
  final int currentUserId;

  const FollowingScreen({
    super.key,
    required this.userId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FollowingCubit(
        FollowRepo(),
        UserRepo(),
        userId: userId,
      )..loadFollowing(),
      child: const _FollowingView(),
    );
  }
}

class _FollowingView extends StatefulWidget {
  const _FollowingView();

  @override
  State<_FollowingView> createState() => _FollowingViewState();
}

class _FollowingViewState extends State<_FollowingView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<FollowingCubit>().updateSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowingCubit, FollowingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F0ED),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2C2C)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Following',
              style: TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'CormorantGaramond',
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              FollowingSearchBar(controller: _searchController),
              Expanded(
                child: _buildFollowingList(state),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFollowingList(FollowingState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Text(
          state.errorMessage!,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontFamily: 'Inter',
          ),
        ),
      );
    }

    if (state.filteredFollowing.isEmpty &&
        _searchController.text.isNotEmpty) {
      return Center(
        child: Text(
          'No results found',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontFamily: 'Inter',
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: state.filteredFollowing.length,
      itemBuilder: (context, index) {
        final person = state.filteredFollowing[index];
        return FollowingItem(
          name: person['name'] ?? '',
          username: person['username'] ?? '',
          profileImage: person['profileImage'] ?? '',
          isFollowing: person['isFollowing'] ?? false,
          onFollowTap: () =>
              context.read<FollowingCubit>().toggleFollow(index),
        );
      },
    );
  }
}
