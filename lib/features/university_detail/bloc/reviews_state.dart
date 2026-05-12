import 'package:equatable/equatable.dart';

enum ReviewsStatus { initial, loading, ready, failure }

/// Модель одного отзыва студента
class UniversityReview extends Equatable {
  const UniversityReview({
    required this.id,
    required this.authorName,
    this.authorPhotoUrl,
    required this.rating,
    required this.text,
    required this.year,
    required this.speciality,
    required this.createdAt,
  });

  final String id;
  final String authorName;
  final String? authorPhotoUrl;

  /// Оценка от 1 до 5
  final double rating;
  final String text;

  /// Год поступления
  final int year;
  final String speciality;
  final DateTime createdAt;

  @override
  List<Object?> get props =>
      [id, authorName, authorPhotoUrl, rating, text, year, speciality, createdAt];
}

class ReviewsState extends Equatable {
  const ReviewsState({
    this.status = ReviewsStatus.initial,
    this.universityName = '',
    this.reviews = const [],
    this.errorMessage,
  });

  final ReviewsStatus status;
  final String universityName;
  final List<UniversityReview> reviews;
  final String? errorMessage;

  ReviewsState copyWith({
    ReviewsStatus? status,
    String? universityName,
    List<UniversityReview>? reviews,
    String? errorMessage,
  }) {
    return ReviewsState(
      status: status ?? this.status,
      universityName: universityName ?? this.universityName,
      reviews: reviews ?? this.reviews,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, universityName, reviews, errorMessage];
}