import 'kazakh_universities.dart';
import 'university_model.dart';
import 'university_repository.dart';

/// Локальная реализация — отдаёт хардкод-список.
/// Когда будет Firestore-каталог — меняем только этот класс.
class UniversityRepositoryImpl implements UniversityRepository {
  const UniversityRepositoryImpl();

  @override
  Future<List<University>> getAll() async => kazakhUniversities;

  @override
  Future<University?> getById(String id) async {
    for (final u in kazakhUniversities) {
      if (u.id == id) return u;
    }
    return null;
  }

  @override
  Future<List<University>> getByTags(Set<String> tags) async {
    if (tags.isEmpty) return kazakhUniversities;
    return kazakhUniversities
        .where((u) => u.tags.any(tags.contains))
        .toList();
  }
}
