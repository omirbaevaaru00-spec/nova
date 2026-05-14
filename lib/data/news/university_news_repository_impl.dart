import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:stiky/core/services/firebase_service.dart';
import 'package:stiky/data/news/university_news_model.dart';
import 'package:stiky/data/news/university_news_repository.dart';

/// Реализация [UniversityNewsRepository].
///
/// Подколлекция: `universities/{universityId}/news`.
class UniversityNewsRepositoryImpl implements UniversityNewsRepository {
  UniversityNewsRepositoryImpl(this._firebase);

  final FirebaseService _firebase;
  final _log = Logger();

  @override
  Future<List<UniversityNews>> getNews(String universityId) async {
    try {
      final snap = await _firebase.firestore
          .collection('universities')
          .doc(universityId)
          .collection('news')
          .orderBy('publishedAt', descending: true)
          .get();
      return snap.docs
          .map((doc) => UniversityNews.fromFirestore(doc))
          .toList();
    } catch (e, st) {
      _log.e('getNews($universityId) failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> seedNews(
    String universityId,
    List<UniversityNews> news,
  ) async {
    _log.i('seedNews: $universityId — ${news.length} новостей');
    try {
      final batch = _firebase.firestore.batch();
      for (final n in news) {
        final ref = _firebase.firestore
            .collection('universities')
            .doc(universityId)
            .collection('news')
            .doc(n.id.isEmpty ? null : n.id);
        batch.set(ref, n.toFirestore(), SetOptions(merge: true));
      }
      await batch.commit();
      _log.i('seedNews завершён: $universityId');
    } catch (e, st) {
      _log.e('seedNews($universityId) failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}