import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vestium/databases/db_models.dart';
import 'package:vestium/repo/user_repo.dart';
import 'package:vestium/databases/services/current_user_service.dart';

part 'account_manager_state.dart';

class AccountManagerCubit extends Cubit<AccountManagerState> {
  final UserRepo _userRepo;

  AccountManagerCubit({required UserRepo userRepo})
    : _userRepo = userRepo,
      super(const AccountManagerInitial());

  /// Load current user data
  Future<void> loadUserData() async {
    try {
      emit(const AccountManagerLoading(message: 'Loading user data...'));

      final currentUser = CurrentUserService.currentUser;
      if (currentUser == null) {
        emit(const AccountManagerError(message: 'No user logged in'));
        return;
      }

      emit(AccountManagerLoaded(user: currentUser));
    } catch (e) {
      emit(AccountManagerError(message: 'Error loading user: ${e.toString()}'));
    }
  }

  /// Update user's full name
  /// Flow: Validate → Database update → Cache update → Emit success
  Future<void> updateFullName(String newFullName) async {
    if (state is! AccountManagerLoaded) return;

    final currentUser = (state as AccountManagerLoaded).user;

    // Validation
    final trimmedName = newFullName.trim();
    if (trimmedName.isEmpty) {
      emit(
        const AccountManagerError(
          message: 'Full name cannot be empty',
          updateType: 'fullName',
        ),
      );
      return;
    }

    try {
      // Show loading state
      emit(
        AccountManagerUpdating(
          user: currentUser,
          updateType: 'fullName',
          message: 'Updating full name...',
        ),
      );

      // Step 1: Update in database
      final updatedUser = currentUser.copyWith(fullName: trimmedName);

      if (updatedUser.userId == null) {
        throw Exception('User ID is null, cannot update');
      }

      final success = await _userRepo.update(updatedUser.userId!, updatedUser);

      if (!success) {
        throw Exception('Database update failed');
      }

      print(
        '✅ [DB] Full name updated in database: $trimmedName (User ID: ${updatedUser.userId})',
      );

      // Step 2: Update cache
      await CurrentUserService.updateCurrentUser(updatedUser);
      print('✅ [Cache] CurrentUserService updated with new full name');

      // Step 3: Emit success state
      emit(
        AccountManagerUpdateSuccess(
          user: updatedUser,
          updateType: 'fullName',
          message: 'Full name updated successfully',
        ),
      );

      // Step 4: Return to loaded state with updated user
      emit(AccountManagerLoaded(user: updatedUser));
    } catch (e) {
      print('❌ [Error] updateFullName failed: ${e.toString()}');
      emit(
        AccountManagerError(
          message: 'Error updating full name: ${e.toString()}',
          updateType: 'fullName',
        ),
      );
      // Revert to previous state
      emit(AccountManagerLoaded(user: currentUser));
    }
  }

  /// Update user's email
  /// Flow: Validate → Check availability → Database update → Cache update → Emit success
  Future<void> updateEmail({
    required String newEmail,
    required String password,
  }) async {
    if (state is! AccountManagerLoaded) return;

    final currentUser = (state as AccountManagerLoaded).user;

    // Validation 1: Email format
    if (!_isValidEmail(newEmail)) {
      emit(
        const AccountManagerError(
          message: 'Invalid email format',
          updateType: 'email',
        ),
      );
      return;
    }

    final trimmedEmail = newEmail.trim().toLowerCase();

    // Validation 2: Check if email is same as current
    if (trimmedEmail == currentUser.email?.toLowerCase()) {
      emit(
        const AccountManagerError(
          message: 'New email must be different from current email',
          updateType: 'email',
        ),
      );
      return;
    }

    // Validation 3: Verify current password
    if (password != currentUser.password) {
      emit(
        const AccountManagerError(
          message: 'Incorrect password',
          updateType: 'email',
        ),
      );
      return;
    }

    try {
      emit(
        AccountManagerUpdating(
          user: currentUser,
          updateType: 'email',
          message: 'Updating email...',
        ),
      );

      // Step 1: Check if new email is already in use by another user
      final emailExists = await _userRepo.getByEmail(trimmedEmail);
      if (emailExists != null && emailExists.userId != currentUser.userId) {
        throw Exception('This email is already registered');
      }

      // Step 2: Update in database
      final updatedUser = currentUser.copyWith(email: trimmedEmail);

      if (updatedUser.userId == null) {
        throw Exception('User ID is null, cannot update');
      }

      final success = await _userRepo.update(updatedUser.userId!, updatedUser);

      if (!success) {
        throw Exception('Database update failed');
      }

      print(
        '✅ [DB] Email updated in database: $trimmedEmail (User ID: ${updatedUser.userId})',
      );

      // Step 3: Update cache
      await CurrentUserService.updateCurrentUser(updatedUser);
      print('✅ [Cache] CurrentUserService updated with new email');

      // Step 4: Emit success state
      emit(
        AccountManagerUpdateSuccess(
          user: updatedUser,
          updateType: 'email',
          message: 'Email updated successfully',
        ),
      );

      // Step 5: Return to loaded state with updated user
      emit(AccountManagerLoaded(user: updatedUser));
    } catch (e) {
      print('❌ [Error] updateEmail failed: ${e.toString()}');
      emit(
        AccountManagerError(
          message: 'Error updating email: ${e.toString()}',
          updateType: 'email',
        ),
      );
      // Revert to previous state
      emit(AccountManagerLoaded(user: currentUser));
    }
  }

