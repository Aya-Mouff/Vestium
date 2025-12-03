import 'package:equatable/equatable.dart';

class CameraAccessState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool shouldNavigate; // ✅ ADD THIS

  const CameraAccessState({
    this.isLoading = false,
    this.errorMessage,
    this.shouldNavigate = false, // ✅ ADD THIS
  });

  @override
  List<Object?> get props => [isLoading, errorMessage, shouldNavigate];

  CameraAccessState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? shouldNavigate, // ✅ ADD THIS
  }) {
    return CameraAccessState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      shouldNavigate: shouldNavigate ?? this.shouldNavigate, // ✅ ADD THIS
    );
  }
}