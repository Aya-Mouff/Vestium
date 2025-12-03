import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
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
          // Permission granted - handled in screen
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
        // Permission already granted - handled in screen
      }
      
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'An error occurred while requesting camera permission.',
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}