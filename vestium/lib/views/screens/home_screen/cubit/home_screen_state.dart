// home_screen_state.dart
import 'package:equatable/equatable.dart';
import '../../../../databases/db_models.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<dynamic> posts;
  final User? currentUser;
  final bool hasMorePosts; // Add this

  HomeLoaded({
    required this.posts,
    this.currentUser,
    this.hasMorePosts = true, // Default to true
  });

  @override
  List<Object?> get props => [posts, currentUser, hasMorePosts];
}

class HomeUserLoaded extends HomeState {
  final User user;

  HomeUserLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}