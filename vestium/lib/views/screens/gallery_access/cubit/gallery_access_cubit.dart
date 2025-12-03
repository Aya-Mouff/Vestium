import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'gallery_access_state.dart';

class GalleryAccessCubit extends Cubit<GalleryAccessState> {
  final ImagePicker _imagePicker = ImagePicker();

  GalleryAccessCubit() : super(const GalleryAccessState());

  Future<String?> requestGalleryAccess() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      PermissionStatus status = await Permission.photos.status;

      if (status.isDenied) {
        status = await Permission.photos.request();
      }

      if (status.isGranted) {
        // Permission granted - pick image
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 80,
        );

        emit(state.copyWith(isLoading: false));
        return image?.path; // Return image path if selected, null if canceled
      } else if (status.isPermanentlyDenied) {
        emit(state.copyWith(isLoading: false));
        return null;
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Gallery access denied',
          ),
        );
        return null;
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to request gallery access',
        ),
      );
      return null;
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void resetPermissionGranted() {
    emit(state.copyWith(permissionGranted: null));
  }
}