// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../widgets/university_model.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController _ctrl = TextEditingController();
//   final FocusNode _focusNode = FocusNode();

//   List<String> _history = [];
//   List<University> _liveResults = [];
//   bool _isSearching = false; // true = строка поиска активна

//   // Фильтры (только для залогиненных)
//   final Set<String> _selectedTypes = {};
//   final Set<String> _selectedLangs = {};
//   final Set<String> _selectedDirs = {};
//   final Set<String> _selectedFormats = {};
//   final Set<String> _selectedCosts = {};

//   static const _historyKey = 'search_history';
//   static const _maxHistory = 10;

//   static const _types = ['Университет', 'Колледж'];
//   static const _langs = ['Казахский', 'Русский', 'Английский'];
//   static const _dirs = [
//     'IT', 'Медицина', 'Бизнес', 'Право', 'Инженерия',
//     'Педагогика', 'Дизайн', 'Экономика', 'Наука', 'Нефтегаз',
//   ];
//   static const _formats = ['Очная', 'Дистанционная', 'Гибридная'];
//   static const _costs = ['Бюджет', 'Платное'];

//   bool get _isLoggedIn => FirebaseAuth.instance.currentUser != null;

//   @override
//   void initState() {
//     super.initState();
//     _loadHistory();
//     _ctrl.addListener(_onTextChanged);
//     _focusNode.addListener(() {
//       setState(() => _isSearching = _focusNode.hasFocus);
//     });
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   // ── История ─────────────────────────────────────────────
//   Future<void> _loadHistory() async {
//     if (!_isLoggedIn) return;
//     final prefs = await SharedPreferences.getInstance();
//     setState(() => _history = prefs.getStringList(_historyKey) ?? []);
//   }

//   Future<void> _addToHistory(String q) async {
//     if (!_isLoggedIn || q.trim().isEmpty) return;
//     final prefs = await SharedPreferences.getInstance();
//     _history.remove(q);
//     _history.insert(0, q);
//     if (_history.length > _maxHistory) _history = _history.take(_maxHistory).toList();
//     await prefs.setStringList(_historyKey, _history);
//     setState(() {});
//   }

//   Future<void> _removeFromHistory(String q) async {
//     final prefs = await SharedPreferences.getInstance();
//     _history.remove(q);
//     await prefs.setStringList(_historyKey, _history);
//     setState(() {});
//   }

//   Future<void> _clearHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_historyKey);
//     setState(() => _history = []);
//   }

//   // ── Живой поиск при вводе ────────────────────────────────
//   void _onTextChanged() {
//     final q = _ctrl.text.trim().toLowerCase();
//     if (q.isEmpty) {
//       setState(() => _liveResults = []);
//       return;
//     }
//     setState(() {
//       _liveResults = kazakhUniversities.where((uni) {
//         return uni.name.toLowerCase().contains(q) ||
//             uni.city.toLowerCase().contains(q) ||
//             uni.directions.any((d) => d.toLowerCase().contains(q)) ||
//             uni.description.toLowerCase().contains(q);
//       }).toList();
//     });
//   }

//   // ── Поиск с фильтрами ────────────────────────────────────
//   List<University> get _filteredResults {
//     return kazakhUniversities.where((uni) {
//       final q = _ctrl.text.trim().toLowerCase();
//       final matchText = q.isEmpty ||
//           uni.name.toLowerCase().contains(q) ||
//           uni.city.toLowerCase().contains(q) ||
//           uni.directions.any((d) => d.toLowerCase().contains(q));

//       final matchType = _selectedTypes.isEmpty ||
//           _selectedTypes.any((t) => uni.level.toLowerCase().contains(t.toLowerCase()));
//       final matchLang = _selectedLangs.isEmpty ||
//           _selectedLangs.any((l) => uni.languages.contains(l));
//       final matchDir = _selectedDirs.isEmpty ||
//           _selectedDirs.any((d) =>
//               uni.directions.any((ud) => ud.toLowerCase().contains(d.toLowerCase())));
//       final matchFormat = _selectedFormats.isEmpty ||
//           _selectedFormats.any((f) => uni.format.toLowerCase().contains(f.toLowerCase()));
//       final matchCost = _selectedCosts.isEmpty ||
//           (_selectedCosts.contains('Бюджет') && uni.type == 'гос') ||
//           (_selectedCosts.contains('Платное') && uni.type == 'частный');

