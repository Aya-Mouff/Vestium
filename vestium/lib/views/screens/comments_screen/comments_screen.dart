import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:vestium/l10n/app_localizations.dart';
import 'cubit/comments_screen_cubit.dart';
import 'cubit/comments_screen_state.dart';
import 'widgets/comment_item.dart';
import 'widgets/comment_input_field.dart';

@RoutePage()
class CommentsScreen extends StatelessWidget {
  final int postId;
  final int userId;

  const CommentsScreen({
    super.key,
    @PathParam('postId') required this.postId,
    @PathParam('userId') required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => CommentsScreenCubit(postId: postId, userId: userId)..loadComments(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5ECE7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => context.router.pop(),
          ),
          title: Text(
            loc.commentsTitle,
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<CommentsScreenCubit, CommentsScreenState>(
          builder: (context, state) {
            if (state is CommentsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CommentsLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: state.comments.isEmpty
                        ? Center(
                            child: Text(
                              loc.commentsNoComments,
                              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.grey.shade600),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: state.comments.length,
                            itemBuilder: (context, index) {
                              return CommentItem(
                                comment: state.comments[index],
                                usersMap: state.usersMap,
                                currentUserId: state.userId,
                              );
                            },
                          ),
                  ),

                  CommentInputField(
                    canComment: state.userId != -1,
                    onSend: (text) {
                      context.read<CommentsScreenCubit>().addComment(text);
                    },
                    currentUser: state.currentUser,
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
