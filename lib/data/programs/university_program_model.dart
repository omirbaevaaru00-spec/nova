// import 'package:cloud_firestore/cloud_firestore.dart';

// /// Модель программы обучения университета.
// ///
// /// Хранится в подколлекции `universities/{universityId}/programs`.
// class UniversityProgram {
//   const UniversityProgram({
//     required this.id,
//     required this.name,
//     required this.degree,
//     required this.duration,
//     required this.costRange,
//     required this.languages,
//     required this.description,
//     this.jobs = const [],
//   });

//   final String id;
//   final String name;
//   final String degree;
//   final String duration;
//   final String costRange;
//   final List<String> languages;
//   final String description;
//   final List<String> jobs;

//   factory UniversityProgram.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     final d = doc.data()!;
//     return UniversityProgram(
//       id: doc.id,
//       name: d['name'] as String? ?? '',
//       degree: d['degree'] as String? ?? '',
//       duration: d['duration'] as String? ?? '',
//       costRange: d['costRange'] as String? ?? '',
//       languages: List<String>.from((d['languages'] as List?) ?? []),
//       description: d['description'] as String? ?? '',
//       jobs: List<String>.from((d['jobs'] as List?) ?? []),
//     );
//   }

//   Map<String, dynamic> toFirestore() => {
//         'name': name,
//         'degree': degree,
//         'duration': duration,
//         'costRange': costRange,
//         'languages': languages,
//         'description': description,
//         'jobs': jobs,
//       };
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stiky/data/university/localized_string.dart';

/// Модель программы обучения университета с поддержкой трёх языков.
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

  /// Название программы на трёх языках.
  final LocalizedString name;

  /// Степень: Бакалавриат / Магистратура / Колледж
  final LocalizedString degree;

  final String duration;
  final String costRange;
  final List<String> languages;

  /// Описание программы на трёх языках.
  final LocalizedString description;

  /// Профессии после окончания на трёх языках.
  final List<LocalizedString> jobs;

  factory UniversityProgram.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;

    // Поддержка старого формата (String) и нового (Map)
    LocalizedString _locStr(dynamic val) {
      if (val is Map) return LocalizedString.fromMap(Map<String, dynamic>.from(val));
      if (val is String) return LocalizedString.fromString(val);
      return const LocalizedString(ru: '', en: '', kk: '');
    }

    return UniversityProgram(
      id: doc.id,
      name: _locStr(d['name']),
      degree: _locStr(d['degree']),
      duration: d['duration'] as String? ?? '',
      costRange: d['costRange'] as String? ?? '',
      languages: List<String>.from((d['languages'] as List?) ?? []),
      description: _locStr(d['description']),
      jobs: ((d['jobs'] as List?) ?? [])
          .map((e) => e is Map
              ? LocalizedString.fromMap(Map<String, dynamic>.from(e))
              : LocalizedString.fromString(e.toString()))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name.toMap(),
        'degree': degree.toMap(),
        'duration': duration,
        'costRange': costRange,
        'languages': languages,
        'description': description.toMap(),
        'jobs': jobs.map((j) => j.toMap()).toList(),
      };
}