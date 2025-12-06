import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isLoading;
  final bool isEditing;
  final String displayName;
  final String displayUsername;
  final String displayBio;
  final String? profileImage;
  final bool pushNotifications;
  final bool emailNotifications;
  final String? errorMessage;
  final bool saveSuccess;
  final bool hasImageChanged; // Track if image was changed in edit mode

  const SettingsState({
    this.isLoading = false,
    this.isEditing = false,
    this.displayName = '',
    this.displayUsername = '',
    this.displayBio = '',
    this.profileImage,
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.errorMessage,
    this.saveSuccess = false,
    this.hasImageChanged = false,
  });

  SettingsState copyWith({
    bool? isLoading,
    bool? isEditing,
    String? displayName,
    String? displayUsername,
    String? displayBio,
    String? profileImage,
    bool? pushNotifications,
    bool? emailNotifications,
    String? errorMessage,
    bool? saveSuccess,
    bool? hasImageChanged,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      isEditing: isEditing ?? this.isEditing,
      displayName: displayName ?? this.displayName,
      displayUsername: displayUsername ?? this.displayUsername,
      displayBio: displayBio ?? this.displayBio,
      profileImage: profileImage ?? this.profileImage,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      errorMessage: errorMessage,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      hasImageChanged: hasImageChanged ?? this.hasImageChanged,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isEditing,
        displayName,
        displayUsername,
        displayBio,
        profileImage,
        pushNotifications,
        emailNotifications,
        errorMessage,
        saveSuccess,
        hasImageChanged,
      ];
}