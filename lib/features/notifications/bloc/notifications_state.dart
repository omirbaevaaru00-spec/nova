

import 'package:equatable/equatable.dart';

enum NotificationsStatus { initial, loading, ready, failure, unauthenticated }

/// Новость университета из коллекции Firestore `universities/{id}/news`.
class UniversityNewsItem extends Equatable {
  const UniversityNewsItem({
    required this.id,
    required this.universityId,
    required this.universityName,
    this.universityLogoUrl,
    required this.title,
    this.summary = '',
    required this.publishedAt,
    this.isNew = false,
  });

  final String id;
  final String universityId;
  final String universityName;
  final String? universityLogoUrl;
  final String title;
  final String summary;
  final DateTime publishedAt;

  /// true — пользователь ещё не открывал эту новость
  final bool isNew;

  @override
  List<Object?> get props => [
        id,
        universityId,
        universityName,
        universityLogoUrl,
        title,
        summary,
        publishedAt,
        isNew,
      ];
}

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.newsItems = const [],
    this.errorMessage,
  });

  final NotificationsStatus status;
  final List<UniversityNewsItem> newsItems;
  final String? errorMessage;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<UniversityNewsItem>? newsItems,
    String? errorMessage,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      newsItems: newsItems ?? this.newsItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, newsItems, errorMessage];
}