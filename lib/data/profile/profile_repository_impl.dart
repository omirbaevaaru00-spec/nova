import '../../core/services/firebase_service.dart';
import 'profile_model.dart';
import 'profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._firebase);

  final FirebaseService _firebase;

  @override
  Future<UserProfile> load() async {
    final uid = _firebase.currentUid;
    if (uid == null) return UserProfile.empty;
    try {
      final data = await _firebase.getUserData(uid);
      return UserProfile.fromMap(data ?? const {});
    } catch (_) {
      return UserProfile.empty;
    }
  }

  @override
  Future<void> saveScores({double? gpa, double? ielts, int? ent}) async {
    final uid = _firebase.currentUid;
    if (uid == null) return;
    if (gpa != null) await _firebase.setUserField(uid, 'gpa', gpa);
    if (ielts != null) await _firebase.setUserField(uid, 'ielts', ielts);
    if (ent != null) await _firebase.setUserField(uid, 'ent', ent);
  }

  @override
  Future<void> createInitial({
    required String uid,
    required String name,
    required String city,
    String email = '',
    String phone = '',
    String photoUrl = '',
  }) async {
    await _firebase.mergeUserDoc(uid, {
      'uid': uid,
      'name': name,
      'city': city,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'gpa': null,
      'ielts': null,
      'ent': null,
      'favorites': [],
      'createdAt': _firebase.serverTimestamp,
    });
  }

  @override
  Future<Map<String, dynamic>?> rawData() async {
    final uid = _firebase.currentUid;
    if (uid == null) return null;
    return _firebase.getUserData(uid);
  }

  @override
  Future<void> updateProfile({
    String? name,
    String? city,
    String? photoUrl,
  }) async {
    final uid = _firebase.currentUid;
    if (uid == null) return;
    final updates = <String, dynamic>{};
    if (name != null && name.isNotEmpty) updates['name'] = name;
    if (city != null && city.isNotEmpty) updates['city'] = city;
    if (photoUrl != null && photoUrl.isNotEmpty) updates['photoUrl'] = photoUrl;
    if (updates.isEmpty) return;
    await _firebase.mergeUserDoc(uid, updates);
  }
}
