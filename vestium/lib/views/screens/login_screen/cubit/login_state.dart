import 'package:equatable/equatable.dart';
// import '../../../databases/db_models.dart';
import 'package:vestium/databases/db_models.dart';
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

// Initial state - when the login screen first loads
class LoginInitial extends LoginState {
  const LoginInitial();
}

// Loading state - when login request is in progress
class LoginLoading extends LoginState {
  const LoginLoading();
}

// Success state - when login is successful
class LoginSuccess extends LoginState {
  final User user;
  
  const LoginSuccess(this.user);

  @override
  List<Object> get props => [user];
}

// Error state - when login fails
class LoginError extends LoginState {
  final String message;
  
  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}

// Form validation states
class LoginFormValid extends LoginState {
  const LoginFormValid();
}

class LoginFormInvalid extends LoginState {
  final String errorMessage;
  
  const LoginFormInvalid(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}