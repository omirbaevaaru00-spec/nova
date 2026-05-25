import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_repository.dart';
import '../../../data/search/search_history_repository.dart';
import '../../../data/university/university_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required UniversityRepository universityRepository,
    required SearchHistoryRepository historyRepository,
    required AuthRepository authRepository,
  })  : _universities = universityRepository,
        _history = historyRepository,
        _auth = authRepository,
        super(const SearchState());

  final UniversityRepository _universities;
  final SearchHistoryRepository _history;
  final AuthRepository _auth;

  bool get isAuthenticated => _auth.isAuthenticated;

  Future<void> bootstrap() async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      final all = await _universities.getAll();
      final history =
          isAuthenticated ? await _history.load() : <String>[];
      final savedRaw =
          isAuthenticated ? await _history.loadSavedFilter() : null;
      emit(
        state.copyWith(
          status: SearchStatus.ready,
          allUniversities: all,
          history: history,
          savedFilter:
              savedRaw == null ? null : SearchFilters.fromMap(savedRaw),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  void queryChanged(String value) =>
      emit(state.copyWith(query: value));

  void focusChanged(bool isFocused) =>
      emit(state.copyWith(isSearching: isFocused));

  void clearQuery() =>
      emit(state.copyWith(query: '', isSearching: state.isSearching));

  void cancelSearch() =>
      emit(state.copyWith(query: '', isSearching: false));

  Future<void> addToHistory(String query) async {
    if (!isAuthenticated || query.isEmpty) return;
    final updated = await _history.add(query);
    emit(state.copyWith(history: updated));
  }

  Future<void> removeFromHistory(String query) async {
    final updated = await _history.remove(query);
    emit(state.copyWith(history: updated));
  }

  Future<void> clearHistory() async {
    await _history.clear();
    emit(state.copyWith(history: const []));
  }

  void selectHistory(String query) =>
      emit(state.copyWith(query: query));

  void toggleType(String value) => _toggle(
        state.filters.types,
        value,
        (s) => state.filters.copyWith(types: s),
      );

  void toggleLanguage(String value) => _toggle(
        state.filters.languages,
        value,
        (s) => state.filters.copyWith(languages: s),
      );

  void toggleDirection(String value) => _toggle(
        state.filters.directions,
        value,
        (s) => state.filters.copyWith(directions: s),
      );

  void toggleFormat(String value) => _toggle(
        state.filters.formats,
        value,
        (s) => state.filters.copyWith(formats: s),
      );

  void toggleCost(String value) => _toggle(
        state.filters.costs,
        value,
        (s) => state.filters.copyWith(costs: s),
      );

  void _toggle(
    Set<String> set,
    String value,
    SearchFilters Function(Set<String> next) update,
  ) {
    final next = Set<String>.from(set);
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    emit(state.copyWith(filters: update(next)));
  }

  void clearFilters() =>
      emit(state.copyWith(filters: const SearchFilters()));

  Future<bool> saveCurrentFilter() async {
    if (state.filters.isEmpty) return false;
    // await _history.saveFilter(state.filters.toMap());
    await _history.saveFilter(
  Map<String, List<String>>.from(
    state.filters.toMap().map(
      (key, value) => MapEntry(
        key,
        List<String>.from(value),
      ),
    ),
  ),
);
    emit(state.copyWith(savedFilter: state.filters));
    return true;
  }

  Future<void> deleteSavedFilter() async {
    await _history.deleteSavedFilter();
    emit(state.copyWith(clearSavedFilter: true));
  }

  void applySavedFilter() {
    if (state.savedFilter == null) return;
    emit(state.copyWith(filters: state.savedFilter));
  }
}
