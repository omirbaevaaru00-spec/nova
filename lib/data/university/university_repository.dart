import 'university_model.dart';

/// Абстрактный репозиторий университетов.
abstract class UniversityRepository {
  /// Возвращает все университеты, отсортированные по имени.
  Future<List<University>> getAll();

  /// Возвращает университет по ID, или null если не найден.
  Future<University?> getById(String id);

  /// Алиас [getById] — для совместимости с ReviewsCubit.
  Future<University?> fetchById(String id);

  /// Возвращает университеты, у которых хотя бы один тег из [tags].
  Future<List<University>> getByTags(Set<String> tags);

  /// Загружает список университетов в Firestore (seeding).
  Future<void> seedAll(List<University> universities);

  /// Добавляет отсутствующие поля к документу без перезаписи существующих.
  Future<void> patchMissingFields(String id, Map<String, dynamic> fields);
}