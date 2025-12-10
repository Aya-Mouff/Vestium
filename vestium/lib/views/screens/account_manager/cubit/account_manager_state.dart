import 'package:equatable/equatable.dart';

enum AccountManagerStatus {
  initial,
  loading,
  success,
  error,
}

class AccountManagerState extends Equatable {
  final String? fullName;
  final String? email;
  final AccountManagerStatus status;
  final String? message;

  const AccountManagerState({
    this.fullName,
    this.email,
    this.status = AccountManagerStatus.initial,
    this.message,
  });

  AccountManagerState copyWith({
    String? fullName,
    String? email,
    AccountManagerStatus? status,
    String? message,
  }) {
    return AccountManagerState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [fullName, email, status, message];
}
