import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/dummy/dummy-data-loader.dart';
import 'comments_screen_state.dart';

class CommentsScreenCubit extends Cubit<CommentsScreenState> {
  final int postId;
  final int userId;

  CommentsScreenCubit({required this.postId, required this.userId})
      : super(CommentsLoading());

  Future<void> loadComments() async {
    emit(CommentsLoading());

    final data = await DummyDataLoader.loadDummyData();

    /// Build users map with integer keys
    Map<int, dynamic> usersMap = {};
    for (var user in data['users']) {
      usersMap[int.parse(user['id'].toString())] = user;
    }

    final post = data['posts'].firstWhere(
      (p) => int.parse(p['id'].toString()) == postId,
      orElse: () => null,
    );

    /// Convert comments: id & userId to int
    List<Map<String, dynamic>> parsedComments = [];
    for (var c in (post?['comments'] ?? [])) {
      parsedComments.add({
        'id': int.parse(c['id'].toString()),
        'userId': int.parse(c['userId'].toString()),
        'text': c['text'],
        'createdAt': c['createdAt'],
      });
    }

    final currentUser = usersMap[userId];

    emit(
      CommentsLoaded(
        comments: parsedComments,
        currentUser: currentUser,
        usersMap: usersMap,
        userId: userId,
      ),
    );
  }

  void addComment(String text) {
    if (text.trim().isEmpty) return;
    if (state is! CommentsLoaded) return;

    final s = state as CommentsLoaded;

    final newComment = {
      'id': (s.comments.length + 1),
      'userId': userId,
      'text': text.trim(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    final updated = [...s.comments, newComment];

    emit(
      s.copyWith(comments: updated),
    );
  }
}
