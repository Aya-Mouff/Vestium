import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../repo/post_repo.dart';
import '../../../../databases/db_models.dart';
import 'new_post_state.dart';

class NewPostCubit extends Cubit<NewPostState> {
  final PostRepo _postRepo;
  final int userId;

  NewPostCubit(this._postRepo, {required this.userId})
      : super(const NewPostState());

  // ----- Mutations on simple fields -----

  void setCaption(String value) {
    emit(
      state.copyWith(
        caption: value,
        postSuccess: false,
        errorMessage: null,
      ),
    );
  }

  void togglePublic(bool value) {
    emit(
      state.copyWith(
        isPublic: value,
        postSuccess: false,
        errorMessage: null,
      ),
    );
  }

  void setSelectedOutfit(Map<String, dynamic> outfit) {
    print('✅ Cubit selected outfit: $outfit');
    emit(
      state.copyWith(
        selectedOutfit: outfit,
        postSuccess: false,
        errorMessage: null,
      ),
    );
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  // ----- Submit post to DB -----

  Future<void> submitPost() async {
    if (state.selectedOutfit == null) {
      emit(
        state.copyWith(
          errorMessage: 'Please choose an outfit first',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        postSuccess: false,
      ),
    );

    try {
      final outfit = state.selectedOutfit!;

      final post = PostModel(
        outfitId: outfit['id'] is int
            ? outfit['id'] as int
            : int.tryParse(outfit['id'].toString()),
        imagePath: outfit['imageUrl'] as String?,
        caption: state.caption.isEmpty ? null : state.caption,
        date: DateTime.now().toIso8601String(),
      );

      print('📝 Creating new post: '
          'outfitId=${post.outfitId}, '
          'imagePath=${post.imagePath}, '
          'caption=${post.caption}');

      final newId = await _postRepo.insert(post);

      print('✅ Post inserted into DB with id: $newId');

      emit(
        state.copyWith(
          isLoading: false,
          postSuccess: true,
        ),
      );
    } catch (e) {
      print('❌ Failed to create post: $e');
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to create post',
        ),
      );
    }
  }
}
