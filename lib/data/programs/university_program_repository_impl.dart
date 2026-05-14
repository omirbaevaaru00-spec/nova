import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:stiky/core/services/firebase_service.dart';
import 'package:stiky/data/programs/university_program_model.dart';
import 'package:stiky/data/programs/university_program_repository.dart';

/// Реализация [UniversityProgramRepository].
///
/// Подколлекция: `universities/{universityId}/programs`.
class UniversityProgramRepositoryImpl implements UniversityProgramRepository {
  UniversityProgramRepositoryImpl(this._firebase);

  final FirebaseService _firebase;
  final _log = Logger();

  @override
  Future<List<UniversityProgram>> getPrograms(String universityId) async {
    try {
      final snap = await _firebase.firestore
          .collection('universities')
          .doc(universityId)
          .collection('programs')
          .orderBy('name')
          .get();
      return snap.docs
          .map((doc) => UniversityProgram.fromFirestore(doc))
          .toList();
    } catch (e, st) {
      _log.e('getPrograms($universityId) failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> seedPrograms(
    String universityId,
    List<UniversityProgram> programs,
  ) async {
    _log.i('seedPrograms: $universityId — ${programs.length} программ');
    try {
      final batch = _firebase.firestore.batch();
      for (final p in programs) {
        final ref = _firebase.firestore
            .collection('universities')
            .doc(universityId)
            .collection('programs')
            .doc(p.id.isEmpty ? null : p.id);
        batch.set(ref, p.toFirestore(), SetOptions(merge: true));
      }
      await batch.commit();
      _log.i('seedPrograms завершён: $universityId');
    } catch (e, st) {
      _log.e('seedPrograms($universityId) failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}