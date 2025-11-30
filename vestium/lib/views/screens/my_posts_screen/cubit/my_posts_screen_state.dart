import 'package:equatable/equatable.dart';

abstract class MyPostsScreenState extends Equatable {
  const MyPostsScreenState();

  @override
  List<Object?> get props => [];
}

class MyPostsInitial extends MyPostsScreenState {}

class MyPostsLoading extends MyPostsScreenState {}

class MyPostsLoaded extends MyPostsScreenState {
  final List<Map<String, dynamic>> posts;
  final int focusedPostIndex;
  final Set<String> likedPostIds;

  const MyPostsLoaded({
    required this.posts,
    required this.focusedPostIndex,
    required this.likedPostIds,
  });

  @override
  List<Object?> get props => [posts, focusedPostIndex, likedPostIds];

  MyPostsLoaded copyWith({
    List<Map<String, dynamic>>? posts,
    int? focusedPostIndex,
    Set<String>? likedPostIds,
  }) {
    return MyPostsLoaded(
      posts: posts ?? this.posts,
      focusedPostIndex: focusedPostIndex ?? this.focusedPostIndex,
      likedPostIds: likedPostIds ?? this.likedPostIds,
    );
  }
  
  // Pure getter - no business logic
  bool isPostLiked(String postId) {
    return likedPostIds.contains(postId);
  }
  
  // Pure getter - no business logic
  Map<String, dynamic>? getPostById(String postId) {
    try {
      return posts.firstWhere((post) => post['id'] == postId);
    } catch (e) {
      return null;
    }
  }
}

class MyPostsError extends MyPostsScreenState {
  final String message;

  const MyPostsError(this.message);

  @override
  List<Object?> get props => [message];
}

class MyPostsDeleted extends MyPostsScreenState {
  final String message;
  
  const MyPostsDeleted(this.message);
  
  @override
  List<Object?> get props => [message];
}