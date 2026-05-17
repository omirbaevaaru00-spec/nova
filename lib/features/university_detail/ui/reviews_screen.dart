import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/university/university_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/reviews_cubit.dart';
import '../bloc/reviews_state.dart';

/// Экран отзывов университета.
/// Открывается из UniversityDetailScreen через context.push('/university/:id/reviews').
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

// ─── Основной вид ─────────────────────────────────────────────────────────────

class _ReviewsView extends StatelessWidget {
  const _ReviewsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : const Color(0xFFF0EEF8);

    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: bgColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(
                Icons.arrow_back_rounded,
                color:
                    isDark ? AppColors.textInverse : AppColors.textPrimary,
              ),
            ),
            title: Text(
              state.universityName.isNotEmpty
                  ? '${l10n.universityTabReviews} · ${state.universityName}'
                  : l10n.universityTabReviews,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color:
                    isDark ? AppColors.textInverse : AppColors.textPrimary,
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddReviewSheet(context, isDark),
            backgroundColor: AppColors.brandAccent,
            foregroundColor: AppColors.backgroundDark,
            elevation: 4,
            child: const Icon(Icons.add_rounded, size: 28),
          ),
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

// ─── Пустое состояние ─────────────────────────────────────────────────────────

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
                color:
                    isDark ? AppColors.textSecondary : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.reviewsEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color:
                    isDark ? AppColors.textInverse : AppColors.textPrimary,
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

// ─── Список отзывов ───────────────────────────────────────────────────────────

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

// ─── Карточка отзыва ──────────────────────────────────────────────────────────

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.isDark});

  final UniversityReview review;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardColor =
        isDark ? AppColors.surfaceMutedDark : AppColors.backgroundLight;

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
          // Аватар + имя + дата
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
          _StarRow(rating: review.rating),
          const SizedBox(height: 10),
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

// ─── Аватар ───────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.photoUrl});

  final String name;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.brandAccent.withValues(alpha: 0.18),
      backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
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

// ─── Строка звёзд (для отображения в карточке) ────────────────────────────────

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
            color: AppColors.warning,
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

// ─── Bottomsheet добавления отзыва ────────────────────────────────────────────

class _AddReviewSheet extends StatefulWidget {
  const _AddReviewSheet({required this.isDark});

  final bool isDark;

  @override
  State<_AddReviewSheet> createState() => _AddReviewSheetState();
}

class _AddReviewSheetState extends State<_AddReviewSheet> {
  /// Рейтинг 0 = не выбрано (звёзды пустые по умолчанию).
  double _rating = 0;
  bool _isSubmitting = false;

  final _textCtrl = TextEditingController();
  final _specialityCtrl = TextEditingController();
  int _year = DateTime.now().year;

  @override
  void dispose() {
    _textCtrl.dispose();
    _specialityCtrl.dispose();
    super.dispose();
  }

  /// Кнопка активна только если выбран рейтинг И написан текст.
  bool get _canSubmit =>
      _rating > 0 && _textCtrl.text.trim().isNotEmpty && !_isSubmitting;

