/// Модель университета.
///
/// Поле `tags` совпадает с ключами интересов из квиза:
/// `it | medicine | business | grants | design | law |`
/// `pedagogy | engineering | bachelor | college | master`.
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
    this.tags = const [],
    this.minEnt,
    this.minGpa,
    this.minIelts,
  });

  final String id;
  final String name;
  final String city;
  final String type;
  final String level;
  final String description;
  final List<String> directions;
  final String costRange;
  final String duration;
  final List<String> languages;
  final String format;
  final String website;
  final String instagram;
  final String imageUrl;
  final String logoUrl;
  final List<String> tags;
  final int? minEnt;
  final double? minGpa;
  final double? minIelts;
}
