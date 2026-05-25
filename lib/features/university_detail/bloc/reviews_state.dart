// import 'package:equatable/equatable.dart';

// enum ReviewsStatus { initial, loading, ready, failure }

// /// Модель одного отзыва.
// class UniversityReview extends Equatable {
//   final String id;
//   final String authorName;
//   final String? authorPhotoUrl;
//   final double rating;
//   final String text;
//   final int year;
//   final String speciality;
//   final DateTime createdAt;

//   const UniversityReview({
//     required this.id,
//     required this.authorName,
//     this.authorPhotoUrl,
//     required this.rating,
//     required this.text,
//     required this.year,
//     required this.speciality,
//     required this.createdAt,
//   });

//   /// Создаёт модель из документа Firestore.
//   factory UniversityReview.fromFirestore(
//     String id,
//     Map<String, dynamic> data,
//   ) {
//     return UniversityReview(
//       id: id,
//       authorName: data['authorName'] as String? ?? 'Аноним',
//       authorPhotoUrl: data['authorPhotoUrl'] as String?,
//       rating: (data['rating'] as num?)?.toDouble() ?? 0,
//       text: data['text'] as String? ?? '',
//       year: (data['year'] as num?)?.toInt() ?? DateTime.now().year,
//       speciality: data['speciality'] as String? ?? '—',
//       createdAt: data['createdAt'] != null
//           ? DateTime.tryParse(data['createdAt'] as String) ?? DateTime.now()
//           : DateTime.now(),
//     );
//   }

//   /// Конвертирует в Map для сохранения в Firestore.
//   Map<String, dynamic> toFirestore() => {
//         'authorName': authorName,
//         'authorPhotoUrl': authorPhotoUrl,
//         'rating': rating,
//         'text': text,
//         'year': year,
//         'speciality': speciality,
//         'createdAt': createdAt.toIso8601String(),
//       };

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

// /// Состояние экрана отзывов.
// class ReviewsState extends Equatable {
//   final ReviewsStatus status;
//   final String universityId;
//   final String universityName;
//   final List<UniversityReview> reviews;
//   final String? error;

//   const ReviewsState({
//     this.status = ReviewsStatus.initial,
//     this.universityId = '',
//     this.universityName = '',
//     this.reviews = const [],
//     this.error,
//   });

//   ReviewsState copyWith({
//     ReviewsStatus? status,
//     String? universityId,
//     String? universityName,
//     List<UniversityReview>? reviews,
//     String? error,
//   }) =>
//       ReviewsState(
//         status: status ?? this.status,
//         universityId: universityId ?? this.universityId,
//         universityName: universityName ?? this.universityName,
//         reviews: reviews ?? this.reviews,
//         error: error,
//       );

//   @override
//   List<Object?> get props =>
//       [status, universityId, universityName, reviews, error];
// }

import 'package:equatable/equatable.dart';

enum ReviewsStatus { initial, loading, ready, failure }

class UniversityReview extends Equatable {
  final String id;
  final String authorUid;    // UID из Firebase Auth — для определения владельца
  final String authorName;
  final String? authorPhotoUrl;
  final double rating;
  final String text;
  final int year;
  final String speciality;
  final DateTime createdAt;

  const UniversityReview({
    required this.id,
    required this.authorUid,
    required this.authorName,
    this.authorPhotoUrl,
    required this.rating,
    required this.text,
    required this.year,
    required this.speciality,
    required this.createdAt,
  });

  factory UniversityReview.fromFirestore(String id, Map<String, dynamic> data) {
    return UniversityReview(
      id: id,
      authorUid: data['authorUid'] as String? ?? '',
      authorName: data['authorName'] as String? ?? 'Аноним',
      authorPhotoUrl: data['authorPhotoUrl'] as String?,
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      text: data['text'] as String? ?? '',
      year: (data['year'] as num?)?.toInt() ?? DateTime.now().year,
      speciality: data['speciality'] as String? ?? '—',
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'authorUid': authorUid,
        'authorName': authorName,
        'authorPhotoUrl': authorPhotoUrl,
        'rating': rating,
        'text': text,
        'year': year,
        'speciality': speciality,
        'createdAt': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props =>
      [id, authorUid, authorName, authorPhotoUrl, rating, text, year, speciality, createdAt];
}

class ReviewsState extends Equatable {
  final ReviewsStatus status;
  final String universityId;
  final String universityName;
  final List<UniversityReview> reviews;
  final String? error;

  const ReviewsState({
    this.status = ReviewsStatus.initial,
    this.universityId = '',
    this.universityName = '',
    this.reviews = const [],
    this.error,
  });

  ReviewsState copyWith({
    ReviewsStatus? status,
    String? universityId,
    String? universityName,
    List<UniversityReview>? reviews,
    String? error,
  }) =>
      ReviewsState(
        status: status ?? this.status,
        universityId: universityId ?? this.universityId,
        universityName: universityName ?? this.universityName,
        reviews: reviews ?? this.reviews,
        error: error,
      );

  @override
  List<Object?> get props =>
      [status, universityId, universityName, reviews, error];
}