//       return matchText && matchType && matchLang && matchDir && matchFormat && matchCost;
//     }).toList();
//   }

//   bool get _hasFilters =>
//       _selectedTypes.isNotEmpty ||
//       _selectedLangs.isNotEmpty ||
//       _selectedDirs.isNotEmpty ||
//       _selectedFormats.isNotEmpty ||
//       _selectedCosts.isNotEmpty;

//   void _selectHistoryItem(String q) {
//     _ctrl.text = q;
//     _ctrl.selection = TextSelection.fromPosition(
//         TextPosition(offset: q.length));
//     _onTextChanged();
//   }

//   void _clearSearch() {
//     _ctrl.clear();
//     setState(() => _liveResults = []);
//   }

//   void _cancelSearch() {
//     _focusNode.unfocus();
//     _clearSearch();
//     setState(() => _isSearching = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F2F7),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF2F2F7),
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         titleSpacing: 16,
//         title: Row(
//           children: [
//             // ── Строка поиска ──────────────────────────────
//             Expanded(
//               child: Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFE5E5EA)),
//                 ),
//                 child: TextField(
//                   controller: _ctrl,
//                   focusNode: _focusNode,
//                   textInputAction: TextInputAction.search,
//                   onSubmitted: (v) => _addToHistory(v.trim()),
//                   style: const TextStyle(
//                     fontSize: 15,
//                     color: Color(0xFF1C1C1E),
//                   ),
//                   decoration: InputDecoration(
//                     hintText: 'Поиск по учреждениям...',
//                     hintStyle: const TextStyle(
//                         color: Color(0xFF8E8E93), fontSize: 15),
//                     prefixIcon: const Icon(CupertinoIcons.search,
//                         color: Color(0xFF8E8E93), size: 18),
//                     suffixIcon: _ctrl.text.isNotEmpty
//                         ? GestureDetector(
//                             onTap: _clearSearch,
//                             child: const Icon(
//                                 CupertinoIcons.xmark_circle_fill,
//                                 color: Color(0xFFAEAEB2),
//                                 size: 17),
//                           )
//                         : null,
//                     border: InputBorder.none,
//                     contentPadding:
//                         const EdgeInsets.symmetric(vertical: 10),
//                   ),
//                 ),
//               ),
//             ),

//             // ── Отмена ─────────────────────────────────────
//             if (_isSearching) ...[
//               const SizedBox(width: 10),
//               GestureDetector(
//                 onTap: _cancelSearch,
//                 child: const Text(
//                   'Отмена',
//                   style: TextStyle(
//                     fontSize: 15,
//                     color: Color(0xFF6366F1),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ] else ...[
//               const SizedBox(width: 10),
//               GestureDetector(
//                 onTap: () => context.pop(),
//                 child: Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.06),
//                         blurRadius: 8,
//                       ),
//                     ],
//                   ),
//                   child: const Icon(CupertinoIcons.back,
//                       color: Color(0xFF1C1C1E), size: 18),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//       body: _isSearching
//           ? _buildLiveSearchOverlay()
//           : _buildMainContent(),
//     );
//   }

//   // ══ ЖИВОЙ ПОИСК (когда строка активна) ══════════════════
//   Widget _buildLiveSearchOverlay() {
//     final q = _ctrl.text.trim();

//     // Нет текста — показываем историю
//     if (q.isEmpty) {
//       return _buildHistoryList();
//     }

//     // Есть текст — показываем результаты в реальном времени
//     if (_liveResults.isEmpty) {
//       return const Center(
//         child: Text('Ничего не найдено',
//             style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15)),
//       );
//     }

