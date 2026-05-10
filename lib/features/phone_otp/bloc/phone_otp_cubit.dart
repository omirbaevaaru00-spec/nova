import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_failure.dart';
import '../../../data/auth/auth_repository.dart';
import 'phone_otp_state.dart';

class PhoneOtpCubit extends Cubit<PhoneOtpState> {
  PhoneOtpCubit({
    required AuthRepository authRepository,
    required String phone,
    required String verificationId,
  })  : _auth = authRepository,
        super(PhoneOtpState(phone: phone, verificationId: verificationId)) {
    _startTimer();
  }

  final AuthRepository _auth;
  Timer? _timer;

  static const _resendDuration = 60;

  void codeChanged(String value) {
    emit(state.copyWith(code: value, clearFailure: true));
  }

  Future<void> verify() async {
    if (!state.canVerify) return;
    emit(state.copyWith(status: PhoneOtpStatus.verifying, clearFailure: true));
    try {
      await _auth.confirmSmsCode(
        verificationId: state.verificationId,
        smsCode: state.code,
      );
      emit(state.copyWith(status: PhoneOtpStatus.success));
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: PhoneOtpStatus.failure,
          failure: e.failure,
        ),
      );
    }
  }

  Future<void> resend() async {
    if (!state.canResend) return;
    emit(
      state.copyWith(
        status: PhoneOtpStatus.resending,
        resendSeconds: _resendDuration,
        clearFailure: true,
      ),
    );
    try {
      await _auth.verifyPhone(
        phoneNumber: state.phone,
        onEvent: (event) => switch (event) {
          SmsCodeSent(:final verificationId) => emit(
              state.copyWith(
                status: PhoneOtpStatus.idle,
                verificationId: verificationId,
              ),
            ),
          PhoneAutoCompleted() =>
            emit(state.copyWith(status: PhoneOtpStatus.success)),
          PhoneVerificationError(:final failure) => emit(
              state.copyWith(
                status: PhoneOtpStatus.failure,
                failure: failure,
              ),
            ),
        },
      );
      _startTimer();
    } catch (_) {
      emit(
        state.copyWith(
          status: PhoneOtpStatus.failure,
          failure: AuthFailure.unknown,
        ),
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendSeconds <= 0) {
        timer.cancel();
        return;
      }
      emit(state.copyWith(resendSeconds: state.resendSeconds - 1));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
