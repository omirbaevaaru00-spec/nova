import 'package:cloud_firestore/cloud_firestore.dart';

/// Модель университета.
///
/// Поле [tags] совпадает с ключами интересов из квиза:
/// `it | medicine | business | grants | design | law |`
/// `pedagogy | engineering | bachelor | college | master`.
///
/// [programs] и [news] — подколлекции в Firestore, в этой модели не хранятся.
/// Они читаются отдельно через [UniversityRepository.getPrograms] и т.д.
class University {
  const University({
    required this.id,
    required this.name,
    required this.city,
    required this.type,
    required this.level,
    required this.description,
    required this.directions,
    required this.costRange,
    required this.duration,
    required this.languages,
    required this.format,
    required this.website,
    required this.instagram,
    required this.imageUrl,
    required this.logoUrl,
    this.email,
    this.phone,
    this.tags = const [],
    this.minEnt,
    this.minGpa,
    this.minIelts,
  });

  final String id;
  final String name;
  final String city;

  /// Тип учреждения: «Государственный» / «Частный».
  final String type;

  /// Уровень образования: «Бакалавриат», «Магистратура» и т.д.
  final String level;

  final String description;
  final List<String> directions;

  /// Диапазон стоимости обучения в виде строки, напр. «1 200 000 – 2 000 000 ₸/год».
  final String costRange;

  final String duration;
  final List<String> languages;
  final String format;
  final String website;
  final String instagram;
  final String imageUrl;
  final String logoUrl;

  /// Email приёмной комиссии (опционально).
  final String? email;

  /// Телефон приёмной комиссии (опционально).
  final String? phone;

  final List<String> tags;
  final int? minEnt;
  final double? minGpa;
  final double? minIelts;

  /// Создаёт модель из документа Firestore.
  ///
  /// Отсутствующие необязательные поля подставляют пустые значения по умолчанию,
  /// чтобы старые документы (без новых полей) не падали с ошибкой.
  factory University.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return University(
      id: doc.id,
      name: d['name'] as String? ?? '',
      city: d['city'] as String? ?? '',
      type: d['type'] as String? ?? '',
      level: d['level'] as String? ?? '',
      description: d['description'] as String? ?? '',
      directions: List<String>.from((d['directions'] as List?) ?? []),
      costRange: d['costRange'] as String? ?? '',
      duration: d['duration'] as String? ?? '',
      languages: List<String>.from((d['languages'] as List?) ?? []),
      format: d['format'] as String? ?? '',
      website: d['website'] as String? ?? '',
      instagram: d['instagram'] as String? ?? '',
      imageUrl: d['imageUrl'] as String? ?? '',
      logoUrl: d['logoUrl'] as String? ?? '',
      email: d['email'] as String?,
      phone: d['phone'] as String?,
      tags: List<String>.from((d['tags'] as List?) ?? []),
      minEnt: d['minEnt'] as int?,
      minGpa: (d['minGpa'] as num?)?.toDouble(),
      minIelts: (d['minIelts'] as num?)?.toDouble(),
    );
  }

  /// Сериализует модель в Map для записи в Firestore.
  ///
  /// `id` не включается — это имя документа, а не поле.
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'city': city,
      'type': type,
      'level': level,
      'description': description,
      'directions': directions,
      'costRange': costRange,
      'duration': duration,
      'languages': languages,
      'format': format,
      'website': website,
      'instagram': instagram,
      'imageUrl': imageUrl,
      'logoUrl': logoUrl,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'tags': tags,
      if (minEnt != null) 'minEnt': minEnt,
      if (minGpa != null) 'minGpa': minGpa,
      if (minIelts != null) 'minIelts': minIelts,
    };
  }

  University copyWith({
    String? id,
    String? name,
    String? city,
    String? type,
    String? level,
    String? description,
    List<String>? directions,
    String? costRange,
    String? duration,
    List<String>? languages,
    String? format,
    String? website,
    String? instagram,
    String? imageUrl,
    String? logoUrl,
    String? email,
    String? phone,
    List<String>? tags,
    int? minEnt,
    double? minGpa,
    double? minIelts,
  }) {
    return University(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      type: type ?? this.type,
      level: level ?? this.level,
      description: description ?? this.description,
      directions: directions ?? this.directions,
      costRange: costRange ?? this.costRange,
      duration: duration ?? this.duration,
      languages: languages ?? this.languages,
      format: format ?? this.format,
      website: website ?? this.website,
      instagram: instagram ?? this.instagram,
      imageUrl: imageUrl ?? this.imageUrl,
      logoUrl: logoUrl ?? this.logoUrl,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      tags: tags ?? this.tags,
      minEnt: minEnt ?? this.minEnt,
      minGpa: minGpa ?? this.minGpa,
      minIelts: minIelts ?? this.minIelts,
    );
  }
}