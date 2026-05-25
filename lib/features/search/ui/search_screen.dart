// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../../../core/theme/app_colors.dart';
// import '../../../data/auth/auth_repository.dart';
// import '../../../data/search/search_history_repository.dart';
// import '../../../data/university/university_model.dart';
// import '../../../data/university/university_repository.dart';
// import '../../../l10n/generated/app_localizations.dart';
// import '../bloc/search_cubit.dart';
// import '../bloc/search_state.dart';

// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => SearchCubit(
//         universityRepository: context.read<UniversityRepository>(),
//         historyRepository: context.read<SearchHistoryRepository>(),
//         authRepository: context.read<AuthRepository>(),
//       )..bootstrap(),
//       child: const _SearchView(),
//     );
//   }
// }

// class _SearchView extends StatefulWidget {
//   const _SearchView();

//   @override
//   State<_SearchView> createState() => _SearchViewState();
// }

// class _SearchViewState extends State<_SearchView> {
//   final _controller = TextEditingController();
//   final _focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() {
//       context.read<SearchCubit>().focusChanged(_focusNode.hasFocus);
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }

//   void _syncQuery(SearchState state) {
//     if (_controller.text != state.query) {
//       _controller.value = TextEditingValue(
//         text: state.query,
//         selection: TextSelection.collapsed(offset: state.query.length),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return Scaffold(
//       backgroundColor: AppColors.surfaceMuted,
//       appBar: AppBar(
//         backgroundColor: AppColors.surfaceMuted,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         // ── Кнопка назад — слева ──────────────────────────────
//         leading: BlocBuilder<SearchCubit, SearchState>(
//           buildWhen: (a, b) => a.isSearching != b.isSearching,
//           builder: (context, state) {
//             if (state.isSearching) return const SizedBox.shrink();
//             return GestureDetector(
//               onTap: () => context.canPop() ? context.pop() : null,
//               child: Container(
//                 margin: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: AppColors.backgroundLight,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.06),
//                       blurRadius: 8,
//                     ),
//                   ],
//                 ),
//                 child: const Icon(
//                   CupertinoIcons.back,
//                   color: AppColors.textPrimary,
//                   size: 18,
//                 ),
//               ),
//             );
//           },
//         ),
//         titleSpacing: 4,
//         title: BlocBuilder<SearchCubit, SearchState>(
//           buildWhen: (a, b) =>
//               a.isSearching != b.isSearching || a.query != b.query,
//           builder: (context, state) {
//             _syncQuery(state);
//             return Row(
//               children: [
//                 Expanded(
//                   child: _SearchField(
//                     controller: _controller,
//                     focusNode: _focusNode,
//                     hint: l10n.searchHint,
//                   ),
//                 ),
//                 // Кнопка «Отмена» появляется только во время поиска
//                 if (state.isSearching) ...[
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       _focusNode.unfocus();
//                       context.read<SearchCubit>().cancelSearch();
//                     },
//                     child: Text(
//                       l10n.actionCancel,
//                       style: const TextStyle(
//                         fontSize: 15,
//                         color: AppColors.brandPrimary,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             );
//           },
//         ),
//       ),
//       body: BlocBuilder<SearchCubit, SearchState>(
//         builder: (context, state) {
//           if (state.status == SearchStatus.loading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state.isSearching) {
//             return _SearchOverlay(state: state);
//           }
//           return _MainContent(state: state);
//         },
//       ),
//     );
//   }
// }

// class _SearchField extends StatelessWidget {
//   const _SearchField({
//     required this.controller,
//     required this.focusNode,
//     required this.hint,
//   });

