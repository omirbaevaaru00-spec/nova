import 'package:equatable/equatable.dart';

import '../../../data/auth/auth_failure.dart';

enum LoginStatus { idle, loading, success, phoneSoon, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.idle,
    this.identifier = '',
    this.password = '',
    this.failure,
  });

  final LoginStatus status;
  final String identifier;
  final String password;
  final AuthFailure? failure;

  bool get isPhoneSignIn =>
      identifier.trim().isNotEmpty && !identifier.contains('@');

  bool get canSubmit =>
      identifier.trim().isNotEmpty &&
      password.isNotEmpty &&
      status != LoginStatus.loading;

  LoginState copyWith({
    LoginStatus? status,
    String? identifier,
    String? password,
    AuthFailure? failure,
    bool clearFailure = false,
  }) {
    return LoginState(
      status: status ?? this.status,
      identifier: identifier ?? this.identifier,
      password: password ?? this.password,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, identifier, password, failure];
}
