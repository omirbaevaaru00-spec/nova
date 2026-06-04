// import 'package:equatable/equatable.dart';

// import '../../../data/auth/auth_failure.dart';

// enum RegisterMode { phone, email }

// enum RegisterStatus {
//   idle,
//   loading,
//   smsSent,
//   needsProfileSetup,
//   needsLogin,
//   authenticated,
//   failure,
// }

// class RegisterState extends Equatable {
//   const RegisterState({
//     this.mode = RegisterMode.phone,
//     this.phone = '',
//     this.email = '',
//     this.status = RegisterStatus.idle,
//     this.failure,
//     this.verificationId,
//   });

//   final RegisterMode mode;
//   final String phone;
//   final String email;
//   final RegisterStatus status;
//   final AuthFailure? failure;
//   final String? verificationId;

//   String get currentInput =>
//       mode == RegisterMode.phone ? phone.trim() : email.trim();

//   String get fullPhone => '+7${phone.trim()}';

//   bool get canProceed {
//     if (status == RegisterStatus.loading) return false;
//     return mode == RegisterMode.phone
//         ? phone.trim().length == 10
//         : email.trim().isNotEmpty;
//   }

//   RegisterState copyWith({
//     RegisterMode? mode,
//     String? phone,
//     String? email,
//     RegisterStatus? status,
//     AuthFailure? failure,
//     String? verificationId,
//     bool clearFailure = false,
//   }) {
//     return RegisterState(
//       mode: mode ?? this.mode,
//       phone: phone ?? this.phone,
//       email: email ?? this.email,
//       status: status ?? this.status,
//       failure: clearFailure ? null : (failure ?? this.failure),
//       verificationId: verificationId ?? this.verificationId,
//     );
//   }

//   @override
//   List<Object?> get props =>
//       [mode, phone, email, status, failure, verificationId];
// }


import 'package:equatable/equatable.dart';

import '../../../data/auth/auth_failure.dart';

// RegisterMode.phone убран — оставляем только email
enum RegisterStatus {
  idle,
  loading,
  needsProfileSetup,
  needsLogin,
  authenticated,
  failure,
}

class RegisterState extends Equatable {
  const RegisterState({
    this.email = '',
    this.status = RegisterStatus.idle,
    this.failure,
  });

  final String email;
  final RegisterStatus status;
  final AuthFailure? failure;

  String get currentInput => email.trim();

  bool get canProceed =>
      status != RegisterStatus.loading && email.trim().isNotEmpty;

  RegisterState copyWith({
    String? email,
    RegisterStatus? status,
    AuthFailure? failure,
    bool clearFailure = false,
  }) {
    return RegisterState(
      email: email ?? this.email,
      status: status ?? this.status,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [email, status, failure];
}