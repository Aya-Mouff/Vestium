import 'package:equatable/equatable.dart';
import 'package:camera/camera.dart';

class TakePicState extends Equatable {
  final CameraController? cameraController;
  final List<CameraDescription>? cameras;
  final bool isInitialized;
  final bool isLoading;
  final bool isCameraActive;
  final int selectedCameraIndex;
  final String? errorMessage;
  final String? capturedImagePath;

  const TakePicState({
    this.cameraController,
    this.cameras,
    this.isInitialized = false,
    this.isLoading = false,
    this.isCameraActive = false,
    this.selectedCameraIndex = 0,
    this.errorMessage,
    this.capturedImagePath,
  });

  @override
  List<Object?> get props => [
        cameraController,
        cameras,
        isInitialized,
        isLoading,
        isCameraActive,
        selectedCameraIndex,
        errorMessage,
        capturedImagePath,
      ];

  TakePicState copyWith({
    CameraController? cameraController,
    List<CameraDescription>? cameras,
    bool? isInitialized,
    bool? isLoading,
    bool? isCameraActive,
    int? selectedCameraIndex,
    String? errorMessage,
    String? capturedImagePath,
  }) {
    return TakePicState(
      cameraController: cameraController ?? this.cameraController,
      cameras: cameras ?? this.cameras,
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      isCameraActive: isCameraActive ?? this.isCameraActive,
      selectedCameraIndex: selectedCameraIndex ?? this.selectedCameraIndex,
      errorMessage: errorMessage ?? this.errorMessage,
      capturedImagePath: capturedImagePath ?? this.capturedImagePath,
    );
  }
}