  Future<void> _submit() async {
    if (!_canSubmit) return;

    setState(() => _isSubmitting = true);

    // Берём ник из Firebase Auth — не хардкодим «Вы».
    final user = FirebaseService.instance.auth.currentUser;
    final nickname = _resolveNickname(user);
    final photoUrl = user?.photoURL;

    final review = UniversityReview(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: nickname,
      authorPhotoUrl: photoUrl,
      rating: _rating,
      text: _textCtrl.text.trim(),
      year: _year,
      speciality: _specialityCtrl.text.trim().isNotEmpty
          ? _specialityCtrl.text.trim()
          : '—',
      createdAt: DateTime.now(),
    );

    try {
      await context.read<ReviewsCubit>().submitReview(review);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }

    if (!mounted) return;
    Navigator.of(context).pop();

    // Красивое уведомление после закрытия шторки.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: AppColors.brandAccent,
              size: 20,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Спасибо за ваш отзыв!',
                style: TextStyle(
                  color: AppColors.textInverse,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Определяет ник: displayName → часть email до @ → «Аноним».
  String _resolveNickname(dynamic user) {
    if (user == null) return 'Аноним';
    final displayName = user.displayName as String?;
    if (displayName != null && displayName.trim().isNotEmpty) {
      return displayName.trim();
    }
    final email = user.email as String?;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return 'Аноним';
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

              // Заголовок
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
              const SizedBox(height: 6),
              Text(
                'Выберите оценку и напишите отзыв',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),

              // ── Звёзды (пустые по умолчанию, анимированные) ──────────────
              Center(
                child: _AnimatedStarPicker(
                  rating: _rating,
                  onChanged: (r) {
                    HapticFeedback.selectionClick();
                    setState(() => _rating = r);
                  },
                ),
              ),

              // Подпись под звёздами
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _rating > 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: Text(
                            _ratingLabel(_rating),
                            key: ValueKey(_rating),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.brandAccent,
                            ),
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Center(
                          child: Text(
                            'Коснитесь звезды для оценки',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),

              // Специальность
              _Field(
                controller: _specialityCtrl,
                hint: l10n.reviewSpeciality,
                isDark: widget.isDark,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),

              // Год
              _YearPicker(
                year: _year,
                isDark: widget.isDark,
                onChanged: (y) => setState(() => _year = y),
                l10n: l10n,
              ),
              const SizedBox(height: 12),

              // Текст отзыва
              _Field(
                controller: _textCtrl,
                hint: l10n.reviewText,
                maxLines: 4,
                isDark: widget.isDark,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),

              // ── Кнопка «Опубликовать» (неактивна пока не выбраны звёзды и текст) ──
              AnimatedOpacity(
                opacity: _canSubmit ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 250),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _canSubmit ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandAccent,
                      foregroundColor: AppColors.backgroundDark,
                      disabledBackgroundColor:
                          AppColors.brandAccent.withValues(alpha: 0.5),
                      disabledForegroundColor: AppColors.backgroundDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.backgroundDark,
                            ),
                          )
                        : Text(
                            l10n.reviewsSubmit,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
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

  /// Текстовая подпись для рейтинга.
  String _ratingLabel(double r) {
    if (r >= 5) return '⭐ Отлично';
    if (r >= 4) return '👍 Хорошо';
    if (r >= 3) return '😐 Нормально';
    if (r >= 2) return '👎 Плохо';
    return '😞 Очень плохо';
  }
}

// ─── Анимированный выбор звёзд ────────────────────────────────────────────────

/// Строка из 5 звёзд с пружинной анимацией при выборе.
/// Изначально все пустые (rating == 0).
class _AnimatedStarPicker extends StatelessWidget {
  const _AnimatedStarPicker({
    required this.rating,
    required this.onChanged,
  });

  final double rating;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starValue = (i + 1).toDouble();
        final isFilled = rating >= starValue;
        return GestureDetector(
          onTap: () => onChanged(starValue),
          child: TweenAnimationBuilder<double>(
            // Ключ перестраивает анимацию при каждом изменении состояния звезды.
            key: ValueKey('star_${i}_$isFilled'),
            tween: Tween(begin: isFilled ? 0.6 : 1.0, end: isFilled ? 1.25 : 1.0),
            duration: const Duration(milliseconds: 350),
            curve: Curves.elasticOut,
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: child,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                size: 40,
                color: isFilled ? AppColors.warning : AppColors.textMuted,
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Поле ввода ───────────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.isDark,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final bool isDark;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.brandAccent,
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

// ─── Выбор года ───────────────────────────────────────────────────────────────

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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.brandAccent,
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dropdownColor:
          isDark ? AppColors.surfaceMutedDark : AppColors.backgroundLight,
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