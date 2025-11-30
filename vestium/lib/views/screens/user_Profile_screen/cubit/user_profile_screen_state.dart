import 'package:equatable/equatable.dart';

class UserProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final Map<String, dynamic> user;
  final List<dynamic> posts;
  final bool isFollowing;

  UserProfileLoaded({
    required this.user,
    required this.posts,
    required this.isFollowing,
  });

  UserProfileLoaded copyWith({
    Map<String, dynamic>? user,
    List<dynamic>? posts,
    bool? isFollowing,
  }) {
    return UserProfileLoaded(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  @override
  List<Object?> get props => [user, posts, isFollowing];
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