//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final String hint;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       decoration: BoxDecoration(
//         color: AppColors.backgroundLight,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border),
//       ),
//       child: TextField(
//         controller: controller,
//         focusNode: focusNode,
//         textInputAction: TextInputAction.search,
//         onChanged: context.read<SearchCubit>().queryChanged,
//         onSubmitted: context.read<SearchCubit>().addToHistory,
//         style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: const TextStyle(
//             color: AppColors.textSecondary,
//             fontSize: 15,
//           ),
//           prefixIcon: const Icon(
//             CupertinoIcons.search,
//             color: AppColors.textSecondary,
//             size: 18,
//           ),
//           suffixIcon: controller.text.isNotEmpty
//               ? GestureDetector(
//                   onTap: () {
//                     controller.clear();
//                     context.read<SearchCubit>().queryChanged('');
//                   },
//                   child: const Icon(
//                     CupertinoIcons.xmark_circle_fill,
//                     color: AppColors.textMuted,
//                     size: 17,
//                   ),
//                 )
//               : null,
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(vertical: 10),
//         ),
//       ),
//     );
//   }
// }

// class _SearchOverlay extends StatelessWidget {
//   const _SearchOverlay({required this.state});

//   final SearchState state;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     if (state.query.trim().isEmpty) {
//       return _HistoryList(state: state);
//     }
//     final results = state.liveResults;
//     if (results.isEmpty) {
//       return Center(
//         child: Text(
//           l10n.searchEmpty,
//           style: const TextStyle(
//             color: AppColors.textSecondary,
//             fontSize: 15,
//           ),
//         ),
//       );
//     }
//     return ListView.separated(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: results.length,
//       separatorBuilder: (_, _) => const Divider(
//         height: 1,
//         indent: 72,
//         color: AppColors.surfaceMuted,
//       ),
//       itemBuilder: (context, i) {
//         final uni = results[i];
//         return _LiveResultTile(
//           university: uni,
//           onTap: () {
//             context.read<SearchCubit>().addToHistory(state.query.trim());
//             FocusScope.of(context).unfocus();
//             context.read<SearchCubit>().focusChanged(false);
//             context.push('/university/${uni.id}', extra: uni);
//           },
//         );
//       },
//     );
//   }
// }

// class _HistoryList extends StatelessWidget {
//   const _HistoryList({required this.state});

//   final SearchState state;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     final cubit = context.read<SearchCubit>();
//     if (!cubit.isAuthenticated) {
//       return Padding(
//         padding: const EdgeInsets.all(32),
//         child: Center(
//           child: Text(
//             l10n.searchHistoryAuthRequired,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: AppColors.textSecondary,
//               fontSize: 14,
//               height: 1.4,
//             ),
//           ),
//         ),
//       );
//     }
//     if (state.history.isEmpty) {
//       return const SizedBox.shrink();
//     }
//     return ListView(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   l10n.searchHistoryTitle,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: AppColors.textSecondary,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: cubit.clearHistory,
//                 child: Text(
//                   l10n.searchHistoryClear,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: AppColors.brandPrimary,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         for (final q in state.history)
//           ListTile(
//             leading: const Icon(
//               CupertinoIcons.clock,
//               color: AppColors.textMuted,
//             ),
//             title: Text(q),
//             trailing: GestureDetector(
//               onTap: () => cubit.removeFromHistory(q),
//               child: const Icon(
//                 CupertinoIcons.xmark,
//                 color: AppColors.textMuted,
//                 size: 18,
//               ),
//             ),
//             onTap: () => cubit.selectHistory(q),
//           ),
//       ],
//     );
//   }
// }

// class _LiveResultTile extends StatelessWidget {
//   const _LiveResultTile({required this.university, required this.onTap});

//   final University university;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: onTap,
//       leading: Container(
//         width: 44,
//         height: 44,
//         decoration: const BoxDecoration(
//           color: AppColors.surfaceMuted,
//           shape: BoxShape.circle,
//         ),
//         child: ClipOval(
//           child: university.logoUrl.isNotEmpty
//               ? Image.network(
//                   university.logoUrl,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, _, _) => _Initial(name: university.name),
//                 )
//               : _Initial(name: university.name),
//         ),
//       ),
//       title: Text(
//         university.name,
//         style: const TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary,
//         ),
//       ),
//       subtitle: Text(
//         university.city,
//         style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
//       ),
//     );
//   }
// }

// class _Initial extends StatelessWidget {
//   const _Initial({required this.name});

