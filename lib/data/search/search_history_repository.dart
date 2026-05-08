abstract class SearchHistoryRepository {
  Future<List<String>> load();
  Future<List<String>> add(String query);
  Future<List<String>> remove(String query);
  Future<void> clear();

  Future<Map<String, List<String>>?> loadSavedFilter();
  Future<void> saveFilter(Map<String, List<String>> filter);
  Future<void> deleteSavedFilter();
}
