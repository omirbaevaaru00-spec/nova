// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';

// import '../../../core/services/firebase_service.dart';
// import '../../../data/university/university_repository.dart';
// import 'reviews_state.dart';

// /// Cubit экрана отзывов.
// /// Загружает список отзывов из Firestore и сохраняет новые.
// class ReviewsCubit extends Cubit<ReviewsState> {
//   final UniversityRepository _universityRepository;
//   final _log = Logger();

//   ReviewsCubit({required UniversityRepository universityRepository})
//       : _universityRepository = universityRepository,
//         super(const ReviewsState());

//   /// Загружает отзывы и название университета.
//   Future<void> load(String universityId) async {
//     emit(state.copyWith(
//       status: ReviewsStatus.loading,
//       universityId: universityId,
//     ));

//     try {
//       // Получаем название университета
//       final university =
//           await _universityRepository.fetchById(universityId);
//       final universityName = university?.name ?? '';

//       // Загружаем отзывы из Firestore
//       final snapshot = await FirebaseService.instance.firestore
//           .collection('universities')
//           .doc(universityId)
//           .collection('reviews')
//           .orderBy('createdAt', descending: true)
//           .get();

//       final reviews = snapshot.docs
//           .map((doc) =>
//               UniversityReview.fromFirestore(doc.id, doc.data()))
//           .toList();

//       emit(state.copyWith(
//         status: ReviewsStatus.ready,
//         universityName: universityName,
//         reviews: reviews,
//       ));
//     } catch (e) {
//       _log.e('ReviewsCubit.load: ошибка загрузки', error: e);
//       emit(state.copyWith(
//         status: ReviewsStatus.failure,
//         error: e.toString(),
//       ));
//     }
//   }

//   /// Сохраняет отзыв в Firestore и добавляет его в начало локального списка.
//   Future<void> submitReview(UniversityReview review) async {
//     try {
//       // Сохраняем в Firestore
//       await FirebaseService.instance.firestore
//           .collection('universities')
//           .doc(state.universityId)
//           .collection('reviews')
//           .doc(review.id)
//           .set(review.toFirestore());

//       _log.i('ReviewsCubit: отзыв сохранён (id=${review.id})');
//     } catch (e) {
//       _log.e('ReviewsCubit.submitReview: ошибка сохранения', error: e);
//       // Не блокируем UI — отзыв всё равно добавляем локально.
//     }

//     // Обновляем список локально (не ждём перезагрузки с сервера).
//     emit(state.copyWith(
//       reviews: [review, ...state.reviews],
//     ));
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/university/university_repository.dart';
import 'reviews_state.dart';

/// Cubit экрана отзывов.
class ReviewsCubit extends Cubit<ReviewsState> {
  final UniversityRepository _universityRepository;
  final _log = Logger();

  ReviewsCubit({required UniversityRepository universityRepository})
      : _universityRepository = universityRepository,
        super(const ReviewsState());

  Future<void> load(String universityId) async {
    emit(state.copyWith(
      status: ReviewsStatus.loading,
      universityId: universityId,
    ));
    try {
      final university =
          await _universityRepository.fetchById(universityId);

      // university.name теперь LocalizedString — в cubit нет context,
      // поэтому используем .ru как язык по умолчанию
      final universityName = university?.name.ru ?? '';

      final snapshot = await FirebaseService.instance.firestore
          .collection('universities')
          .doc(universityId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      final reviews = snapshot.docs
          .map((doc) =>
              UniversityReview.fromFirestore(doc.id, doc.data()))
          .toList();

      emit(state.copyWith(
        status: ReviewsStatus.ready,
        universityName: universityName,
        reviews: reviews,
      ));
    } catch (e) {
      _log.e('ReviewsCubit.load', error: e);
      emit(state.copyWith(
        status: ReviewsStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> submitReview(UniversityReview review) async {
    try {
      await FirebaseService.instance.firestore
          .collection('universities')
          .doc(state.universityId)
          .collection('reviews')
          .doc(review.id)
          .set(review.toFirestore());
      _log.i('ReviewsCubit: отзыв сохранён (id=${review.id})');
    } catch (e) {
      _log.e('ReviewsCubit.submitReview', error: e);
    }
    emit(state.copyWith(reviews: [review, ...state.reviews]));
  }

  Future<void> deleteReview(String reviewId) async {
    final updated =
        state.reviews.where((r) => r.id != reviewId).toList();
    emit(state.copyWith(reviews: updated));
    try {
      await FirebaseService.instance.firestore
          .collection('universities')
          .doc(state.universityId)
          .collection('reviews')
          .doc(reviewId)
          .delete();
      _log.i('ReviewsCubit: отзыв удалён (id=$reviewId)');
    } catch (e) {
      _log.e('ReviewsCubit.deleteReview', error: e);
      await load(state.universityId);
    }
  }
}