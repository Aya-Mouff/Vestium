import 'package:equatable/equatable.dart';

abstract class PostsDetailsState extends Equatable {
  const PostsDetailsState();

  @override
  List<Object?> get props => [];
}

class PostsDetailsInitial extends PostsDetailsState {}

class PostsDetailsLoading extends PostsDetailsState {}

class PostsDetailsLoaded extends PostsDetailsState {
  final List<Map<String, dynamic>> posts;
  final int initialIndex;

  const PostsDetailsLoaded({required this.posts, required this.initialIndex});

  @override
  List<Object?> get props => [posts, initialIndex];
}