  /// Update user's password
  /// Flow: Validate → Database update → Cache update → Emit success
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (state is! AccountManagerLoaded) return;

    final currentUser = (state as AccountManagerLoaded).user;

    // Validation 1: Verify current password
    if (currentPassword != currentUser.password) {
      emit(
        const AccountManagerError(
          message: 'Current password is incorrect',
          updateType: 'password',
        ),
      );
      return;
    }

    // Validation 2: Check if new password is same as current
    if (newPassword == currentPassword) {
      emit(
        const AccountManagerError(
          message: 'New password must be different from current password',
          updateType: 'password',
        ),
      );
      return;
    }

    // Validation 3: Check password length
    if (newPassword.length < 6) {
      emit(
        const AccountManagerError(
          message: 'Password must be at least 6 characters',
          updateType: 'password',
        ),
      );
      return;
    }

    // Validation 4: Verify password confirmation
    if (newPassword != confirmPassword) {
      emit(
        const AccountManagerError(
          message: 'Passwords do not match',
          updateType: 'password',
        ),
      );
      return;
    }

    try {
      // Show loading state
      emit(
        AccountManagerUpdating(
          user: currentUser,
          updateType: 'password',
          message: 'Updating password...',
        ),
      );

      // Step 1: Update in database
      final updatedUser = currentUser.copyWith(password: newPassword);

      if (updatedUser.userId == null) {
        throw Exception('User ID is null, cannot update');
      }

      final success = await _userRepo.update(updatedUser.userId!, updatedUser);

      if (!success) {
        throw Exception('Database update failed');
      }

      print(
        '✅ [DB] Password updated in database (User ID: ${updatedUser.userId})',
      );

      // Step 2: Update cache
      await CurrentUserService.updateCurrentUser(updatedUser);
      print('✅ [Cache] CurrentUserService updated with new password');

      // Step 3: Emit success state
      emit(
        AccountManagerUpdateSuccess(
          user: updatedUser,
          updateType: 'password',
          message: 'Password updated successfully',
        ),
      );

      // Step 4: Return to loaded state with updated user
      emit(AccountManagerLoaded(user: updatedUser));
    } catch (e) {
      print('❌ [Error] updatePassword failed: ${e.toString()}');
      emit(
        AccountManagerError(
          message: 'Error updating password: ${e.toString()}',
          updateType: 'password',
        ),
      );
      // Revert to previous state
      emit(AccountManagerLoaded(user: currentUser));
    }
  }

  /// Delete user account
  /// Flow: Validate password → Database delete → Clear cache → Emit success
  Future<void> deleteAccount({required String password}) async {
    if (state is! AccountManagerLoaded) return;

    final currentUser = (state as AccountManagerLoaded).user;

    // Verify password before deletion
    if (password != currentUser.password) {
      emit(
        const AccountManagerError(
          message: 'Incorrect password',
          updateType: 'delete',
        ),
      );
      return;
    }

    try {
      // Show loading state
      emit(
        AccountManagerUpdating(
          user: currentUser,
          updateType: 'delete',
          message: 'Deleting account...',
        ),
      );

      if (currentUser.userId == null) {
        throw Exception('User ID is null, cannot delete account');
      }

      // Step 1: Delete from database
      final success = await _userRepo.delete(currentUser.userId!);

      if (!success) {
        throw Exception('Database deletion failed');
      }

      print(
        '✅ [DB] Account deleted from database (User ID: ${currentUser.userId})',
      );

      // Step 2: Clear from cache
      CurrentUserService.clearCurrentUser();
      print('✅ [Cache] CurrentUserService cleared');

      // Step 3: Emit success state
      emit(
        AccountManagerUpdateSuccess(
          user: currentUser,
          updateType: 'delete',
          message: 'Account deleted successfully',
        ),
      );

      // Step 4: Emit initial state so screen can navigate away
      emit(const AccountManagerInitial());
    } catch (e) {
      print('❌ [Error] deleteAccount failed: ${e.toString()}');
      emit(
        AccountManagerError(
          message: 'Error deleting account: ${e.toString()}',
          updateType: 'delete',
        ),
      );
      // Revert to previous state
      emit(AccountManagerLoaded(user: currentUser));
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
