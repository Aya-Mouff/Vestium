part of 'account_manager_cubit.dart';

/// Base state for AccountManagerCubit
abstract class AccountManagerState extends Equatable {
  const AccountManagerState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AccountManagerInitial extends AccountManagerState {
  const AccountManagerInitial();
}

/// Loading state
class AccountManagerLoading extends AccountManagerState {
  final String message;

  const AccountManagerLoading({this.message = 'Loading...'});

  @override
  List<Object?> get props => [message];
}

/// Loaded state - user data successfully loaded
class AccountManagerLoaded extends AccountManagerState {
  final User user;

  const AccountManagerLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Updating state - one of the user fields is being updated
class AccountManagerUpdating extends AccountManagerState {
  final User user;
  final String updateType; // 'email', 'password', 'fullName'
  final String message;

  const AccountManagerUpdating({
    required this.user,
    required this.updateType,
    this.message = 'Updating...',
  });

  @override
  List<Object?> get props => [user, updateType, message];
}

/// Success state - update completed successfully
class AccountManagerUpdateSuccess extends AccountManagerState {
  final User user;
  final String updateType; // 'email', 'password', 'fullName'
  final String message;

  const AccountManagerUpdateSuccess({
    required this.user,
    required this.updateType,
    required this.message,
  });

  @override
  List<Object?> get props => [user, updateType, message];
}

/// Error state
class AccountManagerError extends AccountManagerState {
  final String message;
  final String? updateType; // Which action caused the error

  const AccountManagerError({required this.message, this.updateType});

  @override
  List<Object?> get props => [message, updateType];
}
