import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/university_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> _history = [];
  List<University> _liveResults = [];
  bool _isSearching = false;

  // Фильтры — для всех пользователей, хранятся в SharedPreferences
  Set<String> _selectedTypes = {};
  Set<String> _selectedLangs = {};
  Set<String> _selectedDirs = {};
  Set<String> _selectedFormats = {};
  Set<String> _selectedCosts = {};

  static const _historyKey = 'search_history';
  static const _maxHistory = 10;

  // Ключи для сохранения фильтров
  static const _keyTypes   = 'filter_types';
  static const _keyLangs   = 'filter_langs';
  static const _keyDirs    = 'filter_dirs';
  static const _keyFormats = 'filter_formats';
  static const _keyCosts   = 'filter_costs';

  static const _types   = ['Университет', 'Колледж'];
  static const _langs   = ['Казахский', 'Русский', 'Английский'];
  static const _dirs    = [
    'IT', 'Медицина', 'Бизнес', 'Право', 'Инженерия',
    'Педагогика', 'Дизайн', 'Экономика', 'Наука', 'Нефтегаз',
  ];
  static const _formats = ['Очная', 'Дистанционная', 'Гибридная'];
  static const _costs   = ['Бюджет', 'Платное'];

  bool get _isLoggedIn => FirebaseAuth.instance.currentUser != null;

  @override
  void initState() {
    super.initState();
    _loadAll();
    _ctrl.addListener(_onTextChanged);
    _focusNode.addListener(() {
      setState(() => _isSearching = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Загрузка истории и фильтров ─────────────────────────
  Future<void> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();

    // История — только залогиненным
    if (_isLoggedIn) {
      _history = prefs.getStringList(_historyKey) ?? [];
    }

    // Фильтры — всем
    setState(() {
      _selectedTypes   = Set.from(prefs.getStringList(_keyTypes)   ?? []);
      _selectedLangs   = Set.from(prefs.getStringList(_keyLangs)   ?? []);
      _selectedDirs    = Set.from(prefs.getStringList(_keyDirs)    ?? []);
      _selectedFormats = Set.from(prefs.getStringList(_keyFormats) ?? []);
      _selectedCosts   = Set.from(prefs.getStringList(_keyCosts)   ?? []);
    });
  }

  // ── Сохранение фильтров в SharedPreferences ──────────────
  Future<void> _saveFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyTypes,   _selectedTypes.toList());
    await prefs.setStringList(_keyLangs,   _selectedLangs.toList());
    await prefs.setStringList(_keyDirs,    _selectedDirs.toList());
    await prefs.setStringList(_keyFormats, _selectedFormats.toList());
    await prefs.setStringList(_keyCosts,   _selectedCosts.toList());
  }

  // ── История поиска ───────────────────────────────────────
  Future<void> _addToHistory(String q) async {
    if (!_isLoggedIn || q.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _history.remove(q);
    _history.insert(0, q);
    if (_history.length > _maxHistory) {
      _history = _history.take(_maxHistory).toList();
    }
    await prefs.setStringList(_historyKey, _history);
    setState(() {});
  }

  Future<void> _removeFromHistory(String q) async {
    final prefs = await SharedPreferences.getInstance();
    _history.remove(q);
    await prefs.setStringList(_historyKey, _history);
    setState(() {});
  }

  Future<void> _clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    setState(() => _history = []);
  }

  // ── Живой поиск ─────────────────────────────────────────
  void _onTextChanged() {
    final q = _ctrl.text.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() => _liveResults = []);
      return;
    }
    setState(() {
      _liveResults = kazakhUniversities.where((uni) {
        return uni.name.toLowerCase().contains(q) ||
            uni.city.toLowerCase().contains(q) ||
            uni.directions.any((d) => d.toLowerCase().contains(q)) ||
            uni.description.toLowerCase().contains(q);
      }).toList();
    });
  }

  // ── Фильтрованные результаты ─────────────────────────────
  List<University> get _filteredResults {
    final q = _ctrl.text.trim().toLowerCase();
    return kazakhUniversities.where((uni) {
      final matchText = q.isEmpty ||
          uni.name.toLowerCase().contains(q) ||
          uni.city.toLowerCase().contains(q) ||
          uni.directions.any((d) => d.toLowerCase().contains(q));

      final matchType = _selectedTypes.isEmpty ||
          _selectedTypes.any((t) => uni.level.toLowerCase().contains(t.toLowerCase()));
      final matchLang = _selectedLangs.isEmpty ||
          _selectedLangs.any((l) => uni.languages.contains(l));
      final matchDir = _selectedDirs.isEmpty ||
          _selectedDirs.any((d) =>
              uni.directions.any((ud) => ud.toLowerCase().contains(d.toLowerCase())));
      final matchFormat = _selectedFormats.isEmpty ||
          _selectedFormats.any((f) => uni.format.toLowerCase().contains(f.toLowerCase()));
      final matchCost = _selectedCosts.isEmpty ||
          (_selectedCosts.contains('Бюджет') && uni.type == 'гос') ||
          (_selectedCosts.contains('Платное') && uni.type == 'частный');

      return matchText && matchType && matchLang && matchDir && matchFormat && matchCost;
    }).toList();
  }

  bool get _hasFilters =>
      _selectedTypes.isNotEmpty ||
      _selectedLangs.isNotEmpty ||
      _selectedDirs.isNotEmpty ||
      _selectedFormats.isNotEmpty ||
      _selectedCosts.isNotEmpty;

  void _toggleFilter(Set<String> set, String value) {
    setState(() {
      set.contains(value) ? set.remove(value) : set.add(value);
    });
    _saveFilters();
  }

  Future<void> _resetFilters() async {
    setState(() {
      _selectedTypes.clear();
      _selectedLangs.clear();
      _selectedDirs.clear();
      _selectedFormats.clear();
      _selectedCosts.clear();
    });
    await _saveFilters();
  }

  void _cancelSearch() {
    _focusNode.unfocus();
    _ctrl.clear();
    setState(() {
      _liveResults = [];
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E5EA)),
                ),
                child: TextField(
                  controller: _ctrl,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (v) => _addToHistory(v.trim()),
                  style: const TextStyle(fontSize: 15, color: Color(0xFF1C1C1E)),
                  decoration: InputDecoration(
                    hintText: 'Поиск по учреждениям...',
                    hintStyle: const TextStyle(color: Color(0xFF8E8E93), fontSize: 15),
                    prefixIcon: const Icon(CupertinoIcons.search,
                        color: Color(0xFF8E8E93), size: 18),
                    suffixIcon: _ctrl.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _ctrl.clear();
                              setState(() => _liveResults = []);
                            },
                            child: const Icon(CupertinoIcons.xmark_circle_fill,
                                color: Color(0xFFAEAEB2), size: 17),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (_isSearching)
              GestureDetector(
                onTap: _cancelSearch,
                child: const Text('Отмена',
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6366F1),
                        fontWeight: FontWeight.w500)),
              )
            else
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8)
                    ],
                  ),
                  child: const Icon(CupertinoIcons.back,
                      color: Color(0xFF1C1C1E), size: 18),
                ),
              ),
          ],
        ),
      ),
      body: _isSearching
          ? _buildLiveSearch()
          : _buildMainContent(),
    );
  }

  // ══ ЖИВОЙ ПОИСК ═════════════════════════════════════════
  Widget _buildLiveSearch() {
    if (_ctrl.text.trim().isEmpty) {
      // История
      if (!_isLoggedIn || _history.isEmpty) {
        return Center(
          child: Text(
            _isLoggedIn ? 'История пуста' : 'История доступна после входа',
            style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 15),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                const Text('Недавние',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8E8E93))),
                const Spacer(),
                GestureDetector(
                  onTap: _clearHistory,
                  child: const Text('Очистить',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6366F1))),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _history.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 46, color: Color(0xFFF2F2F7)),
              itemBuilder: (_, i) {
                final item = _history[i];
                return ListTile(
                  leading: const Icon(CupertinoIcons.clock,
                      size: 18, color: Color(0xFFAEAEB2)),
                  title: Text(item,
                      style: const TextStyle(
                          fontSize: 15, color: Color(0xFF1C1C1E))),
                  trailing: GestureDetector(
                    onTap: () => _removeFromHistory(item),
                    child: const Icon(CupertinoIcons.xmark,
                        size: 14, color: Color(0xFFAEAEB2)),
                  ),
                  onTap: () {
                    _ctrl.text = item;
                    _ctrl.selection = TextSelection.fromPosition(
                        TextPosition(offset: item.length));
                    _onTextChanged();
                  },
                  dense: true,
                );
              },
            ),
          ),
        ],
      );
    }

    // Результаты живого поиска
    if (_liveResults.isEmpty) {
      return const Center(
        child: Text('Ничего не найдено',
            style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _liveResults.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 72, color: Color(0xFFF2F2F7)),
      itemBuilder: (context, i) {
        final uni = _liveResults[i];
        return ListTile(
          onTap: () {
            _addToHistory(_ctrl.text.trim());
            _focusNode.unfocus();
            setState(() => _isSearching = false);
            context.push('/university/${uni.id}', extra: uni);
          },
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEF8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: uni.logoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(uni.logoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.school_outlined,
                            color: Color(0xFF6366F1), size: 22)),
                  )
                : const Icon(Icons.school_outlined,
                    color: Color(0xFF6366F1), size: 22),
          ),
          title: Text(uni.name,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1C1C1E)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          subtitle: Text(
              '${uni.city} · ${uni.directions.take(2).join(', ')}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          trailing: const Icon(CupertinoIcons.chevron_right,
              size: 14, color: Color(0xFFC7C7CC)),
        );
      },
    );
  }

  // ══ ОСНОВНОЙ КОНТЕНТ ════════════════════════════════════
  Widget _buildMainContent() {
    final showResults = _ctrl.text.trim().isNotEmpty || _hasFilters;
    final results = showResults ? _filteredResults : <University>[];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      children: [
        // ── Блок фильтров (для всех) ─────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Фильтры',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1C1E))),
                  const Spacer(),
                  if (_hasFilters) ...[
                    // Индикатор сохранения
                    const Icon(CupertinoIcons.checkmark_circle_fill,
                        size: 14, color: Color(0xFF34C759)),
                    const SizedBox(width: 4),
                    const Text('Сохранено',
                        style: TextStyle(
                            fontSize: 12, color: Color(0xFF34C759))),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _resetFilters,
                      child: const Text('Сбросить',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF6366F1))),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              _FilterGroup(
                label: 'Тип учебного заведения',
                options: _types,
                selected: _selectedTypes,
                onToggle: (v) => _toggleFilter(_selectedTypes, v),
              ),
              const SizedBox(height: 14),
              _FilterGroup(
                label: 'Язык обучения',
                options: _langs,
                selected: _selectedLangs,
                onToggle: (v) => _toggleFilter(_selectedLangs, v),
              ),
              const SizedBox(height: 14),
              _FilterGroup(
                label: 'Направление подготовки',
                options: _dirs,
                selected: _selectedDirs,
                onToggle: (v) => _toggleFilter(_selectedDirs, v),
              ),
              const SizedBox(height: 14),
              _FilterGroup(
                label: 'Формат обучения',
                options: _formats,
                selected: _selectedFormats,
                onToggle: (v) => _toggleFilter(_selectedFormats, v),
              ),
              const SizedBox(height: 14),
              _FilterGroup(
                label: 'Стоимость обучения',
                options: _costs,
                selected: _selectedCosts,
                onToggle: (v) => _toggleFilter(_selectedCosts, v),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ── Результаты ───────────────────────────────────
        if (showResults) ...[
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 10),
            child: Text(
              'Найдено: ${results.length}',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8E8E93)),
            ),
          ),
          if (results.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(CupertinoIcons.search,
                        size: 44, color: Color(0xFFCCCCCC)),
                    SizedBox(height: 10),
                    Text('Ничего не найдено',
                        style: TextStyle(
                            fontSize: 15, color: Color(0xFF8E8E93))),
                  ],
                ),
              ),
            )
          else
            ...results.map((uni) => _ResultTile(
                  university: uni,
                  onTap: () =>
                      context.push('/university/${uni.id}', extra: uni),
                )),
        ] else
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Введите запрос или выберите фильтры',
                style: TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Карточка результата ─────────────────────────────────────
class _ResultTile extends StatelessWidget {
  final University university;
  final VoidCallback onTap;
  const _ResultTile({required this.university, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF0EEF8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: university.logoUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(university.logoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.school_outlined,
                              color: Color(0xFF6366F1), size: 24)),
                    )
                  : const Icon(Icons.school_outlined,
                      color: Color(0xFF6366F1), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(university.name,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1C1E)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(university.city,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF8E8E93))),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: university.directions
                        .take(3)
                        .map((d) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(d,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF6366F1))),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_right,
                size: 14, color: Color(0xFFC7C7CC)),
          ],
        ),
      ),
    );
  }
}

// ─── Группа фильтра ──────────────────────────────────────────
class _FilterGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _FilterGroup({
    required this.label,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8E8E93))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final sel = selected.contains(opt);
            return GestureDetector(
              onTap: () => onToggle(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: sel ? const Color(0xFF6366F1) : const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: sel
                        ? const Color(0xFF6366F1)
                        : const Color(0xFFE5E5EA),
                  ),
                ),
                child: Text(opt,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: sel ? Colors.white : const Color(0xFF1C1C1E))),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}