import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/user_profile_repository.dart';
import 'user_profile_screen_state.dart';
import 'package:flutter/material.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final UserProfileRepository repository;
  final int currentUserId;

  UserProfileCubit({
    required this.repository,
    required this.currentUserId,
  }) : super(UserProfileInitial());

  Future<void> loadProfile(int userId) async {
    emit(UserProfileLoading());

    try {
      final result = await repository.loadProfile(userId);
      emit(UserProfileLoaded(
        user: result['user'],
        posts: result['posts'],
        isFollowing: false,
      ));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  void toggleFollow(BuildContext context) {
    if (currentUserId == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must log in to follow users."),
        ),
      );
      return;
    }

    if (state is UserProfileLoaded) {
      final current = state as UserProfileLoaded;

      emit(current.copyWith(isFollowing: !current.isFollowing));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(current.isFollowing
              ? "Unfollowed"
              : "You are now following ${current.user['username']}"),
        ),
      );
    }
  }
}
