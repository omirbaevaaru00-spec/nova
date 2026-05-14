import 'package:cloud_firestore/cloud_firestore.dart';

/// Модель программы обучения университета.
///
/// Хранится в подколлекции `universities/{universityId}/programs`.
class UniversityProgram {
  const UniversityProgram({
    required this.id,
    required this.name,
    required this.degree,
    required this.duration,
    required this.costRange,
    required this.languages,
    required this.description,
    this.jobs = const [],
  });

  final String id;
  final String name;
  final String degree;
  final String duration;
  final String costRange;
  final List<String> languages;
  final String description;
  final List<String> jobs;

  factory UniversityProgram.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return UniversityProgram(
      id: doc.id,
      name: d['name'] as String? ?? '',
      degree: d['degree'] as String? ?? '',
      duration: d['duration'] as String? ?? '',
      costRange: d['costRange'] as String? ?? '',
      languages: List<String>.from((d['languages'] as List?) ?? []),
      description: d['description'] as String? ?? '',
      jobs: List<String>.from((d['jobs'] as List?) ?? []),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'degree': degree,
        'duration': duration,
        'costRange': costRange,
        'languages': languages,
        'description': description,
        'jobs': jobs,
      };
}