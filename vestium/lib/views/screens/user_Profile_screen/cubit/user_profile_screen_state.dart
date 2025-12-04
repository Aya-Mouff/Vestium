// user_profile_screen_state.dart
import 'package:flutter/material.dart';
import '../../../../databases/db_models.dart';
@immutable
abstract class UserProfileState {
  const UserProfileState();
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final User user;
  final List<PostModel> posts;
  final bool isFollowing;
  final int followersCount;  // Add this
  final int followingCount;  // Add this

  const UserProfileLoaded({
    required this.user,
    required this.posts,
    required this.isFollowing,
    this.followersCount = 0,
    this.followingCount = 0,
  });

  UserProfileLoaded copyWith({
    User? user,
    List<PostModel>? posts,
    bool? isFollowing,
    int? followersCount,  // Add this
    int? followingCount,  // Add this
  }) {
    return UserProfileLoaded(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      isFollowing: isFollowing ?? this.isFollowing,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
    );
  }
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);
}