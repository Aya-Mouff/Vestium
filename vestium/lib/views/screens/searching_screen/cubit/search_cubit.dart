import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repo/follow_repo.dart';
import '../../../../repo/user_repo.dart';
import '../../../../databases/db_models.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final FollowRepo _followRepo;
  final UserRepo _userRepo;
  final int currentUserId;

  SearchCubit(
    this._followRepo,
    this._userRepo, {
    required this.currentUserId,
  }) : super(const SearchState()) {
    loadAllUsers();
  }

  Future<void> loadAllUsers() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final users = await _userRepo.getAll(); // all DB users [file:6]

      final allUsers = users
          // .where((u) => u.userId != currentUserId)
          .map((u) => {
                'id': u.userId?.toString() ?? '',
                'username': u.username ?? '',
                'fullName': u.fullName ?? '',
                'bio': u.bio ?? '',
                'profileImage': u.pfp ?? '',
                'followersCount': 0,
                'followingCount': 0,
                'isFollowing': false,
              })
          .toList();



      emit(
        state.copyWith(
          isLoading: false,
          allUsers: allUsers,
          filteredUsers: allUsers,
          recentUsers: const [],
        ),
      );
    } catch (e) {
       
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load users',
        ),
      );
    }
  }

  // --- Search ---

  void updateQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      emit(
        state.copyWith(
          query: '',
          filteredUsers: List<Map<String, dynamic>>.from(state.allUsers),
        ),
      );
      return;
    }

    final lower = trimmed.toLowerCase();
    final filtered = state.allUsers.where((user) {
      final username = user['username'].toString().toLowerCase();
      final fullName = user['fullName'].toString().toLowerCase();
      final bio = user['bio'].toString().toLowerCase();
      return username.contains(lower) ||
          fullName.contains(lower) ||
          bio.contains(lower);
    }).toList();

    emit(
      state.copyWith(
        query: trimmed,
        filteredUsers: filtered,
      ),
    );
  }

  void clearQuery() {
    emit(
      state.copyWith(
        query: '',
        filteredUsers: List<Map<String, dynamic>>.from(state.allUsers),
      ),
    );
  }

  // --- Recent ---

  void addRecentFromUser(Map<String, dynamic> user) {
    final username = user['username'] as String;
    final recent = List<String>.from(state.recentUsers);
    recent.remove(username);
    recent.insert(0, username);
    emit(state.copyWith(recentUsers: recent));
  }

  void useRecent(String username) {
    emit(state.copyWith(query: username));
    updateQuery(username);
  }

  void removeRecent(int index) {
    final recent = List<String>.from(state.recentUsers)..removeAt(index);
    emit(state.copyWith(recentUsers: recent));
  }

  void clearAllRecent() {
    emit(state.copyWith(recentUsers: []));
  }

  // --- Follow / Unfollow ---

  Future<void> toggleFollow(int index) async {
    if (index < 0 || index >= state.filteredUsers.length) return;

    final user = Map<String, dynamic>.from(state.filteredUsers[index]);
    final targetId = int.tryParse(user['id'].toString()) ?? 0;
    if (targetId == 0) return;

    final isCurrentlyFollowing = user['isFollowing'] == true;

    final all = List<Map<String, dynamic>>.from(state.allUsers);
    final filtered = List<Map<String, dynamic>>.from(state.filteredUsers);

    final newValue = !isCurrentlyFollowing;

    filtered[index] = {
      ...filtered[index],
      'isFollowing': newValue,
    };

    final allIndex = all.indexWhere((u) => u['id'] == user['id']);
    if (allIndex != -1) {
      all[allIndex] = {
        ...all[allIndex],
        'isFollowing': newValue,
      };
    }

    emit(
      state.copyWith(
        allUsers: all,
        filteredUsers: filtered,
      ),
    );

    try {
      if (isCurrentlyFollowing) {
        await _followRepo.delete(targetId, currentUserId); // unfollow [file:4]
      } else {
        final relation = FollowingFollower(
          followingId: targetId,
          followerId: currentUserId,
        );
        await _followRepo.insert(relation); // follow [file:4]
      }
    } catch (_) {
      // optional: revert if you want strict consistency
    }
  }
}
