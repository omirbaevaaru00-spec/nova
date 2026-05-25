import 'package:equatable/equatable.dart';

import '../../../data/university/university_model.dart';

enum SearchStatus { initial, loading, ready, failure }

/// Фильтры поиска.
class SearchFilters extends Equatable {
  final Set<String> types;
  final Set<String> languages;
  final Set<String> directions;
  final Set<String> formats;
  final Set<String> costs;

  const SearchFilters({
    this.types = const {},
    this.languages = const {},
    this.directions = const {},
    this.formats = const {},
    this.costs = const {},
  });

  bool get isEmpty =>
      types.isEmpty &&
      languages.isEmpty &&
      directions.isEmpty &&
      formats.isEmpty &&
      costs.isEmpty;

  SearchFilters copyWith({
    Set<String>? types,
    Set<String>? languages,
    Set<String>? directions,
    Set<String>? formats,
    Set<String>? costs,
  }) =>
      SearchFilters(
        types: types ?? this.types,
        languages: languages ?? this.languages,
        directions: directions ?? this.directions,
        formats: formats ?? this.formats,
        costs: costs ?? this.costs,
      );

  Map<String, dynamic> toMap() => {
        'types': types.toList(),
        'languages': languages.toList(),
        'directions': directions.toList(),
        'formats': formats.toList(),
        'costs': costs.toList(),
      };

  factory SearchFilters.fromMap(Map<String, dynamic> map) => SearchFilters(
        types: Set<String>.from((map['types'] as List?) ?? []),
        languages: Set<String>.from((map['languages'] as List?) ?? []),
        directions: Set<String>.from((map['directions'] as List?) ?? []),
        formats: Set<String>.from((map['formats'] as List?) ?? []),
        costs: Set<String>.from((map['costs'] as List?) ?? []),
      );

  @override
  List<Object?> get props =>
      [types, languages, directions, formats, costs];
}

/// Состояние экрана поиска.
class SearchState extends Equatable {
  final SearchStatus status;
  final List<University> allUniversities;
  final String query;
  final bool isSearching;
  final List<String> history;
  final SearchFilters filters;
  final SearchFilters? savedFilter;

  const SearchState({
    this.status = SearchStatus.initial,
    this.allUniversities = const [],
    this.query = '',
    this.isSearching = false,
    this.history = const [],
    this.filters = const SearchFilters(),
    this.savedFilter,
  });

  // ── Живой поиск (по всем трём языкам через containsQuery) ────────────

  List<University> get liveResults {
    if (query.trim().isEmpty) return [];
    final q = query.trim().toLowerCase();
    return allUniversities.where((u) {
      // Ищем по name, city, directions — по всем языкам сразу
      return u.name.containsQuery(q) ||
          u.city.containsQuery(q) ||
          u.directions.any((d) => d.toLowerCase().contains(q));
    }).toList();
  }

  // ── Результаты с фильтрами (OR-логика внутри группы) ─────────────────

  List<University> get filteredResults {
    if (filters.isEmpty) return allUniversities;
    return allUniversities.where((u) {
      // Тип — OR внутри группы, пропускаем если группа пуста
      final typeOk = filters.types.isEmpty ||
          filters.types.contains(u.type);

      // Язык — OR внутри группы
      final langOk = filters.languages.isEmpty ||
          filters.languages.any((l) => u.languages.contains(l));

      // Направление — OR внутри группы
      final dirOk = filters.directions.isEmpty ||
          filters.directions.any((d) => u.directions.contains(d));

      // Формат — OR внутри группы
      final formatOk = filters.formats.isEmpty ||
          filters.formats.any((f) => u.format.contains(f));

      // Стоимость — проверяем по тегам (бюджет/платное)
      final costOk = filters.costs.isEmpty || _matchesCost(u);

      // AND между группами
      return typeOk && langOk && dirOk && formatOk && costOk;
    }).toList();
  }

  bool _matchesCost(University u) {
    for (final cost in filters.costs) {
      if (cost == 'Бюджет' && u.tags.contains('grants')) return true;
      if (cost == 'Платное' && !u.tags.contains('grants')) return true;
    }
    return false;
  }

  SearchState copyWith({
    SearchStatus? status,
    List<University>? allUniversities,
    String? query,
    bool? isSearching,
    List<String>? history,
    SearchFilters? filters,
    SearchFilters? savedFilter,
    bool clearSavedFilter = false,
  }) =>
      SearchState(
        status: status ?? this.status,
        allUniversities: allUniversities ?? this.allUniversities,
        query: query ?? this.query,
        isSearching: isSearching ?? this.isSearching,
        history: history ?? this.history,
        filters: filters ?? this.filters,
        savedFilter:
            clearSavedFilter ? null : (savedFilter ?? this.savedFilter),
      );

  @override
  List<Object?> get props => [
        status,
        allUniversities,
        query,
        isSearching,
        history,
        filters,
        savedFilter,
      ];
}