//     return ListView.separated(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: _liveResults.length,
//       separatorBuilder: (_, __) => const Divider(
//           height: 1, indent: 72, color: Color(0xFFF2F2F7)),
//       itemBuilder: (context, i) {
//         final uni = _liveResults[i];
//         return _LiveResultTile(
//           university: uni,
//           onTap: () {
//             _addToHistory(q);
//             _focusNode.unfocus();
//             setState(() => _isSearching = false);
//             context.push('/university/${uni.id}', extra: uni);
//           },
//         );
//       },
//     );
//   }

//   // ── История поиска ───────────────────────────────────────
//   Widget _buildHistoryList() {
//     if (!_isLoggedIn) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(32),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(CupertinoIcons.lock, size: 40, color: Color(0xFFCCCCCC)),
//               SizedBox(height: 12),
//               Text(
//                 'История доступна\nтолько после входа',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Color(0xFF8E8E93),
//                   fontSize: 15,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     if (_history.isEmpty) {
//       return const Center(
//         child: Text('История пуста',
//             style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15)),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
//           child: Row(
//             children: [
//               const Text('Недавние',
//                   style: TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF8E8E93))),
//               const Spacer(),
//               GestureDetector(
//                 onTap: _clearHistory,
//                 child: const Text('Очистить',
//                     style: TextStyle(
//                         fontSize: 13, color: Color(0xFF6366F1))),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: ListView.separated(
//             itemCount: _history.length,
//             separatorBuilder: (_, __) =>
//                 const Divider(height: 1, indent: 46, color: Color(0xFFF2F2F7)),
//             itemBuilder: (context, i) {
//               final item = _history[i];
//               return ListTile(
//                 leading: const Icon(CupertinoIcons.clock,
//                     size: 18, color: Color(0xFFAEAEB2)),
//                 title: Text(item,
//                     style: const TextStyle(
//                         fontSize: 15, color: Color(0xFF1C1C1E))),
//                 trailing: GestureDetector(
//                   onTap: () => _removeFromHistory(item),
//                   child: const Icon(CupertinoIcons.xmark,
//                       size: 14, color: Color(0xFFAEAEB2)),
//                 ),
//                 onTap: () => _selectHistoryItem(item),
//                 dense: true,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // ══ ОСНОВНОЙ КОНТЕНТ (строка не активна) ════════════════
//   Widget _buildMainContent() {
//     final hasText = _ctrl.text.trim().isNotEmpty;
//     final showResults = hasText || _hasFilters;
//     final results = showResults ? _filteredResults : <University>[];

//     return ListView(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
//       children: [
//         // ── Фильтры (только для залогиненных) ───────────
//         if (_isLoggedIn) ...[
//           _Card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Text('Фильтры',
//                         style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF1C1C1E))),
//                     const Spacer(),
//                     if (_hasFilters)
//                       GestureDetector(
//                         onTap: () => setState(() {
//                           _selectedTypes.clear();
//                           _selectedLangs.clear();
//                           _selectedDirs.clear();
//                           _selectedFormats.clear();
//                           _selectedCosts.clear();
//                         }),
//                         child: const Text('Сбросить',
//                             style: TextStyle(
//                                 fontSize: 13, color: Color(0xFF6366F1))),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 14),
//                 _FilterGroup(
//                   label: 'Тип учебного заведения',
//                   options: _types,
//                   selected: _selectedTypes,
//                   onToggle: (v) => setState(() => _selectedTypes.contains(v)
//                       ? _selectedTypes.remove(v)
//                       : _selectedTypes.add(v)),
//                 ),
//                 const SizedBox(height: 14),
//                 _FilterGroup(
//                   label: 'Язык обучения',
//                   options: _langs,
//                   selected: _selectedLangs,
//                   onToggle: (v) => setState(() => _selectedLangs.contains(v)
//                       ? _selectedLangs.remove(v)
//                       : _selectedLangs.add(v)),
//                 ),
//                 const SizedBox(height: 14),
//                 _FilterGroup(
//                   label: 'Направление подготовки',
//                   options: _dirs,
//                   selected: _selectedDirs,
//                   onToggle: (v) => setState(() => _selectedDirs.contains(v)
//                       ? _selectedDirs.remove(v)
//                       : _selectedDirs.add(v)),
//                 ),
//                 const SizedBox(height: 14),
//                 _FilterGroup(
//                   label: 'Формат обучения',
//                   options: _formats,
//                   selected: _selectedFormats,
//                   onToggle: (v) => setState(
//                       () => _selectedFormats.contains(v)
//                           ? _selectedFormats.remove(v)
//                           : _selectedFormats.add(v)),
//                 ),
//                 const SizedBox(height: 14),
//                 _FilterGroup(
//                   label: 'Стоимость обучения',
//                   options: _costs,
//                   selected: _selectedCosts,
//                   onToggle: (v) => setState(() => _selectedCosts.contains(v)
//                       ? _selectedCosts.remove(v)
//                       : _selectedCosts.add(v)),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],

