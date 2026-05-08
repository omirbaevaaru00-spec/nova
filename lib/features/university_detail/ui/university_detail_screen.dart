import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/university/university_model.dart';
import '../../../data/university/university_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/university_detail_cubit.dart';
import '../bloc/university_detail_state.dart';

class UniversityDetailScreen extends StatelessWidget {
  const UniversityDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UniversityDetailCubit(
        universityRepository: context.read<UniversityRepository>(),
      )..load(id),
      child: const _UniversityDetailView(),
    );
  }
}

class _UniversityDetailView extends StatelessWidget {
  const _UniversityDetailView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<UniversityDetailCubit, UniversityDetailState>(
      builder: (context, state) {
        if (state.status == UniversityDetailStatus.loading ||
            state.status == UniversityDetailStatus.initial) {
          return const Scaffold(
            backgroundColor: AppColors.surfaceMuted,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final uni = state.university;
        if (uni == null) {
          return Scaffold(
            backgroundColor: AppColors.surfaceMuted,
            body: Center(child: Text(l10n.searchEmpty)),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.surfaceMuted,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const _TopBar(),
                  _HeroImage(university: uni),
                  const SizedBox(height: 18),
                  _Header(university: uni),
                  const SizedBox(height: 22),
                  _Tabs(current: state.tab),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _TabContent(state: state, university: uni),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 24,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              size: 28,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: university.imageUrl.isNotEmpty
          ? Image.network(
              university.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const _HeroPlaceholder(),
            )
          : const _HeroPlaceholder(),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.divider,
      child: const Center(
        child: Icon(
          Icons.school_outlined,
          color: AppColors.authPrimaryLight,
          size: 48,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceMuted,
              border: Border.all(color: AppColors.border),
            ),
            child: ClipOval(
              child: university.logoUrl.isNotEmpty
                  ? Image.network(
                      university.logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          _Initial(name: university.name),
                    )
                  : _Initial(name: university.name),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  university.name,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  university.city,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
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
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppColors.authPrimaryLight,
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.current});

  final UniversityDetailTab current;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: l10n.universityTabDescription,
              tab: UniversityDetailTab.description,
              current: current,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TabButton(
              label: l10n.universityTabPrograms,
              tab: UniversityDetailTab.programs,
              current: current,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TabButton(
              label: l10n.universityTabNews,
              tab: UniversityDetailTab.news,
              current: current,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.tab,
    required this.current,
  });

  final String label;
  final UniversityDetailTab tab;
  final UniversityDetailTab current;

  @override
  Widget build(BuildContext context) {
    final isSelected = tab == current;
    return GestureDetector(
      onTap: () => context.read<UniversityDetailCubit>().selectTab(tab),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.brandPrimary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.state, required this.university});

  final UniversityDetailState state;
  final University university;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (state.tab) {
      case UniversityDetailTab.description:
        return Column(
          children: [
            _LightCard(
              child: Text(
                university.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _ContactsCard(university: university),
            const SizedBox(height: 16),
            _AdmissionCard(university: university, l10n: l10n),
          ],
        );
      case UniversityDetailTab.programs:
        return Column(
          children: university.directions
              .map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _LightCard(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              p,
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        );
      case UniversityDetailTab.news:
        return SizedBox(
          height: 240,
          child: Center(
            child: Text(
              l10n.universityNewsEmpty,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textPrimary.withValues(alpha: 0.45),
              ),
            ),
          ),
        );
    }
  }
}

class _LightCard extends StatelessWidget {
  const _LightCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}

class _ContactsCard extends StatelessWidget {
  const _ContactsCard({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    return _LightCard(
      child: Column(
        children: [
          if (university.website.isNotEmpty)
            _ContactRow(
              icon: Icons.language_rounded,
              text: university.website,
            ),
          if (university.instagram.isNotEmpty) ...[
            const SizedBox(height: 16),
            _ContactRow(
              icon: Icons.camera_alt_outlined,
              text: university.instagram,
            ),
          ],
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textMuted,
        ),
      ],
    );
  }
}

class _AdmissionCard extends StatelessWidget {
  const _AdmissionCard({required this.university, required this.l10n});

  final University university;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final lines = <String>[
      if (university.minEnt != null) l10n.universityMinEnt(university.minEnt!),
      if (university.minGpa != null) l10n.universityMinGpa(university.minGpa!),
      if (university.minIelts != null)
        l10n.universityMinIelts(university.minIelts!),
      if (university.languages.isNotEmpty)
        '${l10n.universityLanguage}: ${university.languages.join(', ')}',
      if (university.format.isNotEmpty)
        '${l10n.universityFormat}: ${university.format}',
      if (university.duration.isNotEmpty)
        '${l10n.universityDuration}: ${university.duration}',
      if (university.costRange.isNotEmpty)
        '${l10n.universityCost}: ${university.costRange}',
    ];

    return _LightCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.universityAdmissionTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                line,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
