import 'package:equatable/equatable.dart';

import '../../../data/university/university_model.dart';

enum UniversityDetailStatus { initial, loading, ready, notFound }

enum UniversityDetailTab { description, programs, news }

class UniversityDetailState extends Equatable {
  const UniversityDetailState({
    this.status = UniversityDetailStatus.initial,
    this.university,
    this.tab = UniversityDetailTab.description,
  });

  final UniversityDetailStatus status;
  final University? university;
  final UniversityDetailTab tab;

  UniversityDetailState copyWith({
    UniversityDetailStatus? status,
    University? university,
    UniversityDetailTab? tab,
  }) {
    return UniversityDetailState(
      status: status ?? this.status,
      university: university ?? this.university,
      tab: tab ?? this.tab,
    );
  }

  @override
  List<Object?> get props => [status, university, tab];
}
// import 'package:equatable/equatable.dart';

// import '../../../data/university/university_model.dart';

// enum UniversityDetailStatus { initial, loading, ready, notFound }

// /// Вкладки на странице университета
// enum UniversityDetailTab { description, programs, news, reviews }

// /// Модель одного отзыва студента
// class UniversityReview extends Equatable {
//   const UniversityReview({
//     required this.id,
//     required this.authorName,
//     required this.authorPhotoUrl,
//     required this.rating,
//     required this.text,
//     required this.year,
//     required this.speciality,
//     required this.createdAt,
//   });

//   final String id;
//   final String authorName;
//   final String? authorPhotoUrl;

//   /// Оценка от 1 до 5
//   final double rating;
//   final String text;

//   /// Год поступления
//   final int year;
//   final String speciality;
//   final DateTime createdAt;

//   @override
//   List<Object?> get props => [
//         id,
//         authorName,
//         authorPhotoUrl,
//         rating,
//         text,
//         year,
//         speciality,
//         createdAt,
//       ];
// }

// class UniversityDetailState extends Equatable {
//   const UniversityDetailState({
//     this.status = UniversityDetailStatus.initial,
//     this.university,
//     this.tab = UniversityDetailTab.description,
//     this.reviews = const [],
//     this.reviewsLoading = false,
//     this.errorMessage,
//   });

//   final UniversityDetailStatus status;
//   final University? university;
//   final UniversityDetailTab tab;
//   final List<UniversityReview> reviews;
//   final bool reviewsLoading;
//   final String? errorMessage;

//   UniversityDetailState copyWith({
//     UniversityDetailStatus? status,
//     University? university,
//     UniversityDetailTab? tab,
//     List<UniversityReview>? reviews,
//     bool? reviewsLoading,
//     String? errorMessage,
//   }) {
//     return UniversityDetailState(
//       status: status ?? this.status,
//       university: university ?? this.university,
//       tab: tab ?? this.tab,
//       reviews: reviews ?? this.reviews,
//       reviewsLoading: reviewsLoading ?? this.reviewsLoading,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         status,
//         university,
//         tab,
//         reviews,
//         reviewsLoading,
//         errorMessage,
//       ];
// }