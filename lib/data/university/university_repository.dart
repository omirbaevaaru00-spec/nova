import 'university_model.dart';

abstract class UniversityRepository {
  /// Возвращает все университеты из коллекции.
  Future<List<University>> getAll();

  /// Возвращает университет по id документа Firestore.
  Future<University?> getById(String id);

  /// Возвращает университеты, у которых хотя бы один тег совпадает.
  Future<List<University>> getByTags(Set<String> tags);

  /// Заливает новые университеты в Firestore одним batch-запросом.
  ///
  /// Используется при первоначальном наполнении базы новыми документами.
  Future<void> seedAll(List<University> universities);

  /// Дополняет существующий документ недостающими полями (merge).
  ///
  /// Не перезаписывает поля которые уже есть — только добавляет новые.
  /// Используется для обновления старых документов под новую схему.
  Future<void> patchMissingFields(String id, Map<String, dynamic> fields);
}