//   final String name;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         name.isNotEmpty ? name[0].toUpperCase() : 'U',
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w700,
//           color: AppColors.authPrimaryLight,
//         ),
//       ),
//     );
//   }
// }

// class _MainContent extends StatelessWidget {
//   const _MainContent({required this.state});

//   final SearchState state;

//   static const _types = ['Университет', 'Колледж'];
//   static const _langs = ['Казахский', 'Русский', 'Английский'];
//   static const _dirs = [
//     'IT',
//     'Медицина',
//     'Бизнес',
//     'Право',
//     'Инженерия',
//     'Педагогика',
//     'Дизайн',
//     'Экономика',
//     'Наука',
//     'Нефтегаз',
//   ];
//   static const _formats = ['Очная', 'Дистанционная', 'Гибридная'];
//   static const _costs = ['Бюджет', 'Платное'];

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     final cubit = context.read<SearchCubit>();
//     return ListView(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       children: [
//         if (state.savedFilter != null && state.filters != state.savedFilter)
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
//             child: ActionChip(
//               label: Text(l10n.searchSavedFilterChip),
//               onPressed: cubit.applySavedFilter,
//             ),
//           ),
//         _FilterSection(
//           title: l10n.searchSectionTypes,
//           options: _types,
//           selected: state.filters.types,
//           onToggle: cubit.toggleType,
//         ),
//         _FilterSection(
//           title: l10n.searchSectionLangs,
//           options: _langs,
//           selected: state.filters.languages,
//           onToggle: cubit.toggleLanguage,
//         ),
//         _FilterSection(
//           title: l10n.searchSectionDirs,
//           options: _dirs,
//           selected: state.filters.directions,
//           onToggle: cubit.toggleDirection,
//         ),
//         _FilterSection(
//           title: l10n.searchSectionFormats,
//           options: _formats,
//           selected: state.filters.formats,
//           onToggle: cubit.toggleFormat,
//         ),
//         _FilterSection(
//           title: l10n.searchSectionCosts,
//           options: _costs,
//           selected: state.filters.costs,
//           onToggle: cubit.toggleCost,
//         ),
//         if (!state.filters.isEmpty)
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () async {
//                       final saved = await cubit.saveCurrentFilter();
//                       if (!context.mounted) return;
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(saved
//                               ? l10n.searchFilterSaved
//                               : l10n.searchEmpty),
//                           behavior: SnackBarBehavior.floating,
//                           duration: const Duration(seconds: 2),
//                         ),
//                       );
//                     },
//                     child: Text(l10n.searchSaveFilter),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: TextButton(
//                     onPressed: cubit.clearFilters,
//                     child: Text(l10n.searchClear),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         if (state.savedFilter != null)
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
//             child: TextButton.icon(
//               icon: const Icon(Icons.delete_outline, size: 18),
//               label: Text(l10n.searchDeleteSavedFilter),
//               onPressed: () async {
//                 await cubit.deleteSavedFilter();
//                 if (!context.mounted) return;
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(l10n.searchFilterDeleted),
//                     behavior: SnackBarBehavior.floating,
//                     duration: const Duration(seconds: 2),
//                   ),
//                 );
//               },
//             ),
//           ),
//         const Divider(height: 1, color: AppColors.border),
//         for (final uni in state.filteredResults)
//           ListTile(
//             onTap: () => context.push('/university/${uni.id}', extra: uni),
//             title: Text(
//               uni.name,
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             subtitle: Text(
//               '${uni.city} · ${uni.directions.take(2).join(', ')}',
//               style: const TextStyle(
//                 fontSize: 13,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             trailing: const Icon(
//               CupertinoIcons.chevron_right,
//               size: 16,
//               color: AppColors.textMuted,
//             ),
//           ),
//         if (state.filteredResults.isEmpty)
//           Padding(
//             padding: const EdgeInsets.all(32),
//             child: Center(
//               child: Text(
//                 l10n.searchEmpty,
//                 style: const TextStyle(
//                   color: AppColors.textSecondary,
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class _FilterSection extends StatelessWidget {
//   const _FilterSection({
//     required this.title,
//     required this.options,
//     required this.selected,
//     required this.onToggle,
//   });

//   final String title;
//   final List<String> options;
//   final Set<String> selected;
//   final ValueChanged<String> onToggle;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//               color: AppColors.textSecondary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: [
//               for (final option in options)
//                 FilterChip(
//                   label: Text(option),
//                   selected: selected.contains(option),
//                   onSelected: (_) => onToggle(option),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/search/search_history_repository.dart';
import '../../../data/university/university_model.dart';
import '../../../data/university/university_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/search_cubit.dart';
import '../bloc/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(
        universityRepository: context.read<UniversityRepository>(),
        historyRepository: context.read<SearchHistoryRepository>(),
        authRepository: context.read<AuthRepository>(),
      )..bootstrap(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      context.read<SearchCubit>().focusChanged(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _syncQuery(SearchState state) {
    if (_controller.text != state.query) {
      _controller.value = TextEditingValue(
        text: state.query,
        selection: TextSelection.collapsed(offset: state.query.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        leading: BlocBuilder<SearchCubit, SearchState>(
          buildWhen: (a, b) => a.isSearching != b.isSearching,
          builder: (context, state) {
            if (state.isSearching) return const SizedBox.shrink();
            return GestureDetector(
              onTap: () => context.canPop() ? context.pop() : null,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.surfaceMutedDark
                      : AppColors.backgroundLight,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  CupertinoIcons.back,
                  color: isDark
                      ? AppColors.textInverse
                      : AppColors.textPrimary,
                  size: 18,
                ),
              ),
            );
          },
        ),
        titleSpacing: 4,
        title: BlocBuilder<SearchCubit, SearchState>(
          buildWhen: (a, b) =>
              a.isSearching != b.isSearching || a.query != b.query,
          builder: (context, state) {
            _syncQuery(state);
            return Row(
              children: [
                Expanded(
                  child: _SearchField(
                    controller: _controller,
                    focusNode: _focusNode,
                    hint: l10n.searchHint,
                    isDark: isDark,
                  ),
                ),
                if (state.isSearching) ...[
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      _focusNode.unfocus();
                      context.read<SearchCubit>().cancelSearch();
                    },
                    child: Text(
                      l10n.actionCancel,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.brandAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state.status == SearchStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.isSearching) {
            return _SearchOverlay(state: state, isDark: isDark);
          }
          return _MainContent(state: state, isDark: isDark);
        },
      ),
    );
  }
}

// ─── Поле поиска ─────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.isDark,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceMutedDark
            : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        onChanged: context.read<SearchCubit>().queryChanged,
        onSubmitted: context.read<SearchCubit>().addToHistory,
        style: TextStyle(
          fontSize: 15,
          color: isDark ? AppColors.textInverse : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
          prefixIcon: const Icon(
            CupertinoIcons.search,
            color: AppColors.textSecondary,
            size: 18,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    controller.clear();
                    context.read<SearchCubit>().queryChanged('');
                  },
                  child: const Icon(
                    CupertinoIcons.xmark_circle_fill,
                    color: AppColors.textMuted,
                    size: 17,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

// ─── Оверлей живого поиска ────────────────────────────────────────────────────

class _SearchOverlay extends StatelessWidget {
  const _SearchOverlay({required this.state, required this.isDark});

  final SearchState state;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (state.query.trim().isEmpty) {
      return _HistoryList(state: state, isDark: isDark);
    }
    final results = state.liveResults;
    if (results.isEmpty) {
      return Center(
        child: Text(
          l10n.searchEmpty,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: results.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 72,
        color: isDark ? const Color(0xFF2C2F36) : AppColors.surfaceMuted,
      ),
      itemBuilder: (context, i) {
        final uni = results[i];
        return _LiveResultTile(
          university: uni,
          isDark: isDark,
          onTap: () {
            context.read<SearchCubit>().addToHistory(state.query.trim());
            FocusScope.of(context).unfocus();
            context.read<SearchCubit>().focusChanged(false);
            context.push('/university/${uni.id}', extra: uni);
          },
        );
      },
    );
  }
}

// ─── История поиска ───────────────────────────────────────────────────────────

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.state, required this.isDark});

  final SearchState state;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SearchCubit>();

    if (!cubit.isAuthenticated) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            l10n.searchHistoryAuthRequired,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      );
    }
    if (state.history.isEmpty) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.searchHistoryTitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: cubit.clearHistory,
                child: Text(
                  l10n.searchHistoryClear,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.brandAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        for (final q in state.history)
          ListTile(
            leading: const Icon(
              CupertinoIcons.clock,
              color: AppColors.textMuted,
            ),
            title: Text(
              q,
              style: TextStyle(
                color:
                    isDark ? AppColors.textInverse : AppColors.textPrimary,
              ),
            ),
            trailing: GestureDetector(
              onTap: () => cubit.removeFromHistory(q),
              child: const Icon(
                CupertinoIcons.xmark,
                color: AppColors.textMuted,
                size: 18,
              ),
            ),
            onTap: () => cubit.selectHistory(q),
          ),
      ],
    );
  }
}

// ─── Плитка результата ────────────────────────────────────────────────────────

class _LiveResultTile extends StatelessWidget {
  const _LiveResultTile({
    required this.university,
    required this.isDark,
    required this.onTap,
  });

  final University university;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceMutedDark : AppColors.surfaceMuted,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: university.logoUrl.isNotEmpty
              ? Image.network(
                  university.logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      _Initial(name: university.name.localized(locale)),
                )
              : _Initial(name: university.name.localized(locale)),
        ),
      ),
      title: Text(
        university.name.localized(locale),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.textInverse : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        university.city.localized(locale),
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.authPrimaryLight,
        ),
      ),
    );
  }
}

