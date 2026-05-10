import 'package:equatable/equatable.dart';

import '../../../data/university/university_model.dart';

enum SearchStatus { initial, loading, ready, failure }

class SearchFilters extends Equatable {
  const SearchFilters({
    this.types = const {},
    this.languages = const {},
    this.directions = const {},
    this.formats = const {},
    this.costs = const {},
  });

  final Set<String> types;
  final Set<String> languages;
  final Set<String> directions;
  final Set<String> formats;
  final Set<String> costs;

  bool get isEmpty =>
      types.isEmpty &&
      languages.isEmpty &&
      directions.isEmpty &&
      formats.isEmpty &&
      costs.isEmpty;

  Map<String, List<String>> toMap() => {
        'types': types.toList(),
        'langs': languages.toList(),
        'dirs': directions.toList(),
        'formats': formats.toList(),
        'costs': costs.toList(),
      };

  factory SearchFilters.fromMap(Map<String, List<String>> map) {
    return SearchFilters(
      types: (map['types'] ?? const []).toSet(),
      languages: (map['langs'] ?? const []).toSet(),
      directions: (map['dirs'] ?? const []).toSet(),
      formats: (map['formats'] ?? const []).toSet(),
      costs: (map['costs'] ?? const []).toSet(),
    );
  }

  SearchFilters copyWith({
    Set<String>? types,
    Set<String>? languages,
    Set<String>? directions,
    Set<String>? formats,
    Set<String>? costs,
  }) {
    return SearchFilters(
      types: types ?? this.types,
      languages: languages ?? this.languages,
      directions: directions ?? this.directions,
      formats: formats ?? this.formats,
      costs: costs ?? this.costs,
    );
  }

  @override
  List<Object?> get props => [types, languages, directions, formats, costs];
}

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.query = '',
    this.allUniversities = const [],
    this.history = const [],
    this.filters = const SearchFilters(),
    this.savedFilter,
    this.isSearching = false,
  });

  final SearchStatus status;
  final String query;
  final List<University> allUniversities;
  final List<String> history;
  final SearchFilters filters;
  final SearchFilters? savedFilter;
  final bool isSearching;

  List<University> get liveResults {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const [];
    return allUniversities.where((u) {
      return u.name.toLowerCase().contains(q) ||
          u.city.toLowerCase().contains(q) ||
          u.directions.any((d) => d.toLowerCase().contains(q)) ||
          u.description.toLowerCase().contains(q);
    }).toList();
  }

  List<University> get filteredResults {
    return allUniversities.where((u) => _matches(u)).toList();
  }

  bool _matches(University u) {
    final q = query.trim().toLowerCase();
    final matchText = q.isEmpty ||
        u.name.toLowerCase().contains(q) ||
        u.city.toLowerCase().contains(q) ||
        u.directions.any((d) => d.toLowerCase().contains(q));
    final matchType = filters.types.isEmpty ||
        filters.types.any((t) => u.level.toLowerCase().contains(t.toLowerCase()));
    final matchLang = filters.languages.isEmpty ||
        filters.languages.any((l) => u.languages.contains(l));
    final matchDir = filters.directions.isEmpty ||
        filters.directions.any((d) =>
            u.directions.any((ud) => ud.toLowerCase().contains(d.toLowerCase())));
    final matchFormat = filters.formats.isEmpty ||
        filters.formats.any((f) => u.format.toLowerCase().contains(f.toLowerCase()));
    final matchCost = filters.costs.isEmpty ||
        (filters.costs.contains('Бюджет') && u.type == 'гос') ||
        (filters.costs.contains('Платное') && u.type == 'частный');
    return matchText && matchType && matchLang && matchDir && matchFormat && matchCost;
  }

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<University>? allUniversities,
    List<String>? history,
    SearchFilters? filters,
    SearchFilters? savedFilter,
    bool? isSearching,
    bool clearSavedFilter = false,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      allUniversities: allUniversities ?? this.allUniversities,
      history: history ?? this.history,
      filters: filters ?? this.filters,
      savedFilter: clearSavedFilter ? null : (savedFilter ?? this.savedFilter),
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
        status,
        query,
        allUniversities,
        history,
        filters,
        savedFilter,
        isSearching,
      ];
}
