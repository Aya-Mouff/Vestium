import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vestium/repo/user_repo.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final UserRepo _userRepo = UserRepo();

  ResetPasswordCubit() : super(const ResetPasswordInitial());

  Future<void> sendResetLink(String email) async {
    if (email.isEmpty) {
      emit(const ResetPasswordError('Please enter an email address'));
      return;
    }

    if (!_isValidEmail(email)) {
      emit(const ResetPasswordError('Please enter a valid email address'));
      return;
    }

    emit(const ResetPasswordLoading());

    try {
      // Check if user exists with this email
      final user = await _userRepo.getByEmail(email);
      
      if (user == null) {
        // For security, we still show success message even if user doesn't exist
        emit(const ResetPasswordLinkSent());
      } else {
        // In a real app, this would send an email
        // For now, we just emit success
        emit(const ResetPasswordLinkSent());
      }
    } catch (e) {
      emit(ResetPasswordError('Failed to send reset link: ${e.toString()}'));
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
}
