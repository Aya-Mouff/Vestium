import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repo/follow_repo.dart';
import '../../../../repo/user_repo.dart';
import '../../../../databases/db_models.dart';
import 'following_state.dart';

class FollowingCubit extends Cubit<FollowingState> {
  final FollowRepo _followRepo;
  final UserRepo _userRepo;
  final int userId;

  FollowingCubit(
    this._followRepo,
    this._userRepo, {
    required this.userId,
  }) : super(const FollowingState());

  Future<void> loadFollowing() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final relations = await _followRepo.getAll();

      // current user is follower -> we want the people they follow
      final myRelations =
          relations.where((f) => f.followerId == userId).toList();

      final List<Map<String, dynamic>> followingData = [];

      // for (final rel in myRelations) {
      //   final followedUser = await _userRepo.getById(rel.followingId);
      //   if (followedUser == null) continue;

      //   followingData.add({
      //     'id': followedUser.userId?.toString() ?? '',
      //     'name': followedUser.fullName ?? '',
      //     'username': followedUser.username ?? '',
      //     'bio': followedUser.bio ?? '',
      //     'profileImage': followedUser.pfp ?? '',
      //     'followersCount': 0,
      //     'followingCount': 0,
      //     'isFollowing': true, // by definition we follow them
      //   });
      // }
      // In FollowingCubit.loadFollowing() method, update the followingData.add:
      for (final rel in myRelations) {
        final followedUser = await _userRepo.getById(rel.followingId);
        if (followedUser == null) continue;

        followingData.add({
          'id': followedUser.userId?.toString() ?? '',
          'userId': followedUser.userId, // Add this - the actual person's ID
          'name': followedUser.fullName ?? '',
          'username': followedUser.username ?? '',
          'bio': followedUser.bio ?? '',
          'profileImage': followedUser.pfp ?? '',
          'followersCount': 0,
          'followingCount': 0,
          'isFollowing': true,
        });
      }

      emit(
        state.copyWith(
          isLoading: false,
          allFollowing: followingData,
          filteredFollowing: followingData,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load following',
        ),
      );
    }
  }

  void updateSearch(String query) {
    final lower = query.toLowerCase();

    final filtered = lower.isEmpty
        ? List<Map<String, dynamic>>.from(state.allFollowing)
        : state.allFollowing.where((person) {
            final name = person['name'].toString().toLowerCase();
            final username = person['username'].toString().toLowerCase();
            return name.contains(lower) || username.contains(lower);
          }).toList();

    emit(
      state.copyWith(
        searchQuery: query,
        filteredFollowing: filtered,
      ),
    );
  }

  Future<void> toggleFollow(int index) async {
    if (index < 0 || index >= state.filteredFollowing.length) return;

    final personToToggle =
        Map<String, dynamic>.from(state.filteredFollowing[index]);
    final followedId = int.tryParse(personToToggle['id'].toString()) ?? 0;
    if (followedId == 0) return;

    final isCurrentlyFollowing = personToToggle['isFollowing'] == true;

    // Optimistic UI update
    final all = List<Map<String, dynamic>>.from(state.allFollowing);
    final filtered = List<Map<String, dynamic>>.from(state.filteredFollowing);

    final originalIndex =
        all.indexWhere((f) => f['id'] == personToToggle['id']);

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
        allFollowing: all,
        filteredFollowing: filtered,
      ),
    );

    try {
      if (isCurrentlyFollowing) {
        // Unfollow: delete relation where follower_id = userId, following_id = followedId
        await _followRepo.delete(followedId, userId);
      } else {
        // Follow: insert relation
        final relation = FollowingFollower(
          followingId: followedId,
          followerId: userId,
        );
        await _followRepo.insert(relation);
      }
    } catch (e) {
      // Revert on error
      emit(
        state.copyWith(
          allFollowing: state.allFollowing,
          filteredFollowing: state.filteredFollowing,
        ),
      );
    }
  }
}
