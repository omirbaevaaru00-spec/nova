/// Профиль пользователя (баллы и оценки для подбора вуза).
class UserProfile {
  const UserProfile({this.gpa, this.ielts, this.ent});

  final double? gpa;
  final double? ielts;
  final int? ent;

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      gpa: double.tryParse(data['gpa']?.toString() ?? ''),
      ielts: double.tryParse(data['ielts']?.toString() ?? ''),
      ent: int.tryParse(data['ent']?.toString() ?? ''),
    );
  }

  static const empty = UserProfile();
}
