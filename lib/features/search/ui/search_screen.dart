import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceMuted,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: BlocBuilder<SearchCubit, SearchState>(
          buildWhen: (a, b) =>
              a.isSearching != b.isSearching || a.query != b.query,
          builder: (context, state) {
            _syncQuery(state);
            return Row(
              children: [
                Expanded(child: _SearchField(
                  controller: _controller,
                  focusNode: _focusNode,
                  hint: l10n.searchHint,
                )),
                const SizedBox(width: 10),
                if (state.isSearching)
                  GestureDetector(
                    onTap: () {
                      _focusNode.unfocus();
                      context.read<SearchCubit>().cancelSearch();
                    },
                    child: Text(
                      l10n.actionCancel,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () =>
                        context.canPop() ? context.pop() : null,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        CupertinoIcons.back,
                        color: AppColors.textPrimary,
                        size: 18,
                      ),
                    ),
                  ),
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
            return _SearchOverlay(state: state);
          }
          return _MainContent(state: state);
        },
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hint,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        onChanged: context.read<SearchCubit>().queryChanged,
        onSubmitted: context.read<SearchCubit>().addToHistory,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
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

class _SearchOverlay extends StatelessWidget {
  const _SearchOverlay({required this.state});

  final SearchState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (state.query.trim().isEmpty) {
      return _HistoryList(state: state);
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
      separatorBuilder: (_, _) => const Divider(
        height: 1,
        indent: 72,
        color: AppColors.surfaceMuted,
      ),
      itemBuilder: (context, i) {
        final uni = results[i];
        return _LiveResultTile(
          university: uni,
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

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.state});

  final SearchState state;

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
    if (state.history.isEmpty) {
      return const SizedBox.shrink();
    }
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
                    color: AppColors.brandPrimary,
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
            title: Text(q),
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

class _LiveResultTile extends StatelessWidget {
  const _LiveResultTile({required this.university, required this.onTap});

  final University university;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.surfaceMuted,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: university.logoUrl.isNotEmpty
              ? Image.network(
                  university.logoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _Initial(name: university.name),
                )
              : _Initial(name: university.name),
        ),
      ),
      title: Text(
        university.name,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        university.city,
        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
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

class _MainContent extends StatelessWidget {
  const _MainContent({required this.state});

  final SearchState state;

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
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<SearchCubit>();
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (state.savedFilter != null && state.filters != state.savedFilter)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: ActionChip(
              label: Text(l10n.searchSavedFilterChip),
              onPressed: cubit.applySavedFilter,
            ),
          ),
        _FilterSection(
          title: l10n.searchSectionTypes,
          options: _types,
          selected: state.filters.types,
          onToggle: cubit.toggleType,
        ),
        _FilterSection(
          title: l10n.searchSectionLangs,
          options: _langs,
          selected: state.filters.languages,
          onToggle: cubit.toggleLanguage,
        ),
        _FilterSection(
          title: l10n.searchSectionDirs,
          options: _dirs,
          selected: state.filters.directions,
          onToggle: cubit.toggleDirection,
        ),
        _FilterSection(
          title: l10n.searchSectionFormats,
          options: _formats,
          selected: state.filters.formats,
          onToggle: cubit.toggleFormat,
        ),
        _FilterSection(
          title: l10n.searchSectionCosts,
          options: _costs,
          selected: state.filters.costs,
          onToggle: cubit.toggleCost,
        ),
        if (!state.filters.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
        const Divider(height: 1, color: AppColors.border),
        for (final uni in state.filteredResults)
          ListTile(
            onTap: () => context.push('/university/${uni.id}', extra: uni),
            title: Text(
              uni.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
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
              child: Text(
                l10n.searchEmpty,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.options,
    required this.selected,
    required this.onToggle,
  });

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
                FilterChip(
                  label: Text(option),
                  selected: selected.contains(option),
                  onSelected: (_) => onToggle(option),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
