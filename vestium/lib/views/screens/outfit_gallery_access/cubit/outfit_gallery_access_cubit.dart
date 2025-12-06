import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import 'package:vestium/databases/services/current_user_service.dart';
import 'outfit_gallery_access_state.dart';

class OutfitGalleryAccessCubit extends Cubit<OutfitGalleryAccessState> {
  final ImagePicker _imagePicker = ImagePicker();

  OutfitGalleryAccessCubit()
      : super(const OutfitGalleryAccessState()) {
    _checkExistingPermission();
  }

  Future<void> _checkExistingPermission() async {
    emit(state.copyWith(checkingExistingPermission: true));
    try {
      final user = CurrentUserService.currentUser;
      if (user != null && user.galleryPermission == 1) {
        emit(state.copyWith(
          checkingExistingPermission: false,
          permissionGranted: true,
        ));
      } else {
        emit(state.copyWith(
          checkingExistingPermission: false,
          permissionGranted: false,
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        checkingExistingPermission: false,
        errorMessage: 'Error checking existing permission',
      ));
    }
  }

  Future<String?> requestGalleryAccess() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      PermissionStatus status = await Permission.photos.status;
      if (status.isDenied) {
        status = await Permission.photos.request();
      }

      if (status.isGranted || status.isLimited) {
        final user = CurrentUserService.currentUser;
        if (user != null) {
          try {
            final updatedUser = user.copyWith(galleryPermission: 1);
            await CurrentUserService.updateCurrentUser(updatedUser);
          } catch (_) {
            // ignore error for saving flag
          }
        }

        emit(state.copyWith(
          isLoading: false,
          permissionGranted: true,
        ));

        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 80,
        );
        return image?.path;
      } else if (status.isPermanentlyDenied) {
        emit(state.copyWith(
          isLoading: false,
          permissionGranted: false,
        ));
        return null;
      } else {
        emit(state.copyWith(
          isLoading: false,
          permissionGranted: false,
          errorMessage: 'Gallery access denied',
        ));
        return null;
      }
    } catch (_) {
      emit(state.copyWith(
        isLoading: false,
        permissionGranted: false,
        errorMessage: 'Failed to request gallery access',
      ));
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
