import 'package:equatable/equatable.dart';

class PhotoPreviewState extends Equatable {
  final String imagePath;
  final bool isLoading;
  final bool hasError;

  const PhotoPreviewState({
    required this.imagePath,
    this.isLoading = false,
    this.hasError = false,
  });

  @override
  List<Object?> get props => [
        imagePath,
        isLoading,
        hasError,
      ];

  PhotoPreviewState copyWith({
    String? imagePath,
    bool? isLoading,
    bool? hasError,
  }) {
    return PhotoPreviewState(
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}