import 'profile_model.dart';

abstract class ProfileRepository {
  Future<UserProfile> load();
  Future<void> saveScores({double? gpa, double? ielts, int? ent});

  /// Создаёт первичную запись профиля пользователя в Firestore.
  Future<void> createInitial({
    required String uid,
    required String name,
    required String city,
    String email = '',
    String phone = '',
    String photoUrl = '',
  });

  Future<Map<String, dynamic>?> rawData();

  Future<void> updateProfile({String? name, String? city, String? photoUrl});
}
