
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../repo/user_repo.dart';
import 'package:vestium/repo/user_repo.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final UserRepo userRepo;

  SignupCubit(this.userRepo) : super(const SignupInitial());

  // ------------------------
  // SIGNUP METHODS
  // ------------------------

  /// Main signup method
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? username,
    String? bio,
  }) async {
    // Emit loading state
    emit(const SignupLoading());

    try {
      // Call the repository to create the user
      final user = await userRepo.signUp(
        email: email,
        password: password,
        fullName: fullName,
        username: username,
        bio: bio,
      );

      // Emit success state with the created user
      emit(SignupSuccess(user));
    } catch (e) {
      // Emit error state with the error message
      emit(SignupError(e.toString()));
    }
  }

  // ------------------------
  // EMAIL VALIDATION METHODS
  // ------------------------

  /// Check if email is available in real-time
  Future<void> checkEmailAvailability(String email) async {
    // Don't check if email is empty or invalid
    if (email.isEmpty || !email.contains('@')) {
      return;
    }

    // Emit checking state
    emit(const SignupEmailChecking());

    try {
      final isAvailable = await userRepo.isEmailAvailable(email);
      
      if (isAvailable) {
        emit(const SignupEmailAvailable());
      } else {
        emit(const SignupEmailTaken());
      }
    } catch (e) {
      // If checking fails, just go back to initial state
      emit(const SignupInitial());
    }
  }

  // ------------------------
  // FORM VALIDATION METHODS
  // ------------------------

  /// Validate the entire signup form
  void validateForm({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
  }) {
    // Check for empty required fields
    if (email.isEmpty || password.isEmpty || fullName.isEmpty) {
      emit(const SignupFormInvalid('Please fill all required fields'));
      return;
    }

    // Validate email format
    if (!email.contains('@') || !email.contains('.')) {
      emit(const SignupFormInvalid('Please enter a valid email address'));
      return;
    }

    // Validate password length
    if (password.length < 6) {
      emit(const SignupFormInvalid('Password must be at least 6 characters'));
      return;
    }

    // Validate password confirmation
    if (password != confirmPassword) {
      emit(const SignupFormInvalid('Passwords do not match'));
      return;
    }

    // If all validations pass
    emit(const SignupFormValid());
  }

  // ------------------------
  // STATE MANAGEMENT METHODS
  // ------------------------

  /// Clear any error states and return to initial state
  void clearError() {
    if (state is SignupError || state is SignupFormInvalid) {
      emit(const SignupInitial());
    }
  }

  /// Reset the cubit to initial state
  void reset() {
    emit(const SignupInitial());
  }

  /// Clear email validation states
  void clearEmailValidation() {
    if (state is SignupEmailAvailable || state is SignupEmailTaken || state is SignupEmailChecking) {
      emit(const SignupInitial());
    }
  }
}