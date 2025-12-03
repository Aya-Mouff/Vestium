import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'take_pic_state.dart';

class TakePicCubit extends Cubit<TakePicState> {
  TakePicCubit() : super(const TakePicState());

  Future<void> loadCameras() async {
    try {
      final cameras = await availableCameras();
      emit(state.copyWith(cameras: cameras));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Error loading cameras: $e'));
    }
  }

  Future<void> startCamera() async {
    if (state.cameras == null || state.cameras!.isEmpty) return;
    
    emit(state.copyWith(isLoading: true));
    
    try {
      await _setupCamera(state.selectedCameraIndex);
      emit(state.copyWith(isCameraActive: true, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Error starting camera: $e',
      ));
    }
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (state.cameraController != null) {
      await state.cameraController!.dispose();
    }

    final cameraController = CameraController(
      state.cameras![cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await cameraController.initialize();
      emit(state.copyWith(
        cameraController: cameraController,
        isInitialized: true,
        selectedCameraIndex: cameraIndex,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Error setting up camera: $e'));
      rethrow;
    }
  }

  Future<void> flipCamera() async {
    if (state.cameras == null || state.cameras!.length < 2) return;

    emit(state.copyWith(isLoading: true));
    final newIndex = (state.selectedCameraIndex + 1) % state.cameras!.length;
    await _setupCamera(newIndex);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> stopCamera() async {
    await state.cameraController?.dispose();
    emit(state.copyWith(
      cameraController: null,
      isCameraActive: false,
      isInitialized: false,
    ));
  }

  Future<void> capturePhoto() async {
    if (state.cameraController == null || !state.cameraController!.value.isInitialized) {
      emit(state.copyWith(errorMessage: 'Camera not ready'));
      return;
    }

    try {
      final image = await state.cameraController!.takePicture();
      emit(state.copyWith(capturedImagePath: image.path));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Error capturing photo: $e'));
    }
  }

  void clearCapturedImage() {
    emit(state.copyWith(capturedImagePath: null));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  @override
  Future<void> close() async {
    await state.cameraController?.dispose();
    return super.close();
  }
}