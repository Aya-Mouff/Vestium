import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repo/follow_repo.dart';
import '../../../../repo/user_repo.dart';
import '../../../../databases/db_models.dart';
import 'followers_state.dart';

class FollowersCubit extends Cubit<FollowersState> {
  final FollowRepo _followRepo;
  final UserRepo _userRepo;
  final int userId;

  FollowersCubit(
    this._followRepo,
    this._userRepo, {
    required this.userId,
  }) : super(const FollowersState());

  Future<void> loadFollowers() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      // 1. Get all follow relations
      final relations = await _followRepo.getAll();

      // 2. Filter only rows where this user is the "following" target
      // i.e. people who follow this user
      final myRelations = relations
          .where((f) => f.followingId == userId)
          .toList();

      // 3. Load follower users data
      final List<Map<String, dynamic>> followersData = [];
      for (final rel in myRelations) {
        final followerUser = await _userRepo.getById(rel.followerId);
        if (followerUser == null) continue;

        followersData.add({
          'id': followerUser.userId?.toString() ?? '',
          'name': followerUser.fullName ?? '',
          'username': followerUser.username ?? '',
          'bio': followerUser.bio ?? '',
          'profileImage': followerUser.pfp ?? '',
          'followersCount': 0, // fill if you track counts
          'followingCount': 0,
          'isFollowing': await _isCurrentUserFollowingBack(
            currentUserId: userId,
            otherUserId: followerUser.userId ?? 0,
            relations: relations,
          ),
        });
      }

      emit(
        state.copyWith(
          isLoading: false,
          allFollowers: followersData,
          filteredFollowers: followersData,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load followers',
        ),
      );
    }
  }

  Future<bool> _isCurrentUserFollowingBack({
    required int currentUserId,
    required int otherUserId,
    required List<FollowingFollower> relations,
  }) async {
    // following_id = otherUserId, follower_id = currentUserId
    return relations.any(
      (r) => r.followingId == otherUserId && r.followerId == currentUserId,
    );
  }

  void updateSearch(String query) {
    final lower = query.toLowerCase();

    final filtered = lower.isEmpty
        ? List<Map<String, dynamic>>.from(state.allFollowers)
        : state.allFollowers.where((follower) {
            final name = follower['name'].toString().toLowerCase();
            final username = follower['username'].toString().toLowerCase();
            return name.contains(lower) || username.contains(lower);
          }).toList();

    emit(
      state.copyWith(
        searchQuery: query,
        filteredFollowers: filtered,
      ),
    );
  }

  Future<void> toggleFollow(int index) async {
    if (index < 0 || index >= state.filteredFollowers.length) return;

    final followerToToggle = Map<String, dynamic>.from(
      state.filteredFollowers[index],
    );
    final followerId = int.tryParse(followerToToggle['id'].toString()) ?? 0;
    if (followerId == 0) return;

    final isCurrentlyFollowing = followerToToggle['isFollowing'] == true;

    // Optimistic UI update
    final all = List<Map<String, dynamic>>.from(state.allFollowers);
    final filtered = List<Map<String, dynamic>>.from(state.filteredFollowers);

    final originalIndex =
        all.indexWhere((f) => f['id'] == followerToToggle['id']);

    final newValue = !isCurrentlyFollowing;

    if (originalIndex != -1) {
      all[originalIndex] = {
        ...all[originalIndex],
        'isFollowing': newValue,
      };
    }
    filtered[index] = {
      ...filtered[index],
      'isFollowing': newValue,
    };

    emit(
      state.copyWith(
        allFollowers: all,
        filteredFollowers: filtered,
      ),
    );

    try {
      final followRepo = _followRepo;

      if (isCurrentlyFollowing) {
        // Unfollow: delete row where following_id = followerId, follower_id = userId
        await followRepo.delete(followerId, userId);
      } else {
        // Follow back: insert row (following_id = followerId, follower_id = userId)
        final relation = FollowingFollower(
          followingId: followerId,
          followerId: userId,
        );
        await followRepo.insert(relation);
      }
    } catch (e) {
      // On error, revert (optional)
      emit(
        state.copyWith(
          allFollowers: state.allFollowers,
          filteredFollowers: state.filteredFollowers,
        ),
      );
    }
  }
}
