import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'search_history_repository.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  SearchHistoryRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _historyKey = 'search_history';
  static const _filterKey = 'saved_filter';
  static const _maxHistory = 10;

  @override
  Future<List<String>> load() async {
    return _prefs.getStringList(_historyKey) ?? const [];
  }

  @override
  Future<List<String>> add(String query) async {
    if (query.isEmpty) return load();
    final current = List<String>.from(_prefs.getStringList(_historyKey) ?? const [])
      ..remove(query)
      ..insert(0, query);
    final trimmed =
        current.length > _maxHistory ? current.sublist(0, _maxHistory) : current;
    await _prefs.setStringList(_historyKey, trimmed);
    return trimmed;
  }

  @override
  Future<List<String>> remove(String query) async {
    final current = List<String>.from(_prefs.getStringList(_historyKey) ?? const [])
      ..remove(query);
    await _prefs.setStringList(_historyKey, current);
    return current;
  }

  @override
  Future<void> clear() async {
    await _prefs.remove(_historyKey);
  }

  @override
  Future<Map<String, List<String>>?> loadSavedFilter() async {
    final raw = _prefs.getString(_filterKey);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return null;
      return decoded.map(
        (k, v) => MapEntry(k as String, List<String>.from(v as List)),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveFilter(Map<String, List<String>> filter) async {
    await _prefs.setString(_filterKey, jsonEncode(filter));
  }

  @override
  Future<void> deleteSavedFilter() async {
    await _prefs.remove(_filterKey);
  }
}
