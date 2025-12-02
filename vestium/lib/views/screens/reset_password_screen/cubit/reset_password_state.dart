part of 'reset_password_cubit.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

class ResetPasswordLoading extends ResetPasswordState {
  const ResetPasswordLoading();
}

class ResetPasswordLinkSent extends ResetPasswordState {
  const ResetPasswordLinkSent();
}

class ResetPasswordError extends ResetPasswordState {
  final String message;

  const ResetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}
