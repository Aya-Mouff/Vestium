import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app_router.dart';
import '../../../../repo/user_repo.dart';
import '../../../../databases/services/current_user_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final UserRepo _userRepo;
  final int userId;
  final ImagePicker _imagePicker = ImagePicker();

  SettingsCubit(this._userRepo, {required this.userId})
      : super(const SettingsState()) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final user = await _userRepo.getById(userId);
      if (user == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: 'User not found',
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isLoading: false,
          displayName: user.fullName ?? '',
          displayUsername: user.username ?? '',
          displayBio: user.bio ?? '',
          profileImage: user.pfp,
          pushNotifications: true,
          emailNotifications: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load user data',
        ),
      );
    }
  }

  Future<void> pickProfileImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        // Update the state with the new image path without changing other values
        emit(state.copyWith(
          profileImage: image.path,
          hasImageChanged: true,
          // Preserve other edit mode values
          displayName: state.displayName,
          displayUsername: state.displayUsername,
          displayBio: state.displayBio,
          isEditing: state.isEditing,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to pick image',
      ));
    }
  }

  void toggleEdit() {
    emit(state.copyWith(
      isEditing: !state.isEditing,
      saveSuccess: false,
      hasImageChanged: false,
    ));
  }

  void cancelEdit() {
    emit(state.copyWith(
      isEditing: false,
      saveSuccess: false,
      hasImageChanged: false,
    ));
    loadUserData(); // reload original values
  }

  Future<void> saveChanges(
    String name,
    String username,
    String bio,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        saveSuccess: false,
      ),
    );
    try {
      // TODO: If you need to upload the image to a server, do it here
      // For now, we're just saving the local path
      String? imagePath = state.hasImageChanged ? state.profileImage : null;
      
      await _userRepo.updateUserPartial(
        userId: userId,
        fullName: name,
        username: username,
        bio: bio,
        pfp: imagePath, // Add this parameter to your updateUserPartial method
      );
      
      emit(
        state.copyWith(
          isLoading: false,
          isEditing: false,
          displayName: name,
          displayUsername: username,
          displayBio: bio,
          saveSuccess: true,
          hasImageChanged: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to save changes',
        ),
      );
    }
  }

  void togglePushNotifications(bool value) {
    emit(state.copyWith(pushNotifications: value));
    // TODO: save to preferences or DB
  }

  void toggleEmailNotifications(bool value) {
    emit(state.copyWith(emailNotifications: value));
    // TODO: save to preferences or DB
  }

  Future<void> logout(BuildContext context) async {
    CurrentUserService.clearCurrentUser();
    context.router.replaceAll([
      const LogInRoute(),
    ]);
  }
}