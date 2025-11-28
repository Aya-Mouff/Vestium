import 'package:equatable/equatable.dart';

abstract class CommentsScreenState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommentsLoading extends CommentsScreenState {}

class CommentsLoaded extends CommentsScreenState {
  final List<dynamic> comments;
  final dynamic currentUser;
  final Map<int, dynamic> usersMap;
  final int userId;

  CommentsLoaded({
    required this.comments,
    required this.currentUser,
    required this.usersMap,
    required this.userId,
  });

  CommentsLoaded copyWith({
    List<dynamic>? comments,
    dynamic currentUser,
    Map<int, dynamic>? usersMap,
    int? userId,
  }) {
    return CommentsLoaded(
      comments: comments ?? this.comments,
      currentUser: currentUser ?? this.currentUser,
      usersMap: usersMap ?? this.usersMap,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [comments, currentUser, usersMap, userId];
}
