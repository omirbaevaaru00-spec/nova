import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/favorites/favorites_repository_impl.dart';
import '../../../data/university/university_model.dart';
import '../../../data/university/university_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/favorites_cubit.dart';
import '../bloc/favorites_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => FavoritesCubit(
        favoritesRepository:
            FavoritesRepositoryImpl(FirebaseService.instance),
        universityRepository: context.read<UniversityRepository>(),
      )..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.screenFavorites)),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state.status == FavoritesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.items.isEmpty) {
              return _EmptyView(l10n: l10n);
            }
            return _FavoritesList(items: state.items);
          },
        ),
      ),
    );
  }
}

// ── Пустое состояние ─────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 56,
              color: isDark ? AppColors.textSecondary : AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.favoriteAuthSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color:
                    isDark ? AppColors.textSecondary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Список избранных ─────────────────────────────────────────────────────────

class _FavoritesList extends StatelessWidget {
  const _FavoritesList({required this.items});
  final List<University> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) =>
          _FavoriteCard(university: items[index]),
    );
  }
}

// ── Карточка избранного ───────────────────────────────────────────────────────

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({required this.university});
  final University university;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Локализация — берём язык интерфейса
    final locale = Localizations.localeOf(context).languageCode;

    return GestureDetector(
      onTap: () => context.push('/university/${university.id}'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceMutedDark
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Логотип / первая буква
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.backgroundDark
                    : AppColors.surfaceMuted,
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF2C2F36)
                      : AppColors.border,
                ),
              ),
              child: ClipOval(
                child: university.logoUrl.isNotEmpty
                    ? Image.network(
                        university.logoUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _Initial(name: university.name.localized(locale)),
                      )
                    : _Initial(
                        name: university.name.localized(locale),
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // Название и город
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // Используем .localized(locale) вместо прямого String
                    university.name.localized(locale),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textInverse
                          : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    university.city.localized(locale),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Стрелка
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: isDark ? AppColors.textSecondary : AppColors.textMuted,
            ),
          ],
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
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.brandAccent,
        ),
      ),
    );
  }
}