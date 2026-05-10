import 'package:equatable/equatable.dart';

import '../../../data/auth/auth_failure.dart';

enum ForgotPasswordStatus { idle, loading, sent, failure }

class ForgotPasswordState extends Equatable {
  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.idle,
    this.email = '',
    this.failure,
  });

  final ForgotPasswordStatus status;
  final String email;
  final AuthFailure? failure;

  bool get canSubmit =>
      email.trim().isNotEmpty && status != ForgotPasswordStatus.loading;

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? email,
    AuthFailure? failure,
    bool clearFailure = false,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, email, failure];
}
