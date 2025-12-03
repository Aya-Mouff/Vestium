import 'package:equatable/equatable.dart';

class CameraAccessState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const CameraAccessState({
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage];

  CameraAccessState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return CameraAccessState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}