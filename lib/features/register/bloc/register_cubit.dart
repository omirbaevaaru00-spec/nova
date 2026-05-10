import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_failure.dart';
import '../../../data/auth/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required AuthRepository authRepository})
      : _auth = authRepository,
        super(const RegisterState());

  final AuthRepository _auth;

  void setMode(RegisterMode mode) =>
      emit(state.copyWith(mode: mode, clearFailure: true));

  void phoneChanged(String value) =>
      emit(state.copyWith(phone: value, clearFailure: true));

  void emailChanged(String value) =>
      emit(state.copyWith(email: value, clearFailure: true));

  Future<void> proceed() async {
    if (!state.canProceed) return;
    emit(state.copyWith(status: RegisterStatus.loading, clearFailure: true));
    if (state.mode == RegisterMode.email) {
      await _proceedEmail();
    } else {
      await _proceedPhone();
    }
  }

  Future<void> _proceedEmail() async {
    final existence = await _auth.probeEmail(state.email.trim());
    emit(
      state.copyWith(
        status: switch (existence) {
          EmailExistence.notFound => RegisterStatus.needsProfileSetup,
          EmailExistence.existsWrongPassword ||
          EmailExistence.exists =>
            RegisterStatus.needsLogin,
        },
      ),
    );
  }

  Future<void> _proceedPhone() async {
    try {
      await _auth.verifyPhone(
        phoneNumber: state.fullPhone,
        onEvent: (event) => switch (event) {
          SmsCodeSent(:final verificationId) => emit(
              state.copyWith(
                status: RegisterStatus.smsSent,
                verificationId: verificationId,
              ),
            ),
          PhoneAutoCompleted() =>
            emit(state.copyWith(status: RegisterStatus.authenticated)),
          PhoneVerificationError(:final failure) => emit(
              state.copyWith(
                status: RegisterStatus.failure,
                failure: failure,
              ),
            ),
        },
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          failure: AuthFailure.unknown,
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: RegisterStatus.loading, clearFailure: true));
    try {
      final result = await _auth.signInWithGoogle();
      emit(
        state.copyWith(
          status: result == GoogleSignInResult.existing
              ? RegisterStatus.authenticated
              : RegisterStatus.needsProfileSetup,
        ),
      );
    } on AuthException catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure, failure: e.failure));
    }
  }
}
