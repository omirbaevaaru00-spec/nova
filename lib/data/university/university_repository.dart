import 'university_model.dart';

abstract class UniversityRepository {
  Future<List<University>> getAll();
  Future<University?> getById(String id);
  Future<List<University>> getByTags(Set<String> tags);
}