// ─── Основной контент с фильтрами ─────────────────────────────────────────────

class _MainContent extends StatelessWidget {
  const _MainContent({required this.state, required this.isDark});

  final SearchState state;
  final bool isDark;

  // ── Фильтры ──────────────────────────────────────────────────────────────
  // ВАЖНО: строки должны точно совпадать с тем что хранится в Firestore
  // в полях type, languages, directions, format, costType университета.
  static const _types = ['Университет', 'Колледж'];
  static const _langs = ['Казахский', 'Русский', 'Английский'];
  static const _dirs = [
    'IT',
    'Медицина',
    'Бизнес',
    'Право',
    'Инженерия',
    'Педагогика',
    'Дизайн',
    'Экономика',
    'Наука',
    'Нефтегаз',
  ];
  static const _formats = ['Очная', 'Дистанционная', 'Гибридная'];
  static const _costs = ['Бюджет', 'Платное'];

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SearchCubit>();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        // Кнопка «применить сохранённый фильтр»
        if (state.savedFilter != null &&
            state.filters != state.savedFilter)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: ActionChip(
              label: Text(l10n.searchSavedFilterChip),
              onPressed: cubit.applySavedFilter,
            ),
          ),

        // ── Секции фильтров с анимированными чипами ──────────────
        _FilterSection(
          isDark: isDark,
          title: l10n.searchSectionTypes,
          options: _types,
          selected: state.filters.types,
          onToggle: (v) {
            HapticFeedback.selectionClick();
            cubit.toggleType(v);
          },
        ),
        _FilterSection(
          isDark: isDark,
          title: l10n.searchSectionLangs,
          options: _langs,
          selected: state.filters.languages,
          onToggle: (v) {
            HapticFeedback.selectionClick();
            cubit.toggleLanguage(v);
          },
        ),
        _FilterSection(
          isDark: isDark,
          title: l10n.searchSectionDirs,
          options: _dirs,
          selected: state.filters.directions,
          onToggle: (v) {
            HapticFeedback.selectionClick();
            cubit.toggleDirection(v);
          },
        ),
        _FilterSection(
          isDark: isDark,
          title: l10n.searchSectionFormats,
          options: _formats,
          selected: state.filters.formats,
          onToggle: (v) {
            HapticFeedback.selectionClick();
            cubit.toggleFormat(v);
          },
        ),
        _FilterSection(
          isDark: isDark,
          title: l10n.searchSectionCosts,
          options: _costs,
          selected: state.filters.costs,
          onToggle: (v) {
            HapticFeedback.selectionClick();
            cubit.toggleCost(v);
          },
        ),

        // Счётчик найденных + кнопки сохранить/сбросить
        if (!state.filters.isEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Найдено: ${state.filteredResults.length}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final saved = await cubit.saveCurrentFilter();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(saved
                              ? l10n.searchFilterSaved
                              : l10n.searchEmpty),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );
                    },
                    child: Text(l10n.searchSaveFilter),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: cubit.clearFilters,
                    child: Text(l10n.searchClear),
                  ),
                ),
              ],
            ),
          ),
        ],

        if (state.savedFilter != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextButton.icon(
              icon: const Icon(Icons.delete_outline, size: 18),
              label: Text(l10n.searchDeleteSavedFilter),
              onPressed: () async {
                await cubit.deleteSavedFilter();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.searchFilterDeleted),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),

        Divider(
          height: 1,
          color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
        ),

        // ── Результаты ────────────────────────────────────────────
        for (final uni in state.filteredResults)
        
          ListTile(
            onTap: () =>
                context.push('/university/${uni.id}', extra: uni),
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceMutedDark
                    : AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: uni.logoUrl.isNotEmpty
                    ? Image.network(
                        uni.logoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _Initial(name: uni.name.localized(locale)),
                      )
                    : _Initial(name: uni.name.localized(locale)),
              ),
            ),
            title: Text(
              uni.name.localized(locale),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textInverse
                    : AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              '${uni.city} · ${uni.directions.take(2).join(', ')}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            trailing: const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.textMuted,
            ),
          ),

        if (state.filteredResults.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 48,
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.textMuted,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.searchEmpty,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 32),
      ],
    );
  }
}

