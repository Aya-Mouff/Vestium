import 'package:equatable/equatable.dart';

class NewPostState extends Equatable {
  final bool isLoading;
  final bool isPublic;
  final Map<String, dynamic>? selectedOutfit;
  final String caption;
  final String? errorMessage;
  final bool postSuccess;

  const NewPostState({
    this.isLoading = false,
    this.isPublic = true,
    this.selectedOutfit,
    this.caption = '',
    this.errorMessage,
    this.postSuccess = false,
  });

  NewPostState copyWith({
    bool? isLoading,
    bool? isPublic,
    Map<String, dynamic>? selectedOutfit,
    String? caption,
    String? errorMessage,
    bool? postSuccess,
  }) {
    return NewPostState(
      isLoading: isLoading ?? this.isLoading,
      isPublic: isPublic ?? this.isPublic,
      selectedOutfit: selectedOutfit ?? this.selectedOutfit,
      caption: caption ?? this.caption,
      errorMessage: errorMessage,
      postSuccess: postSuccess ?? this.postSuccess,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, isPublic, selectedOutfit, caption, errorMessage, postSuccess];
}
