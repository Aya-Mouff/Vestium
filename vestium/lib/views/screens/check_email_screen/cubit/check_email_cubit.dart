import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'check_email_state.dart';

class CheckEmailCubit extends Cubit<CheckEmailState> {
  CheckEmailCubit() : super(const CheckEmailInitial());

  void onEmailVerificationResent() {
    emit(const CheckEmailVerificationResent());
  }
}
