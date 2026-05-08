import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_failure.dart';
import '../../../data/auth/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthRepository authRepository})
      : _auth = authRepository,
        super(const LoginState());

  final AuthRepository _auth;

  void identifierChanged(String value) =>
      emit(state.copyWith(identifier: value, clearFailure: true));

  void passwordChanged(String value) =>
      emit(state.copyWith(password: value, clearFailure: true));

  void prefillEmail(String email) =>
      emit(state.copyWith(identifier: email));

  Future<void> submit() async {
    if (!state.canSubmit) return;
    if (state.isPhoneSignIn) {
      emit(state.copyWith(status: LoginStatus.phoneSoon));
      return;
    }
    emit(state.copyWith(status: LoginStatus.loading, clearFailure: true));
    try {
      await _auth.signInWithEmail(
        email: state.identifier.trim(),
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success));
    } on AuthException catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, failure: e.failure));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading, clearFailure: true));
    try {
      await _auth.signInWithGoogle();
      emit(state.copyWith(status: LoginStatus.success));
    } on AuthException catch (e) {
      emit(state.copyWith(status: LoginStatus.failure, failure: e.failure));
    }
  }
}
