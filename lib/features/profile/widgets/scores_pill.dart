import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Блок баллов пользователя: GPA / IELTS / ЕНТ.
/// Всегда отображается — если балл не заполнен, показывает «—».
class ScoresPill extends StatelessWidget {
  const ScoresPill({
    super.key,
    required this.gpa,
    required this.ielts,
    required this.ent,
  });

  final String gpa;
  final String ielts;
  final String ent;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceMutedDark
            : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ScoreItem(
            label: 'GPA',
            value: gpa.isNotEmpty ? gpa : '—',
            color: gpa.isNotEmpty
                ? AppColors.brandAccent
                : AppColors.textMuted,
            isDark: isDark,
          ),
          _Separator(isDark: isDark),
          _ScoreItem(
            label: 'IELTS',
            value: ielts.isNotEmpty ? ielts : '—',
            color: ielts.isNotEmpty
                ? AppColors.brandPrimary
                : AppColors.textMuted,
            isDark: isDark,
          ),
          _Separator(isDark: isDark),
          _ScoreItem(
            label: l10n.profileScoresEnt,
            value: ent.isNotEmpty ? ent : '—',
            color: ent.isNotEmpty
                ? AppColors.warning
                : AppColors.textMuted,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  const _ScoreItem({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  final String label;
  final String value;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.textSecondary
                : AppColors.textMuted,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
    );
  }
}