//         // ── Незалогиненным — подсказка про фильтры ────────
//         if (!_isLoggedIn) ...[
//           Container(
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: const Color(0xFF6366F1).withOpacity(0.07),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                   color: const Color(0xFF6366F1).withOpacity(0.2)),
//             ),
//             child: const Row(
//               children: [
//                 Icon(CupertinoIcons.lock,
//                     size: 16, color: Color(0xFF6366F1)),
//                 SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'Войдите в аккаунт чтобы использовать фильтры',
//                     style: TextStyle(
//                         fontSize: 13, color: Color(0xFF6366F1)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],

//         // ── Результаты ───────────────────────────────────
//         if (showResults) ...[
//           Padding(
//             padding: const EdgeInsets.only(left: 2, bottom: 10),
//             child: Text(
//               'Найдено: ${results.length}',
//               style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF8E8E93)),
//             ),
//           ),
//           if (results.isEmpty)
//             const Center(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 24),
//                 child: Column(
//                   children: [
//                     Icon(CupertinoIcons.search,
//                         size: 44, color: Color(0xFFCCCCCC)),
//                     SizedBox(height: 10),
//                     Text('Ничего не найдено',
//                         style: TextStyle(
//                             fontSize: 15, color: Color(0xFF8E8E93))),
//                   ],
//                 ),
//               ),
//             )
//           else
//             ...results.map((uni) => _ResultTile(
//                   university: uni,
//                   onTap: () =>
//                       context.push('/university/${uni.id}', extra: uni),
//                 )),
//         ] else if (!_hasFilters)
//           const Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 40),
//               child: Text(
//                 'Введите запрос для поиска',
//                 style:
//                     TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// // ─── Живой результат (пока печатаешь) ───────────────────────
// class _LiveResultTile extends StatelessWidget {
//   final University university;
//   final VoidCallback onTap;

//   const _LiveResultTile({required this.university, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: onTap,
//       leading: Container(
//         width: 44,
//         height: 44,
//         decoration: BoxDecoration(
//           color: const Color(0xFFF0EEF8),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: university.logoUrl.isNotEmpty
//             ? ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.network(university.logoUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => const Icon(
//                         Icons.school_outlined,
//                         color: Color(0xFF6366F1),
//                         size: 22)),
//               )
//             : const Icon(Icons.school_outlined,
//                 color: Color(0xFF6366F1), size: 22),
//       ),
//       title: Text(
//         university.name,
//         style: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.w500,
//             color: Color(0xFF1C1C1E)),
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//       ),
//       subtitle: Text(
//         '${university.city} · ${university.directions.take(2).join(', ')}',
//         style:
//             const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//       ),
//       trailing: const Icon(CupertinoIcons.chevron_right,
//           size: 14, color: Color(0xFFC7C7CC)),
//     );
//   }
// }

// // ─── Результат в основном списке ─────────────────────────────
// class _ResultTile extends StatelessWidget {
//   final University university;
//   final VoidCallback onTap;

