import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../repo/follow_repo.dart';
import '../../../repo/user_repo.dart';
import 'cubit/followers_cubit.dart';
import 'cubit/followers_state.dart';
import 'widgets/followers_search_bar.dart';
import 'widgets/follower_item.dart';

@RoutePage()
class FollowersScreen extends StatelessWidget {
  final int userId;
  final int currentUserId;

  const FollowersScreen({
    super.key,
    required this.userId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FollowersCubit(
        FollowRepo(),
        UserRepo(),
        userId: userId,
      )..loadFollowers(),
      child: _FollowersView(
        userId: userId,
        currentUserId: currentUserId,
      ),
    );
  }
}

class _FollowersView extends StatefulWidget {
  final int userId;
  final int currentUserId;

  const _FollowersView({
    required this.userId,
    required this.currentUserId,
  });

  @override
  State<_FollowersView> createState() => _FollowersViewState();
}

class _FollowersViewState extends State<_FollowersView> {


  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      context.read<FollowersCubit>().updateSearch(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowersCubit, FollowersState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F0ED),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Followers',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'CormorantGaramond',
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              FollowersSearchBar(controller: _searchController),
              Expanded(
                child: _buildFollowersList(state, userId: widget.userId, currentUserId: widget.currentUserId),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFollowersList(FollowersState state, {required int userId, required int currentUserId}) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Text(
          state.errorMessage!,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF795548),
            fontFamily: 'Inter',
          ),
        ),
      );
    }

    if (state.filteredFollowers.isEmpty &&
        _searchController.text.isNotEmpty) {
      return const Center(
        child: Text(
          'No followers found',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF795548),
            fontFamily: 'Inter',
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: state.filteredFollowers.length,
      itemBuilder: (context, index) {
        final follower = state.filteredFollowers[index];
        final followerUserId = follower['userId'] ?? int.tryParse(follower['id'] ?? '') ?? 0;
        
        return FollowerItem(
          name: follower['name'] ?? '',
          username: follower['username'] ?? '',
          profileImage: follower['profileImage'] ?? '',
          isFollowing: follower['isFollowing'] ?? false,
          followerUserId: followerUserId, // Pass the follower's actual user ID
          currentUserId: currentUserId,
          onFollowTap: () =>
              context.read<FollowersCubit>().toggleFollow(index),
        );
      },
    );
  }
}
