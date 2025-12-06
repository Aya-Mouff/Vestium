import 'package:equatable/equatable.dart';

class OutfitGalleryAccessState extends Equatable {
  final bool isLoading;
  final bool? permissionGranted; // null = unknown, true/false = result
  final bool checkingExistingPermission;
  final String? errorMessage;

  const OutfitGalleryAccessState({
    this.isLoading = false,
    this.permissionGranted,
    this.checkingExistingPermission = false,
    this.errorMessage,
  });

  OutfitGalleryAccessState copyWith({
    bool? isLoading,
    bool? permissionGranted,
    bool? checkingExistingPermission,
    String? errorMessage,
  }) {
    return OutfitGalleryAccessState(
      isLoading: isLoading ?? this.isLoading,
      permissionGranted: permissionGranted,
      checkingExistingPermission:
          checkingExistingPermission ?? this.checkingExistingPermission,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, permissionGranted, checkingExistingPermission, errorMessage];
}