// ─── Секция фильтра с анимированными чипами ───────────────────────────────────

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.isDark,
    required this.title,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  final bool isDark;
  final String title;
  final List<String> options;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in options)
                _AnimatedFilterChip(
                  isDark: isDark,
                  label: option,
                  isSelected: selected.contains(option),
                  onTap: () => onToggle(option),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Анимированный чип фильтра ────────────────────────────────────────────────

/// При выборе — плавная смена цвета + лёгкий пружинный scale.
/// Логика фильтрации: если selected пуст — показываем всё.
/// Если выбраны несколько — показываем ВСЕ подходящие (OR-логика).
class _AnimatedFilterChip extends StatefulWidget {
  const _AnimatedFilterChip({
    required this.isDark,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final bool isDark;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_AnimatedFilterChip> createState() => _AnimatedFilterChipState();
}

class _AnimatedFilterChipState extends State<_AnimatedFilterChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: widget.isSelected ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(_AnimatedFilterChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      widget.isSelected ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgUnselected = widget.isDark
        ? AppColors.surfaceMutedDark
        : AppColors.backgroundLight;
    final borderUnselected =
        widget.isDark ? const Color(0xFF2C2F36) : AppColors.border;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final t = _ctrl.value;
        final bg = Color.lerp(bgUnselected, AppColors.brandAccent, t)!;
        final border =
            Color.lerp(borderUnselected, AppColors.brandAccent, t)!;
        final textColor = Color.lerp(
          widget.isDark ? AppColors.textInverse : AppColors.textPrimary,
          AppColors.backgroundDark,
          t,
        )!;
        // Лёгкое увеличение при выборе
        final scale = 1.0 + 0.04 * t;

        return GestureDetector(
          onTap: widget.onTap,
          child: Transform.scale(
            scale: scale,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: border, width: 1.5),
                boxShadow: t > 0.5
                    ? [
                        BoxShadow(
                          color: AppColors.brandAccent
                              .withValues(alpha: 0.25 * t),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}