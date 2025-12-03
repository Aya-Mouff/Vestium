import 'package:flutter_bloc/flutter_bloc.dart';
import 'photo_preview_state.dart';

class PhotoPreviewCubit extends Cubit<PhotoPreviewState> {
  PhotoPreviewCubit({required String imagePath})
      : super(PhotoPreviewState(imagePath: imagePath));

  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  void setError(bool error) {
    emit(state.copyWith(hasError: error));
  }
}