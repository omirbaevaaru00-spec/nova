import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/university/university_repository.dart';
import 'university_detail_state.dart';

class UniversityDetailCubit extends Cubit<UniversityDetailState> {
  UniversityDetailCubit({required UniversityRepository universityRepository})
      : _repository = universityRepository,
        super(const UniversityDetailState());

  final UniversityRepository _repository;

  Future<void> load(String id) async {
    emit(state.copyWith(status: UniversityDetailStatus.loading));
    final uni = await _repository.getById(id);
    emit(
      uni == null
          ? state.copyWith(status: UniversityDetailStatus.notFound)
          : state.copyWith(
              status: UniversityDetailStatus.ready,
              university: uni,
            ),
    );
  }

  void selectTab(UniversityDetailTab tab) =>
      emit(state.copyWith(tab: tab));
}
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';

// import '../../../data/university/university_repository.dart';
// import 'university_detail_state.dart';

// class UniversityDetailCubit extends Cubit<UniversityDetailState> {
//   UniversityDetailCubit({required UniversityRepository universityRepository})
//       : _repository = universityRepository,
//         super(const UniversityDetailState());

//   final UniversityRepository _repository;
//   final _log = Logger();

//   /// Загружает данные университета по [id].
//   Future<void> load(String id) async {
//     emit(state.copyWith(status: UniversityDetailStatus.loading));
//     try {
//       final uni = await _repository.getById(id);
//       emit(
//         uni == null
//             ? state.copyWith(status: UniversityDetailStatus.notFound)
//             : state.copyWith(
//                 status: UniversityDetailStatus.ready,
//                 university: uni,
//               ),
//       );
//     } catch (e, st) {
//       _log.e('Ошибка загрузки университета', error: e, stackTrace: st);
//       emit(state.copyWith(
//         status: UniversityDetailStatus.notFound,
//         errorMessage: e.toString(),
//       ));
//     }
//   }

//   /// Переключает активную вкладку; при первом открытии вкладки отзывов —
//   /// подгружает отзывы.
//   Future<void> selectTab(UniversityDetailTab tab) async {
//     emit(state.copyWith(tab: tab));
//     if (tab == UniversityDetailTab.reviews &&
//         state.reviews.isEmpty &&
//         !state.reviewsLoading) {
//       await _loadReviews();
//     }
//   }

//   /// Загружает отзывы через репозиторий.
//   /// Сейчас репозиторий не имеет метода getReviews — используем stub-данные
//   /// до момента, когда метод появится в UniversityRepository.
//   Future<void> _loadReviews() async {
//     if (state.university == null) return;
//     emit(state.copyWith(reviewsLoading: true));
//     try {
//       // TODO: заменить на _repository.getReviews(state.university!.id)
//       //       когда метод будет добавлен в UniversityRepository.
//       await Future.delayed(const Duration(milliseconds: 600));
//       final stubReviews = _stubReviews();
//       emit(state.copyWith(reviews: stubReviews, reviewsLoading: false));
//     } catch (e, st) {
//       _log.e('Ошибка загрузки отзывов', error: e, stackTrace: st);
//       emit(state.copyWith(reviewsLoading: false, errorMessage: e.toString()));
//     }
//   }

//   /// Добавляет новый отзыв (оптимистично — сразу в список).
//   void submitReview(UniversityReview review) {
//     final updated = [review, ...state.reviews];
//     emit(state.copyWith(reviews: updated));
//     // TODO: сохранить через _repository.addReview(review)
//   }

//   /// Временные stub-отзывы для разработки UI.
//   List<UniversityReview> _stubReviews() => [
//         UniversityReview(
//           id: '1',
//           authorName: 'Айгерим С.',
//           authorPhotoUrl: null,
//           rating: 4.5,
//           text:
//               'Хороший университет, преподаватели отзывчивые. '
//               'Инфраструктура кампуса на высоком уровне.',
//           year: 2022,
//           speciality: 'Информатика',
//           createdAt: DateTime(2024, 3, 10),
//         ),
//         UniversityReview(
//           id: '2',
//           authorName: 'Нурлан А.',
//           authorPhotoUrl: null,
//           rating: 3.0,
//           text:
//               'Программа хорошая, но бюрократия иногда раздражает. '
//               'В целом доволен выбором.',
//           year: 2021,
//           speciality: 'Экономика',
//           createdAt: DateTime(2024, 1, 5),
//         ),
//         UniversityReview(
//           id: '3',
//           authorName: 'Дина Б.',
//           authorPhotoUrl: null,
//           rating: 5.0,
//           text:
//               'Лучший выбор! Международные связи, стажировки за рубежом — '
//               'всё на высшем уровне.',
//           year: 2023,
//           speciality: 'Международные отношения',
//           createdAt: DateTime(2024, 5, 20),
//         ),
//       ];
// }