import 'package:equatable/equatable.dart';

import '../../../data/auth/auth_failure.dart';

enum PhoneOtpStatus { idle, verifying, resending, success, failure }

class PhoneOtpState extends Equatable {
  const PhoneOtpState({
    required this.phone,
    required this.verificationId,
    this.code = '',
    this.status = PhoneOtpStatus.idle,
    this.failure,
    this.resendSeconds = 60,
  });

  final String phone;
  final String verificationId;
  final String code;
  final PhoneOtpStatus status;
  final AuthFailure? failure;
  final int resendSeconds;

  bool get canVerify =>
      code.length == 6 && status != PhoneOtpStatus.verifying;
  bool get canResend =>
      resendSeconds <= 0 && status != PhoneOtpStatus.resending;

  PhoneOtpState copyWith({
    String? phone,
    String? verificationId,
    String? code,
    PhoneOtpStatus? status,
    AuthFailure? failure,
    int? resendSeconds,
    bool clearFailure = false,
  }) {
    return PhoneOtpState(
      phone: phone ?? this.phone,
      verificationId: verificationId ?? this.verificationId,
      code: code ?? this.code,
      status: status ?? this.status,
      failure: clearFailure ? null : (failure ?? this.failure),
      resendSeconds: resendSeconds ?? this.resendSeconds,
    );
  }

  @override
  List<Object?> get props =>
      [phone, verificationId, code, status, failure, resendSeconds];
}
