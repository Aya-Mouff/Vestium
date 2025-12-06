import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_router.dart';
import '../../../../repo/user_repo.dart';
import '../../../../databases/services/current_user_service.dart'; // <-- make sure this path is correct
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final UserRepo _userRepo;
  final int userId;

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
          pushNotifications: true, // load from preferences if you track them
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

  void toggleEdit() {
    emit(state.copyWith(isEditing: !state.isEditing, saveSuccess: false));
  }

  void cancelEdit() {
    emit(state.copyWith(isEditing: false, saveSuccess: false));
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
      await _userRepo.updateUserPartial(
        userId: userId,
        fullName: name,
        username: username,
        bio: bio,
      );
      emit(
        state.copyWith(
          isLoading: false,
          isEditing: false,
          displayName: name,
          displayUsername: username,
          displayBio: bio,
          saveSuccess: true,
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
    try {
      // Clear current user and persist logout state
      await CurrentUserService.clearCurrentUser();
      
      // Navigate to login screen and clear navigation stack
      if (context.mounted) {
        context.router.replaceAll([
          const LogInRoute(),
        ]);
      }
      
      print('✅ Logout successful');
    } catch (e) {
      print('❌ Error during logout: $e');
      
      // Still navigate to login even if there's an error
      if (context.mounted) {
        context.router.replaceAll([
          const LogInRoute(),
        ]);
      }
    }
  }
}
