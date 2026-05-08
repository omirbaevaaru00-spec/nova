import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/favorites/favorites_repository.dart';
import '../../../data/university/university_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../favorites/global_favorites_notifier.dart';

/// Карточка университета в ленте. Лайк работает через глобальный
/// [GlobalFavoritesNotifier], для незалогиненных открывает auth-bottom-sheet.
class UniversityFeedCard extends StatelessWidget {
  const UniversityFeedCard({
    super.key,
    required this.university,
    required this.onTap,
  });

  final University university;
  final VoidCallback onTap;

  Future<void> _handleLike(BuildContext context) async {
    HapticFeedback.lightImpact();
    try {
      await GlobalFavoritesNotifier.instance.toggle(university.id);
    } on NotAuthenticatedException {
      if (!context.mounted) return;
      _showAuthSheet(context);
    }
  }

  void _showAuthSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(
              Icons.favorite_rounded,
              color: AppColors.danger,
              size: 44,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.favoriteAuthRequired,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.favoriteAuthSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(sheetContext);
                  context.push(RouteNames.register);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.authPrimary,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: Text(
                      l10n.actionRegister,
                      style: const TextStyle(
                        color: AppColors.textInverse,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => Navigator.pop(sheetContext),
              child: Text(
                l10n.actionLater,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(university: university, l10n: l10n),
            _HeroImage(imageUrl: university.imageUrl),
            if (university.directions.isNotEmpty)
              _DirectionsRow(directions: university.directions),
            _Footer(university: university, onLikeTap: () => _handleLike(context)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.university, required this.l10n});

  final University university;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          _LogoCircle(university: university),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  university.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    _TypeChip(university: university, l10n: l10n),
                    const SizedBox(width: 6),
                    Text(
                      university.city,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoCircle extends StatelessWidget {
  const _LogoCircle({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: ClipOval(
        child: university.logoUrl.isNotEmpty
            ? Image.network(
                university.logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _Initials(name: university.name),
              )
            : _Initials(name: university.name),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';
    return Container(
      color: AppColors.authPrimaryLight,
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: AppColors.textInverse,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.university, required this.l10n});

  final University university;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isState = university.type == 'гос';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: isState ? AppColors.successSurface : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isState ? l10n.universityTypeStateShort : l10n.universityTypePrivateShort,
        style: TextStyle(
          color: isState ? AppColors.success : AppColors.warning,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          imageUrl,
          width: double.infinity,
          height: 190,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              height: 190,
              color: AppColors.surfaceMuted,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.authPrimaryLight,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (_, _, _) => Container(
            height: 190,
            color: AppColors.surfaceMuted,
            child: const Icon(
              Icons.school_outlined,
              color: AppColors.authPrimaryLight,
              size: 48,
            ),
          ),
        ),
      ),
    );
  }
}

class _DirectionsRow extends StatelessWidget {
  const _DirectionsRow({required this.directions});

  final List<String> directions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          for (final d in directions.take(3))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                d,
                style: const TextStyle(
                  color: AppColors.authPrimaryLight,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.university, required this.onLikeTap});

  final University university;
  final VoidCallback onLikeTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            university.costRange,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          ValueListenableBuilder<Set<String>>(
            valueListenable: GlobalFavoritesNotifier.instance,
            builder: (_, favorites, _) {
              final isFav = favorites.contains(university.id);
              return GestureDetector(
                onTap: onLikeTap,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isFav
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey(isFav),
                    color: isFav ? AppColors.danger : AppColors.textMuted,
                    size: 26,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
