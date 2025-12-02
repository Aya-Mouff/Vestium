part of 'check_email_cubit.dart';

abstract class CheckEmailState extends Equatable {
  const CheckEmailState();

  @override
  List<Object?> get props => [];
}

class CheckEmailInitial extends CheckEmailState {
  const CheckEmailInitial();
}

class CheckEmailVerificationResent extends CheckEmailState {
  const CheckEmailVerificationResent();
}
