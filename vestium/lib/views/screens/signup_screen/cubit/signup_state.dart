import 'package:equatable/equatable.dart';
// import '../../../databases/db_models.dart';
import 'package:vestium/databases/db_models.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

// Initial state - when the signup screen first loads
class SignupInitial extends SignupState {
  const SignupInitial();
}


// Loading state - when signup request is in progress
class SignupLoading extends SignupState {
  const SignupLoading();
}


// Success state - when signup is successful
class SignupSuccess extends SignupState {
  final User user;
  
  const SignupSuccess(this.user);

  @override
  List<Object> get props => [user];
}

// Error state - when signup fails
class SignupError extends SignupState {
  final String message;
  
  const SignupError(this.message);

  @override
  List<Object> get props => [message];
}

// Email validation states
class SignupEmailAvailable extends SignupState {
  const SignupEmailAvailable();
}

class SignupEmailTaken extends SignupState {
  const SignupEmailTaken();
}

class SignupEmailChecking extends SignupState {
  const SignupEmailChecking();
}

// Form validation states
class SignupFormValid extends SignupState {
  const SignupFormValid();
}

class SignupFormInvalid extends SignupState {
  final String errorMessage;
  
  const SignupFormInvalid(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}