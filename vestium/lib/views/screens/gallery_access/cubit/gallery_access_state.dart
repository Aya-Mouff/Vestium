// import 'package:equatable/equatable.dart';

// class GalleryAccessState extends Equatable {
//   final bool isLoading;
//   final String? errorMessage;
//   final bool? permissionGranted;

//   const GalleryAccessState({
//     this.isLoading = false,
//     this.errorMessage,
//     this.permissionGranted,
//   });

//   @override
//   List<Object?> get props => [isLoading, errorMessage, permissionGranted];

//   GalleryAccessState copyWith({
//     bool? isLoading,
//     String? errorMessage,
//     bool? permissionGranted,
//   }) {
//     return GalleryAccessState(
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage ?? this.errorMessage,
//       permissionGranted: permissionGranted ?? this.permissionGranted,
//     );
//   }
// }

// =============================================================================

import 'package:equatable/equatable.dart';

class GalleryAccessState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final bool? permissionGranted;
  final bool checkingExistingPermission;  // ADD THIS

  const GalleryAccessState({
    this.isLoading = false,
    this.errorMessage,
    this.permissionGranted,
    this.checkingExistingPermission = true,  // ADD THIS - start checking on init
  });

  @override
  List<Object?> get props => [isLoading, errorMessage, permissionGranted, checkingExistingPermission];  // ADD checkingExistingPermission

  GalleryAccessState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? permissionGranted,
    bool? checkingExistingPermission,  // ADD THIS
  }) {
    return GalleryAccessState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      checkingExistingPermission: checkingExistingPermission ?? this.checkingExistingPermission,  // ADD THIS
    );
  }
}
