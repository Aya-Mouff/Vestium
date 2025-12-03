// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:image_picker/image_picker.dart';
// import 'gallery_access_state.dart';

// class GalleryAccessCubit extends Cubit<GalleryAccessState> {
//   final ImagePicker _imagePicker = ImagePicker();

//   GalleryAccessCubit() : super(const GalleryAccessState());

//   Future<String?> requestGalleryAccess() async {
//     emit(state.copyWith(isLoading: true, errorMessage: null));

//     try {
//       PermissionStatus status = await Permission.photos.status;

//       if (status.isDenied) {
//         status = await Permission.photos.request();
//       }

//       if (status.isGranted) {
//         // Permission granted - pick image
//         final XFile? image = await _imagePicker.pickImage(
//           source: ImageSource.gallery,
//           maxWidth: 1920,
//           maxHeight: 1080,
//           imageQuality: 80,
//         );

//         emit(state.copyWith(isLoading: false));
//         return image?.path; // Return image path if selected, null if canceled
//       } else if (status.isPermanentlyDenied) {
//         emit(state.copyWith(isLoading: false));
//         return null;
//       } else {
//         emit(
//           state.copyWith(
//             isLoading: false,
//             errorMessage: 'Gallery access denied',
//           ),
//         );
//         return null;
//       }
//     } catch (e) {
//       emit(
//         state.copyWith(
//           isLoading: false,
//           errorMessage: 'Failed to request gallery access',
//         ),
//       );
//       return null;
//     }
//   }

//   void clearError() {
//     emit(state.copyWith(errorMessage: null));
//   }

//   void resetPermissionGranted() {
//     emit(state.copyWith(permissionGranted: null));
//   }
// }

// =============================================================

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import 'gallery_access_state.dart';

class GalleryAccessCubit extends Cubit<GalleryAccessState> {
  final ImagePicker _imagePicker = ImagePicker();

  GalleryAccessCubit() : super(const GalleryAccessState()) {
    // Check existing permission when cubit is created
    _checkExistingPermission();
  }

  // ADD THIS METHOD - checks if user already granted permission
  Future<void> _checkExistingPermission() async {
    emit(state.copyWith(checkingExistingPermission: true));
    
    try {
      // Check if user is logged in and has gallery permission
      final user = CurrentUserService.currentUser;
      if (user != null && user.galleryPermission == 1) {
        // User already has permission
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
    } catch (e) {
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

      if (status.isGranted || status.isLimited) {  // ADD isLimited
        // Permission granted - update user record
        final user = CurrentUserService.currentUser;
        if (user != null) {
          try {
            final updatedUser = user.copyWith(
              galleryPermission: 1,
            );
            await CurrentUserService.updateCurrentUser(updatedUser);
            print('✅ Gallery permission saved for user');
          } catch (e) {
            print('❌ Error saving gallery permission: $e');
          }
        }

        emit(state.copyWith(
          isLoading: false,
          permissionGranted: true,
        ));
        
        // Pick image
        final XFile? image = await _imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 80,
        );

        return image?.path; // Return image path if selected, null if canceled
      } else if (status.isPermanentlyDenied) {
        emit(state.copyWith(isLoading: false, permissionGranted: false));
        return null;
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            permissionGranted: false,
            errorMessage: 'Gallery access denied',
          ),
        );
        return null;
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          permissionGranted: false,
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
