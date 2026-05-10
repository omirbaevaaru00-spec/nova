import 'package:equatable/equatable.dart';

import '../../../data/university/university_model.dart';

enum ProfileStatus { initial, loading, ready, unauthenticated, failure }

class ProfileState extends Equatable {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.name = '',
    this.city = '',
    this.photoUrl,
    this.gpa,
    this.ielts,
    this.ent,
    this.favorites = const [],
  });

  final ProfileStatus status;
  final String name;
  final String city;
  final String? photoUrl;
  final num? gpa;
  final num? ielts;
  final num? ent;
  final List<University> favorites;

  ProfileState copyWith({
    ProfileStatus? status,
    String? name,
    String? city,
    String? photoUrl,
    num? gpa,
    num? ielts,
    num? ent,
    List<University>? favorites,
  }) {
    return ProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      city: city ?? this.city,
      photoUrl: photoUrl ?? this.photoUrl,
      gpa: gpa ?? this.gpa,
      ielts: ielts ?? this.ielts,
      ent: ent ?? this.ent,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props =>
      [status, name, city, photoUrl, gpa, ielts, ent, favorites];
}
