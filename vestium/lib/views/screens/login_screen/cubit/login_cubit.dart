import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../repo/user_repo.dart';

import 'package:vestium/repo/user_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepo userRepo;

  LoginCubit(this.userRepo) : super(const LoginInitial());

  // ------------------------
  // LOGIN METHODS
  // ------------------------

  /// Main login method with email and password
  Future<void> login({required String email, required String password}) async {
    // Emit loading state
    emit(const LoginLoading());

    try {
      // Call the repository to authenticate the user
      final user = await userRepo.signIn(email, password);

      // Emit success state with the authenticated user
      emit(LoginSuccess(user));
    } catch (e) {
      // Emit error state with the error message
      emit(LoginError(e.toString()));
    }
  }

  // ------------------------
  // FORM VALIDATION METHODS
  // ------------------------

  /// Validate the login form
  void validateForm({required String email, required String password}) {
    // Check for empty fields
    if (email.isEmpty || password.isEmpty) {
      emit(const LoginFormInvalid('Please fill all fields'));
      return;
    }

    // Validate email format
    if (!email.contains('@') || !email.contains('.')) {
      emit(const LoginFormInvalid('Please enter a valid email address'));
      return;
    }

    // Validate password is not empty
    if (password.isEmpty) {
      emit(const LoginFormInvalid('Please enter your password'));
      return;
    }

    // If all validations pass
    emit(const LoginFormValid());
  }

  // ------------------------
  // STATE MANAGEMENT METHODS
  // ------------------------

  /// Clear any error states and return to initial state
  void clearError() {
    if (state is LoginError || state is LoginFormInvalid) {
      emit(const LoginInitial());
    }
  }

  /// Reset the cubit to initial state
  void reset() {
    emit(const LoginInitial());
  }
}
