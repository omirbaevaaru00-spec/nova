import 'package:cloud_firestore/cloud_firestore.dart';

/// Модель новости университета.
///
/// Хранится в подколлекции `universities/{universityId}/news`.
class UniversityNews {
  const UniversityNews({
    required this.id,
    required this.title,
    required this.body,
    required this.publishedAt,
    this.imageUrl = '',
  });

  final String id;
  final String title;
  final String body;
  final DateTime publishedAt;
  final String imageUrl;

  factory UniversityNews.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return UniversityNews(
      id: doc.id,
      title: d['title'] as String? ?? '',
      body: d['body'] as String? ?? '',
      publishedAt: (d['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrl: d['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'title': title,
        'body': body,
        'publishedAt': Timestamp.fromDate(publishedAt),
        'imageUrl': imageUrl,
      };
}