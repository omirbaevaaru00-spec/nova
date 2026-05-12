import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/university/university_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/reviews_cubit.dart';
import '../bloc/reviews_state.dart';

/// Отдельный экран отзывов университета.
/// Открывается с [UniversityDetailScreen] через context.push.
/// Остаётся внутри ShellRoute — нижний навбар виден.
class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key, required this.universityId});

  final String universityId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewsCubit(
        universityRepository: context.read<UniversityRepository>(),
      )..load(universityId),
      child: const _ReviewsView(),
    );
  }
}

class _ReviewsView extends StatelessWidget {
  const _ReviewsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF0EEF8);

    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bgColor,
          // ── AppBar ──────────────────────────────────────────
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: isDark ? AppColors.textInverse : AppColors.textPrimary,
              ),
            ),
            title: Text(
              state.universityName.isNotEmpty
                  ? '${l10n.universityTabReviews} · ${state.universityName}'
                  : l10n.universityTabReviews,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textInverse : AppColors.textPrimary,
              ),
            ),
          ),
          // ── FAB «+» ─────────────────────────────────────────
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddReviewSheet(context, isDark),
            backgroundColor: AppColors.brandAccent,
            foregroundColor: AppColors.backgroundDark,
            elevation: 4,
            child: const Icon(Icons.add_rounded, size: 28),
          ),
          // ── Body ────────────────────────────────────────────
          body: Builder(
            builder: (_) {
              if (state.status == ReviewsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.reviews.isEmpty) {
                return _EmptyView(isDark: isDark, l10n: l10n);
              }
              return _ReviewsList(
                reviews: state.reviews,
                isDark: isDark,
              );
            },
          ),
        );
      },
    );
  }

  void _showAddReviewSheet(BuildContext context, bool isDark) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<ReviewsCubit>(),
        child: _AddReviewSheet(isDark: isDark),
      ),
    );
  }
}

// ── Пустое состояние ──────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.isDark, required this.l10n});

  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.surfaceMutedDark
                    : AppColors.backgroundLight,
              ),
              child: Icon(
                Icons.rate_review_outlined,
                size: 36,
                color: isDark ? AppColors.textSecondary : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.reviewsEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textInverse : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.reviewsEmptyHint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Список отзывов ────────────────────────────────────────────────────────────

class _ReviewsList extends StatelessWidget {
  const _ReviewsList({required this.reviews, required this.isDark});

  final List<UniversityReview> reviews;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) =>
          _ReviewCard(review: reviews[i], isDark: isDark),
    );
  }
}

// ── Карточка отзыва ───────────────────────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.isDark});

  final UniversityReview review;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark
        ? AppColors.surfaceMutedDark
        : AppColors.backgroundLight;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Строка: аватар + имя + дата ─────────────────────
          Row(
            children: [
              _Avatar(
                name: review.authorName,
                photoUrl: review.authorPhotoUrl,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textInverse
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${review.speciality} · ${review.year}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Дата
              Text(
                DateFormat('dd.MM.yy').format(review.createdAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ── Звёзды ──────────────────────────────────────────
          _StarRow(rating: review.rating),
          const SizedBox(height: 10),
          // ── Текст отзыва ────────────────────────────────────
          Text(
            review.text,
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: isDark
                  ? AppColors.textInverse.withValues(alpha: 0.9)
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.photoUrl});

  final String name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.brandAccent.withValues(alpha: 0.18),
      backgroundImage:
          photoUrl != null ? NetworkImage(photoUrl!) : null,
      child: photoUrl == null
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppColors.brandAccent,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            )
          : null,
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final fill = math.min(1.0, math.max(0.0, rating - i));
          return Icon(
            fill >= 1.0
                ? Icons.star_rounded
                : fill >= 0.5
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            size: 15,
            color: const Color(0xFFFFC107),
          );
        }),
        const SizedBox(width: 6),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ── Bottomsheet добавления отзыва ─────────────────────────────────────────────

class _AddReviewSheet extends StatefulWidget {
  const _AddReviewSheet({required this.isDark});

  final bool isDark;

  @override
  State<_AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<_AddReviewSheet> {
  double _rating = 5;
  final _textCtrl = TextEditingController();
  final _specialityCtrl = TextEditingController();
  int _year = DateTime.now().year;

  @override
  void dispose() {
    _textCtrl.dispose();
    _specialityCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _textCtrl.text.trim();
    if (text.isEmpty) return;
    final review = UniversityReview(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'Вы',
      authorPhotoUrl: null,
      rating: _rating,
      text: text,
      year: _year,
      speciality: _specialityCtrl.text.trim().isNotEmpty
          ? _specialityCtrl.text.trim()
          : '—',
      createdAt: DateTime.now(),
    );
    context.read<ReviewsCubit>().submitReview(review);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bg = widget.isDark
        ? AppColors.surfaceMutedDark
        : AppColors.backgroundLight;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.reviewsAdd,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: widget.isDark
                      ? AppColors.textInverse
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              // Звёзды
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) {
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _rating = (i + 1).toDouble()),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Icon(
                          _rating > i
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 38,
                          color: const Color(0xFFFFC107),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              _Field(
                controller: _specialityCtrl,
                hint: l10n.reviewSpeciality,
                isDark: widget.isDark,
              ),
              const SizedBox(height: 12),
              _YearPicker(
                year: _year,
                isDark: widget.isDark,
                onChanged: (y) => setState(() => _year = y),
                l10n: l10n,
              ),
              const SizedBox(height: 12),
              _Field(
                controller: _textCtrl,
                hint: l10n.reviewText,
                maxLines: 4,
                isDark: widget.isDark,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandAccent,
                    foregroundColor: AppColors.backgroundDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.reviewsSubmit,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.isDark,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final bool isDark;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: isDark ? AppColors.textInverse : AppColors.textPrimary,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: isDark
            ? AppColors.backgroundDark.withValues(alpha: 0.5)
            : AppColors.surfaceMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _YearPicker extends StatelessWidget {
  const _YearPicker({
    required this.year,
    required this.isDark,
    required this.onChanged,
    required this.l10n,
  });

  final int year;
  final bool isDark;
  final ValueChanged<int> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final years = List.generate(10, (i) => DateTime.now().year - i);
    return DropdownButtonFormField<int>(
      value: year,
      decoration: InputDecoration(
        labelText: l10n.reviewYear,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: isDark
            ? AppColors.backgroundDark.withValues(alpha: 0.5)
            : AppColors.surfaceMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dropdownColor: isDark
          ? AppColors.surfaceMutedDark
          : AppColors.backgroundLight,
      style: TextStyle(
        color: isDark ? AppColors.textInverse : AppColors.textPrimary,
        fontSize: 15,
      ),
      items: years
          .map((y) => DropdownMenuItem(value: y, child: Text('$y')))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}