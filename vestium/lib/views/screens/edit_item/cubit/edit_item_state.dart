part of 'edit_item_cubit.dart';

class EditItemState extends Equatable {
  // Editing modes
  final bool isCropping;
  final bool isRemovingBg;
  
  // Eraser settings
  final double eraserSize;
  
  // Image paths
  final String? editedImagePath;
  
  // Database operation states
  final bool isSaving;
  final bool isLoading;
  final String? errorMessage;
  final int? lastSavedItemId;
  final int? currentItemId;

  const EditItemState({
    this.isCropping = false,
    this.isRemovingBg = false,
    this.eraserSize = 50.0,
    this.editedImagePath,
    this.isSaving = false,
    this.isLoading = false,
    this.errorMessage,
    this.lastSavedItemId,
    this.currentItemId,
  });

  @override
  List<Object?> get props => [
        isCropping,
        isRemovingBg,
        eraserSize,
        editedImagePath,
        isSaving,
        isLoading,
        errorMessage,
        lastSavedItemId,
        currentItemId,
      ];

  EditItemState copyWith({
    bool? isCropping,
    bool? isRemovingBg,
    double? eraserSize,
    String? editedImagePath,
    bool? isSaving,
    bool? isLoading,
    String? errorMessage,
    int? lastSavedItemId,
    int? currentItemId,
  }) {
    return EditItemState(
      isCropping: isCropping ?? this.isCropping,
      isRemovingBg: isRemovingBg ?? this.isRemovingBg,
      eraserSize: eraserSize ?? this.eraserSize,
      editedImagePath: editedImagePath ?? this.editedImagePath,
      isSaving: isSaving ?? this.isSaving,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSavedItemId: lastSavedItemId ?? this.lastSavedItemId,
      currentItemId: currentItemId ?? this.currentItemId,
    );
  }
}