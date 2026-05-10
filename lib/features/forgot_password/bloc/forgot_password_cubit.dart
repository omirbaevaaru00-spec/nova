import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_failure.dart';
import '../../../data/auth/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required AuthRepository authRepository})
      : _auth = authRepository,
        super(const ForgotPasswordState());

  final AuthRepository _auth;

  void emailChanged(String value) =>
      emit(state.copyWith(email: value, clearFailure: true));

  Future<void> sendReset() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(status: ForgotPasswordStatus.loading, clearFailure: true));
    try {
      await _auth.sendPasswordReset(state.email.trim());
      emit(state.copyWith(status: ForgotPasswordStatus.sent));
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          failure: e.failure,
        ),
      );
    }
  }
}
