import 'package:equatable/equatable.dart';

enum ProfileSettingsStatus {
  initial,
  loading,
  ready,
  saving,
  uploadingPhoto,
  saved,
  saveError,
  photoError,
  signedOut,
}

class ProfileSettingsState extends Equatable {
  const ProfileSettingsState({
    this.status = ProfileSettingsStatus.initial,
    this.name = '',
    this.city = '',
    this.gpa = '',
    this.ielts = '',
    this.ent = '',
    this.interests = const [],
  });

  final ProfileSettingsStatus status;
  final String name;
  final String city;
  final String gpa;
  final String ielts;
  final String ent;
  final List<String> interests;

  ProfileSettingsState copyWith({
    ProfileSettingsStatus? status,
    String? name,
    String? city,
    String? gpa,
    String? ielts,
    String? ent,
    List<String>? interests,
  }) {
    return ProfileSettingsState(
      status: status ?? this.status,
      name: name ?? this.name,
      city: city ?? this.city,
      gpa: gpa ?? this.gpa,
      ielts: ielts ?? this.ielts,
      ent: ent ?? this.ent,
      interests: interests ?? this.interests,
    );
  }

  @override
  List<Object?> get props =>
      [status, name, city, gpa, ielts, ent, interests];
}
