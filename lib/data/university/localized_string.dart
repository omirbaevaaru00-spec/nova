/// Мультиязычная строка. Хранит текст на трёх языках.
/// Используется для полей университета (name, description, city и т.д.)
///
/// Структура в Firestore (новая):
/// ```json
/// "name": { "ru": "...", "en": "...", "kk": "..." }
/// ```
/// Структура в Firestore (старая — поддерживается):
/// ```json
/// { "name": "Назарбаев Университет" }
/// ```
class LocalizedString {
  final String ru;
  final String en;
  final String kk;

  const LocalizedString({
    required this.ru,
    required this.en,
    required this.kk,
  });

  /// Создаёт из Map Firestore-документа.
  factory LocalizedString.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const LocalizedString(ru: '', en: '', kk: '');
    return LocalizedString(
      ru: map['ru'] as String? ?? '',
      en: map['en'] as String? ?? '',
      kk: map['kk'] as String? ?? '',
    );
  }

  /// Создаёт из обычной строки (обратная совместимость со старыми данными).
  factory LocalizedString.fromString(String value) => LocalizedString(
        ru: value,
        en: value,
        kk: value,
      );

  /// Возвращает текст на нужном языке.
  /// Если перевод пуст — возвращает русский (fallback).
  String localized(String languageCode) {
    switch (languageCode) {
      case 'en':
        return en.isNotEmpty ? en : ru;
      case 'kk':
        return kk.isNotEmpty ? kk : ru;
      default:
        return ru.isNotEmpty ? ru : en;
    }
  }

  /// Проверяет содержит ли хотя бы один перевод подстроку [query].
  /// Поиск регистронезависимый.
  bool containsQuery(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return ru.toLowerCase().contains(q) ||
        en.toLowerCase().contains(q) ||
        kk.toLowerCase().contains(q);
  }

  /// Возвращает нижний регистр для нужного языка.
  /// Используется вместо .toLowerCase() на LocalizedString.
  String localizedLower(String languageCode) =>
      localized(languageCode).toLowerCase();

  /// Конвертирует в Map для сохранения в Firestore.
  Map<String, dynamic> toMap() => {'ru': ru, 'en': en, 'kk': kk};

  /// Проверяет, пуста ли строка на всех языках.
  bool get isEmpty => ru.isEmpty && en.isEmpty && kk.isEmpty;
  bool get isNotEmpty => !isEmpty;

  /// toString() возвращает русскую версию — для отладки и fallback.
  @override
  String toString() => ru;
}