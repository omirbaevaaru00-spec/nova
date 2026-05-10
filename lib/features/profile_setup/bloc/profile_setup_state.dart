import 'package:equatable/equatable.dart';

import '../../../data/auth/auth_failure.dart';

enum ProfileSetupStatus { idle, loading, success, failure }

class ProfileSetupState extends Equatable {
  const ProfileSetupState({
    this.email,
    this.phone,
    this.name = '',
    this.city = '',
    this.password = '',
    this.status = ProfileSetupStatus.idle,
    this.failure,
  });

  final String? email;
  final String? phone;
  final String name;
  final String city;
  final String password;
  final ProfileSetupStatus status;
  final AuthFailure? failure;

  bool get isEmailFlow => email != null && email!.isNotEmpty;

  bool get canContinue {
    if (status == ProfileSetupStatus.loading) return false;
    final base = name.trim().isNotEmpty && city.trim().isNotEmpty;
    return isEmailFlow ? base && password.length >= 6 : base;
  }

  ProfileSetupState copyWith({
    String? email,
    String? phone,
    String? name,
    String? city,
    String? password,
    ProfileSetupStatus? status,
    AuthFailure? failure,
    bool clearFailure = false,
  }) {
    return ProfileSetupState(
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      city: city ?? this.city,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props =>
      [email, phone, name, city, password, status, failure];
}
