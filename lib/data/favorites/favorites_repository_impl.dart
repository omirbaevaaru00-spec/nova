import '../../core/services/firebase_service.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._firebase);

  final FirebaseService _firebase;

  @override
  Future<Set<String>> load() async {
    final uid = _firebase.currentUid;
    if (uid == null) return <String>{};
    final doc = await _firebase.userDoc(uid).get();
    final raw = doc.data()?['favorites'] as List? ?? const [];
    return raw.map((e) => e.toString()).toSet();
  }

  @override
  Future<Set<String>> toggle(String universityId) async {
    final uid = _firebase.currentUid;
    if (uid == null) throw const NotAuthenticatedException();

    final current = await load();
    final next = Set<String>.from(current);
    if (next.contains(universityId)) {
      next.remove(universityId);
    } else {
      next.add(universityId);
    }
    await _firebase.setUserField(uid, 'favorites', next.toList());
    return next;
  }
}