//   const _ResultTile({required this.university, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF0EEF8),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: university.logoUrl.isNotEmpty
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.network(university.logoUrl,
//                           fit: BoxFit.cover,
//                           errorBuilder: (_, __, ___) => const Icon(
//                               Icons.school_outlined,
//                               color: Color(0xFF6366F1),
//                               size: 24)),
//                     )
//                   : const Icon(Icons.school_outlined,
//                       color: Color(0xFF6366F1), size: 24),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     university.name,
//                     style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1C1C1E)),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     university.city,
//                     style: const TextStyle(
//                         fontSize: 12, color: Color(0xFF8E8E93)),
//                   ),
//                   const SizedBox(height: 4),
//                   Wrap(
//                     spacing: 4,
//                     children: university.directions
//                         .take(3)
//                         .map((d) => Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF6366F1)
//                                     .withOpacity(0.08),
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Text(d,
//                                   style: const TextStyle(
//                                       fontSize: 11,
//                                       color: Color(0xFF6366F1))),
//                             ))
//                         .toList(),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(CupertinoIcons.chevron_right,
//                 size: 14, color: Color(0xFFC7C7CC)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─── Белая карточка ──────────────────────────────────────────
// class _Card extends StatelessWidget {
//   final Widget child;
//   const _Card({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }

// // ─── Группа фильтра ──────────────────────────────────────────
// class _FilterGroup extends StatelessWidget {
//   final String label;
//   final List<String> options;
//   final Set<String> selected;
//   final ValueChanged<String> onToggle;

//   const _FilterGroup({
//     required this.label,
//     required this.options,
//     required this.selected,
//     required this.onToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF8E8E93))),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: options.map((opt) {
//             final sel = selected.contains(opt);
//             return GestureDetector(
//               onTap: () => onToggle(opt),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 150),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 7),
//                 decoration: BoxDecoration(
//                   color: sel
//                       ? const Color(0xFF6366F1)
//                       : const Color(0xFFF2F2F7),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: sel
//                         ? const Color(0xFF6366F1)
//                         : const Color(0xFFE5E5EA),
//                   ),
//                 ),
//                 child: Text(opt,
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w500,
//                         color: sel
//                             ? Colors.white
//                             : const Color(0xFF1C1C1E))),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';

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

  final Set<String> _selectedTypes = {};
  final Set<String> _selectedLangs = {};
  final Set<String> _selectedDirs = {};
  final Set<String> _selectedFormats = {};
  final Set<String> _selectedCosts = {};

  // Сохранённый фильтр
  Map<String, List<String>>? _savedFilter;

  static const _historyKey = 'search_history';
  static const _filterKey = 'saved_filter';
  static const _maxHistory = 10;

  static const _types = ['Университет', 'Колледж'];
  static const _langs = ['Казахский', 'Русский', 'Английский'];
  static const _dirs = [
    'IT', 'Медицина', 'Бизнес', 'Право', 'Инженерия',
    'Педагогика', 'Дизайн', 'Экономика', 'Наука', 'Нефтегаз',
  ];
  static const _formats = ['Очная', 'Дистанционная', 'Гибридная'];
  static const _costs = ['Бюджет', 'Платное'];

  bool get _isLoggedIn => FirebaseAuth.instance.currentUser != null;

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _loadSavedFilter();
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

  // ── История ─────────────────────────────────────────────
  Future<void> _loadHistory() async {
    if (!_isLoggedIn) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() => _history = prefs.getStringList(_historyKey) ?? []);
  }

  Future<void> _addToHistory(String q) async {
    if (!_isLoggedIn || q.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    _history.remove(q);
    _history.insert(0, q);
    if (_history.length > _maxHistory) _history = _history.take(_maxHistory).toList();
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

  // ── Сохранить / загрузить фильтр ────────────────────────
  Future<void> _loadSavedFilter() async {
    if (!_isLoggedIn) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_filterKey);
    if (raw == null) return;
    try {
      final map = Map<String, List<String>>.from(
        (jsonDecode(raw) as Map).map(
          (k, v) => MapEntry(k as String, List<String>.from(v as List)),
        ),
      );
      setState(() => _savedFilter = map);
    } catch (_) {}
  }

  Future<void> _saveCurrentFilter() async {
    if (!_hasFilters) return;
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'types': _selectedTypes.toList(),
      'langs': _selectedLangs.toList(),
      'dirs': _selectedDirs.toList(),
      'formats': _selectedFormats.toList(),
      'costs': _selectedCosts.toList(),
    };
    await prefs.setString(_filterKey, jsonEncode(data));
    setState(() => _savedFilter = data);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Фильтр сохранён ✓'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteSavedFilter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_filterKey);
    setState(() => _savedFilter = null);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Сохранённый фильтр удалён'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _applySavedFilter() {
    if (_savedFilter == null) return;
    setState(() {
      _selectedTypes
        ..clear()
        ..addAll(_savedFilter!['types'] ?? []);
      _selectedLangs
        ..clear()
        ..addAll(_savedFilter!['langs'] ?? []);
      _selectedDirs
        ..clear()
        ..addAll(_savedFilter!['dirs'] ?? []);
      _selectedFormats
        ..clear()
        ..addAll(_savedFilter!['formats'] ?? []);
      _selectedCosts
        ..clear()
        ..addAll(_savedFilter!['costs'] ?? []);
    });
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

  List<University> get _filteredResults {
    return kazakhUniversities.where((uni) {
      final q = _ctrl.text.trim().toLowerCase();
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

  void _selectHistoryItem(String q) {
    _ctrl.text = q;
    _ctrl.selection =
        TextSelection.fromPosition(TextPosition(offset: q.length));
    _onTextChanged();
  }

  void _clearSearch() {
    _ctrl.clear();
    setState(() => _liveResults = []);
  }

  void _cancelSearch() {
    _focusNode.unfocus();
    _clearSearch();
    setState(() => _isSearching = false);
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
                    hintStyle: const TextStyle(
                        color: Color(0xFF8E8E93), fontSize: 15),
                    prefixIcon: const Icon(CupertinoIcons.search,
                        color: Color(0xFF8E8E93), size: 18),
                    suffixIcon: _ctrl.text.isNotEmpty
                        ? GestureDetector(
                            onTap: _clearSearch,
                            child: const Icon(
                                CupertinoIcons.xmark_circle_fill,
                                color: Color(0xFFAEAEB2),
                                size: 17),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10),
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
                          blurRadius: 8),
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
    final q = _ctrl.text.trim();

    if (q.isEmpty) {
      // История
      if (!_isLoggedIn) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.lock, size: 40, color: Color(0xFFCCCCCC)),
              SizedBox(height: 12),
              Text('История доступна только после входа',
                  style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15)),
            ],
          ),
        );
      }
      if (_history.isEmpty) {
        return const Center(
          child: Text('История пуста',
              style: TextStyle(color: Color(0xFF8E8E93), fontSize: 15)),
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
                      style:
                          TextStyle(fontSize: 13, color: Color(0xFF6366F1))),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: _history.length,
              separatorBuilder: (_, __) => const Divider(
                  height: 1, indent: 46, color: Color(0xFFF2F2F7)),
              itemBuilder: (context, i) {
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
                  onTap: () => _selectHistoryItem(item),
                  dense: true,
                );
              },
            ),
          ),
        ],
      );
    }

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
            _addToHistory(q);
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
                            color: Color(0xFF6366F1),
                            size: 22)),
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
              style:
                  const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
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
    final showResults =
        _ctrl.text.trim().isNotEmpty || _hasFilters;
    final results = showResults ? _filteredResults : <University>[];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
      children: [
        // ── Фильтры (только залогиненным) ─────────────────
        if (_isLoggedIn) ...[
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок + кнопки
                Row(
                  children: [
                    const Text('Фильтры',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1C1C1E))),
                    const Spacer(),
                    if (_hasFilters)
                      GestureDetector(
                        onTap: () => setState(() {
                          _selectedTypes.clear();
                          _selectedLangs.clear();
                          _selectedDirs.clear();
                          _selectedFormats.clear();
                          _selectedCosts.clear();
                        }),
                        child: const Text('Сбросить',
                            style: TextStyle(
                                fontSize: 13, color: Color(0xFF8E8E93))),
                      ),
                  ],
                ),

                // Сохранённый фильтр — плашка
                if (_savedFilter != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.07),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFF6366F1).withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.bookmark_fill,
                            size: 14, color: Color(0xFF6366F1)),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text('Есть сохранённый фильтр',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF6366F1))),
                        ),
                        GestureDetector(
                          onTap: _applySavedFilter,
                          child: const Text('Применить',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6366F1))),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: _deleteSavedFilter,
                          child: const Icon(CupertinoIcons.xmark,
                              size: 13, color: Color(0xFF8E8E93)),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 14),

                _FilterGroup(
                  label: 'Тип учебного заведения',
                  options: _types,
                  selected: _selectedTypes,
                  onToggle: (v) => setState(() => _selectedTypes.contains(v)
                      ? _selectedTypes.remove(v)
                      : _selectedTypes.add(v)),
                ),
                const SizedBox(height: 14),
                _FilterGroup(
                  label: 'Язык обучения',
                  options: _langs,
                  selected: _selectedLangs,
                  onToggle: (v) => setState(() => _selectedLangs.contains(v)
                      ? _selectedLangs.remove(v)
                      : _selectedLangs.add(v)),
                ),
                const SizedBox(height: 14),
                _FilterGroup(
                  label: 'Направление подготовки',
                  options: _dirs,
                  selected: _selectedDirs,
                  onToggle: (v) => setState(() => _selectedDirs.contains(v)
                      ? _selectedDirs.remove(v)
                      : _selectedDirs.add(v)),
                ),
                const SizedBox(height: 14),
                _FilterGroup(
                  label: 'Формат обучения',
                  options: _formats,
                  selected: _selectedFormats,
                  onToggle: (v) => setState(
                      () => _selectedFormats.contains(v)
                          ? _selectedFormats.remove(v)
                          : _selectedFormats.add(v)),
                ),
                const SizedBox(height: 14),
                _FilterGroup(
                  label: 'Стоимость обучения',
                  options: _costs,
                  selected: _selectedCosts,
                  onToggle: (v) => setState(() => _selectedCosts.contains(v)
                      ? _selectedCosts.remove(v)
                      : _selectedCosts.add(v)),
                ),

                const SizedBox(height: 16),

                // ── Кнопка СОХРАНИТЬ ФИЛЬТР ──────────────
                if (_hasFilters)
                  GestureDetector(
                    onTap: _saveCurrentFilter,
                    child: Container(
                      width: double.infinity,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF6366F1), width: 1.5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.bookmark,
                              size: 16, color: Color(0xFF6366F1)),
                          SizedBox(width: 6),
                          Text(
                            'Сохранить фильтр',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── Незалогиненным — подсказка ────────────────────
        if (!_isLoggedIn) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: const Color(0xFF6366F1).withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(CupertinoIcons.lock,
                    size: 16, color: Color(0xFF6366F1)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Войдите в аккаунт чтобы использовать фильтры',
                    style:
                        TextStyle(fontSize: 13, color: Color(0xFF6366F1)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // ── Результаты ───────────────────────────────────
        if (showResults) ...[
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 10),
            child: Text('Найдено: ${results.length}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8E8E93))),
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
              child: Text('Введите запрос для поиска',
                  style:
                      TextStyle(fontSize: 14, color: Color(0xFF8E8E93))),
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
                offset: const Offset(0, 2)),
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
                              color: Color(0xFF6366F1),
                              size: 24)),
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
                                color: const Color(0xFF6366F1)
                                    .withOpacity(0.08),
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

// ─── Белая карточка ──────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: child,
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: sel
                      ? const Color(0xFF6366F1)
                      : const Color(0xFFF2F2F7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: sel
                          ? const Color(0xFF6366F1)
                          : const Color(0xFFE5E5EA)),
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