import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:stiky/core/services/firebase_service.dart';
import 'package:stiky/data/university/university_model.dart';
import 'package:stiky/data/university/university_repository.dart';

/// Firestore-реализация [UniversityRepository].
///
/// Коллекция: `universities`.
/// Подколлекции `news` и `programs` читаются отдельными репозиториями.
class UniversityRepositoryImpl implements UniversityRepository {
  final FirebaseService _firebase;
  final _log = Logger();

  static const _col = 'universities';

  UniversityRepositoryImpl(this._firebase);

  @override
  Future<List<University>> getAll() async {
    try {
      final snap = await _firebase.firestore
          .collection(_col)
          .orderBy('name')
          .get();
      return snap.docs
          .map((doc) => University.fromFirestore(doc))
          .toList();
    } catch (e, st) {
      _log.e('getAll failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<University?> getById(String id) async {
    try {
      final doc =
          await _firebase.firestore.collection(_col).doc(id).get();
      if (!doc.exists) return null;
      return University.fromFirestore(doc);
    } catch (e, st) {
      _log.e('getById($id) failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Алиас для [getById] — используется в ReviewsCubit.
  @override
  Future<University?> fetchById(String id) => getById(id);

  @override
  Future<List<University>> getByTags(Set<String> tags) async {
    if (tags.isEmpty) return getAll();
    try {
      final primaryTag = tags.first;
      final snap = await _firebase.firestore
          .collection(_col)
          .where('tags', arrayContains: primaryTag)
          .get();

      final results =
          snap.docs.map((doc) => University.fromFirestore(doc)).toList();

      if (tags.length == 1) return results;

      return results.where((u) => u.tags.any(tags.contains)).toList();
    } catch (e, st) {
      _log.e('getByTags($tags) failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> seedAll(List<University> universities) async {
    _log.i('Seed: заливка ${universities.length} университетов...');
    try {
      const chunkSize = 400;
      for (var i = 0; i < universities.length; i += chunkSize) {
        final chunk = universities.skip(i).take(chunkSize).toList();
        final batch = _firebase.firestore.batch();
        for (final u in chunk) {
          final ref = u.id.isEmpty
              ? _firebase.firestore.collection(_col).doc()
              : _firebase.firestore.collection(_col).doc(u.id);
          batch.set(ref, u.toFirestore());
        }
        await batch.commit();
        _log.i('Seed: залито ${i + chunk.length}/${universities.length}');
      }
      _log.i('Seed завершён.');
    } catch (e, st) {
      _log.e('seedAll failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> patchMissingFields(
    String id,
    Map<String, dynamic> fields,
  ) async {
    try {
      await _firebase.firestore
          .collection(_col)
          .doc(id)
          .set(fields, SetOptions(merge: true));
      _log.i('patchMissingFields($id): обновлено ${fields.keys}');
    } catch (e, st) {
      _log.e('patchMissingFields($id) failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}