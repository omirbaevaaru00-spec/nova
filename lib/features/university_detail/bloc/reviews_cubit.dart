import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../data/university/university_repository.dart';
import 'reviews_state.dart';

/// Cubit отдельного экрана отзывов.
class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit({required UniversityRepository universityRepository})
      : _repository = universityRepository,
        super(const ReviewsState());

  final UniversityRepository _repository;
  final _log = Logger();

  /// Загружает название университета и список отзывов по [universityId].
  Future<void> load(String universityId) async {
    emit(state.copyWith(status: ReviewsStatus.loading));
    try {
      final uni = await _repository.getById(universityId);
      // TODO: заменить stub на _repository.getReviews(universityId)
      await Future.delayed(const Duration(milliseconds: 500));
      emit(state.copyWith(
        status: ReviewsStatus.ready,
        universityName: uni?.name ?? '',
        reviews: _stubReviews(),
      ));
    } catch (e, st) {
      _log.e('Ошибка загрузки отзывов', error: e, stackTrace: st);
      emit(state.copyWith(
        status: ReviewsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Добавляет отзыв оптимистично (сразу в начало списка).
  void submitReview(UniversityReview review) {
    emit(state.copyWith(reviews: [review, ...state.reviews]));
    // TODO: сохранить через _repository.addReview(review)
  }

  List<UniversityReview> _stubReviews() => [
        UniversityReview(
          id: '1',
          authorName: 'Айгерим С.',
          rating: 4.5,
          text: 'Хороший университет, преподаватели отзывчивые. '
              'Инфраструктура кампуса на высоком уровне.',
          year: 2022,
          speciality: 'Информатика',
          createdAt: DateTime(2024, 3, 10),
        ),
        UniversityReview(
          id: '2',
          authorName: 'Нурлан А.',
          rating: 3.0,
          text: 'Программа хорошая, но бюрократия иногда раздражает. '
              'В целом доволен выбором.',
          year: 2021,
          speciality: 'Экономика',
          createdAt: DateTime(2024, 1, 5),
        ),
        UniversityReview(
          id: '3',
          authorName: 'Дина Б.',
          rating: 5.0,
          text: 'Лучший выбор! Международные связи, стажировки — '
              'всё на высшем уровне.',
          year: 2023,
          speciality: 'Международные отношения',
          createdAt: DateTime(2024, 5, 20),
        ),
      ];
}