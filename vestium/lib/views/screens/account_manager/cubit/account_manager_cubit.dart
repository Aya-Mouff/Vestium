import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/databases/services/current_user_service.dart';
import 'package:vestium/repo/user_repo.dart';

import 'account_manager_state.dart';

class AccountManagerCubit extends Cubit<AccountManagerState> {
  final int userId;
  final UserRepo _userRepo;

  AccountManagerCubit({
    required this.userId,
    UserRepo? userRepo,
  })  : _userRepo = userRepo ?? UserRepo(),
        super(const AccountManagerState());

  Future<void> init() async {
    try {
      emit(state.copyWith(status: AccountManagerStatus.loading));

      // Try current cached user first
      User? user = CurrentUserService.currentUser;

      // Fallback to DB by id
      if (user == null && userId != -1) {
        user = await _userRepo.getById(userId);
      }

      if (user == null) {
        emit(state.copyWith(
          status: AccountManagerStatus.error,
          message: 'User not found',
        ));
        return;
      }

      emit(AccountManagerState(
        fullName: user.fullName,
        email: user.email,
        status: AccountManagerStatus.initial,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'Failed to load account info',
      ));
    }
  }

  // -----------------------------
  // Change full name
  // -----------------------------
  Future<void> changeFullName({required String newFullName}) async {
    if (newFullName.trim().isEmpty) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'Full name cannot be empty',
      ));
      return;
    }

    emit(state.copyWith(status: AccountManagerStatus.loading, message: null));

    try {
      final currentId = CurrentUserService.currentUserId ?? userId;
      if (currentId == -1) {
        throw Exception('No current user');
      }

      final updatedUser = await _userRepo.updateUserPartial(
        userId: currentId,
        fullName: newFullName.trim(),
      );

      // Update in-memory cache
      await CurrentUserService.updateCurrentUser(updatedUser);

      emit(state.copyWith(
        fullName: updatedUser.fullName,
        status: AccountManagerStatus.success,
        message: 'Full name updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'Failed to update full name',
      ));
    }
  }

  // -----------------------------
  // Change email
  // -----------------------------
  Future<void> changeEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    newEmail = newEmail.trim();

    if (newEmail.isEmpty || !newEmail.contains('@')) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'Please enter a valid email',
      ));
      return;
    }
    if (currentPassword.isEmpty) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'Please enter your current password',
      ));
      return;
    }

    emit(state.copyWith(status: AccountManagerStatus.loading, message: null));

    try {
      final currentId = CurrentUserService.currentUserId ?? userId;
      if (currentId == -1) {
        throw Exception('No current user');
      }

      final user = await _userRepo.getById(currentId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Verify password
      if (user.password != currentPassword) {
        emit(state.copyWith(
          status: AccountManagerStatus.error,
          message: 'Current password is incorrect',
        ));
        return;
      }

      // Check if email already taken (and different from current)
      if (newEmail != user.email) {
        final available = await _userRepo.isEmailAvailable(newEmail);
        if (!available) {
          emit(state.copyWith(
            status: AccountManagerStatus.error,
            message: 'This email is already used by another account',
          ));
          return;
        }
      }

      final updatedUser = user.copyWith(email: newEmail);

      await _userRepo.updateUserProfile(updatedUser);
      await CurrentUserService.updateCurrentUser(updatedUser);

      emit(state.copyWith(
        email: updatedUser.email,
        status: AccountManagerStatus.success,
        message: 'Email updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'Failed to update email',
      ));
    }
  }

  // -----------------------------
  // Change password
  // -----------------------------
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'Please fill in all fields',
      ));
      return;
    }

    if (newPassword.length < 6) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'New password must be at least 6 characters',
      ));
      return;
    }

    if (newPassword != confirmPassword) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'New password and confirmation do not match',
      ));
      return;
    }

    emit(state.copyWith(status: AccountManagerStatus.loading, message: null));

    try {
      final currentId = CurrentUserService.currentUserId ?? userId;
      if (currentId == -1) {
        throw Exception('No current user');
      }

      final user = await _userRepo.getById(currentId);
      if (user == null) {
        throw Exception('User not found');
      }

      if (user.password != currentPassword) {
        emit(state.copyWith(
          status: AccountManagerStatus.error,
          message: 'Current password is incorrect',
        ));
        return;
      }

      final updatedUser = user.copyWith(password: newPassword);

      await _userRepo.updateUserProfile(updatedUser);
      await CurrentUserService.updateCurrentUser(updatedUser);

      emit(state.copyWith(
        status: AccountManagerStatus.success,
        message: 'Password updated successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'Failed to update password',
      ));
    }
  }

  // -----------------------------
  // Delete account
  // -----------------------------
  Future<void> deleteAccount({required String password}) async {
    if (password.isEmpty) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'Please enter your password',
      ));
      return;
    }

    emit(state.copyWith(status: AccountManagerStatus.loading, message: null));

    try {
      final currentId = CurrentUserService.currentUserId ?? userId;
      if (currentId == -1) {
        throw Exception('No current user');
      }

      final user = await _userRepo.getById(currentId);
      if (user == null) {
        throw Exception('User not found');
      }

      if (user.password != password) {
        emit(state.copyWith(
          status: AccountManagerStatus.error,
          message: 'Password is incorrect',
        ));
        return;
      }

      // Delete from DB + clear current user
      await CurrentUserService.deleteAccountFromDatabase(currentId);

      emit(state.copyWith(
        status: AccountManagerStatus.success,
        message: 'Account deleted successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AccountManagerStatus.error,
        message: 'Failed to delete account',
      ));
    }
  }
}
