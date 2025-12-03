import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import 'camera_access_state.dart';

class CameraAccessCubit extends Cubit<CameraAccessState> {
  CameraAccessCubit() : super(const CameraAccessState());

  Future<void> requestCameraPermission() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      final status = await Permission.camera.status;
      
      if (status.isDenied) {
        final result = await Permission.camera.request();
        
        if (result.isGranted) {
          // ✅ Save permission to database
          await _saveCameraPermissionToDB(granted: true);
        } else if (result.isPermanentlyDenied) {
          await openAppSettings();
        } else {
          emit(state.copyWith(
            isLoading: false,
            errorMessage: 'Camera access is required to capture photos.',
          ));
        }
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else if (status.isGranted) {
        // ✅ Already granted - save to database
        await _saveCameraPermissionToDB(granted: true);
      }
      
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred while requesting camera permission.',
      ));
    }
  }

  // ✅ Get current user ID from CurrentUserService
  Future<int?> _getCurrentUserId() async {
    try {
      final userId = CurrentUserService.currentUserId;
      
      if (userId == null) {
        print('⚠️ No current user logged in');
        // Try to load from database on startup
        await CurrentUserService.loadLastUserFromDatabase();
        return CurrentUserService.currentUserId;
      }
      
      return userId;
    } catch (e) {
      print('❌ Error getting current user ID: $e');
      return null;
    }
  }

  // ✅ Save camera permission to database
  Future<void> _saveCameraPermissionToDB({required bool granted}) async {
    try {
      final userId = await _getCurrentUserId();
      
      if (userId != null && CurrentUserService.currentUser != null) {
        // Update in CurrentUserService
        final updatedUser = CurrentUserService.currentUser!.copyWith(
          cameraPermission: granted ? 1 : 0,
        );
        
        await CurrentUserService.updateCurrentUser(updatedUser);
        print('✅ Camera permission saved for current user $userId: $granted');
      } else {
        print('⚠️ No current user found');
      }
    } catch (e) {
      print('❌ Error saving camera permission to database: $e');
    }
  }

  // ✅ Check if camera permission is already saved in database for current user
  Future<bool> checkIfPermissionAlreadyGranted() async {
    try {
      if (!CurrentUserService.isLoggedIn) {
        await CurrentUserService.loadLastUserFromDatabase();
      }
      
      final user = CurrentUserService.currentUser;
      
      if (user == null) {
        print('⚠️ No current user found');
        return false;
      }
      
      final isGranted = user.cameraPermission == 1;
      print('🔍 Database permission check - Current user ${user.userId}: cameraPermission = ${user.cameraPermission} (granted: $isGranted)');
      
      return isGranted;
    } catch (e) {
      print('❌ Error checking permission from database: $e');
      return false;
    }
  }

  // ✅ Check database first and skip permission screen if already granted
  Future<void> checkAndSkipIfAlreadyGranted() async {
    try {
      final isAlreadyGranted = await checkIfPermissionAlreadyGranted();
      
      if (isAlreadyGranted) {
        // Also check system permission
        final status = await Permission.camera.status;
        if (status.isGranted) {
          print('✅ Camera permission already granted in database and system');
          // Emit state to trigger navigation
          emit(state.copyWith(shouldNavigate: true));
        }
      }
    } catch (e) {
      print('❌ Error in checkAndSkipIfAlreadyGranted: $e');
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  void clearNavigationFlag() {
    emit(state.copyWith(shouldNavigate: false));
  }
}