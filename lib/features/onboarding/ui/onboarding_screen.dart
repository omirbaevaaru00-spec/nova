import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stiky/data/onboarding/onboarding_repository.dart';
import 'package:stiky/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:stiky/features/onboarding/bloc/onboarding_event.dart';
import 'package:stiky/features/onboarding/bloc/onboarding_state.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(
        context.read<OnboardingRepository>(),
      )..add(const OnboardingStarted()),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  List<(String, String)> _interests(AppLocalizations l10n) => [
        (l10n.interestIT, '💻'),
        (l10n.interestMedicine, '🩺'),
        (l10n.interestBusiness, '📊'),
        (l10n.interestGrants, '🎓'),
        (l10n.interestDesign, '🎨'),
        (l10n.interestLaw, '⚖️'),
        (l10n.interestPedagogy, '📚'),
        (l10n.interestEngineering, '⚙️'),
        (l10n.interestBachelor, '🏫'),
        (l10n.interestCollege, '🏢'),
        (l10n.interestMaster, '🎯'),
      ];

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final interests = _interests(l10n);

    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == OnboardingStatus.finished) {
          context.go(RouteNames.home);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        // Тёмная тема — синий градиент, статус-бар светлый.
        // Светлая тема — светлый фон как на главной, статус-бар тёмный.
        value: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: isDark ? null : AppColors.surfaceMuted,
          // ── Тёмная тема: фирменный синий градиент ──────────────
          // ── Светлая тема: нейтральный фон главной страницы ─────
          body: isDark
              ? _buildBlueGradientBody(context, l10n, interests)
              : _buildLightSurfaceBody(context, l10n, interests),
        ),
      ),
    );
  }

  // ── Тёмная тема — синий градиент ───────────────────────────────
  Widget _buildBlueGradientBody(
    BuildContext context,
    AppLocalizations l10n,
    List<(String, String)> interests,
  ) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandPrimary,
            AppColors.brandPrimaryDark,
            AppColors.brandPrimaryDeep,
          ],
        ),
      ),
      child: _OnboardingContent(
        interests: interests,
        l10n: l10n,
        onBack: () => _handleBack(context),
        isDark: true,
        textColor: Colors.white,
        subtitleColor: Colors.white.withValues(alpha: 0.65),
        chipBg: Colors.white.withValues(alpha: 0.12),
        chipBorder: Colors.white.withValues(alpha: 0.22),
        chipText: Colors.white.withValues(alpha: 0.88),
        chipSelectedText: AppColors.backgroundDark,
        backBg: Colors.white.withValues(alpha: 0.15),
        backBorder: Colors.white.withValues(alpha: 0.28),
        backIcon: Colors.white,
        skipBg: Colors.white.withValues(alpha: 0.15),
        skipBorder: Colors.white.withValues(alpha: 0.30),
        skipText: Colors.white,
        counterColor: Colors.white.withValues(alpha: 0.55),
      ),
    );
  }

  // ── Светлая тема — фон как на главной странице ─────────────────
  Widget _buildLightSurfaceBody(
    BuildContext context,
    AppLocalizations l10n,
    List<(String, String)> interests,
  ) {
    return _OnboardingContent(
      interests: interests,
      l10n: l10n,
      onBack: () => _handleBack(context),
      isDark: false,
      textColor: AppColors.textPrimary,
      subtitleColor: AppColors.textSecondary,
      chipBg: AppColors.backgroundLight,
      chipBorder: AppColors.border,
      chipText: AppColors.textSecondary,
      chipSelectedText: AppColors.backgroundDark,
      backBg: AppColors.backgroundLight,
      backBorder: AppColors.border,
      backIcon: AppColors.textPrimary,
      skipBg: AppColors.backgroundLight,
      skipBorder: AppColors.border,
      skipText: AppColors.textPrimary,
      counterColor: AppColors.textMuted,
    );
  }
}

// ─── Общий контент ────────────────────────────────────────────────────────────

class _OnboardingContent extends StatelessWidget {
  const _OnboardingContent({
    required this.interests,
    required this.l10n,
    required this.onBack,
    required this.isDark,
    required this.textColor,
    required this.subtitleColor,
    required this.chipBg,
    required this.chipBorder,
    required this.chipText,
    required this.chipSelectedText,
    required this.backBg,
    required this.backBorder,
    required this.backIcon,
    required this.skipBg,
    required this.skipBorder,
    required this.skipText,
    required this.counterColor,
  });

  final List<(String, String)> interests;
  final AppLocalizations l10n;
  final VoidCallback onBack;
  final bool isDark;
  final Color textColor;
  final Color subtitleColor;
  final Color chipBg;
  final Color chipBorder;
  final Color chipText;
  final Color chipSelectedText;
  final Color backBg;
  final Color backBorder;
  final Color backIcon;
  final Color skipBg;
  final Color skipBorder;
  final Color skipText;
  final Color counterColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Шапка ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Кнопка назад
                GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: backBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: backBorder),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: backIcon,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Заголовок — центрирован
                Center(
                  child: Text(
                    l10n.quizTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Подзаголовок — центрирован
                Center(
                  child: Text(
                    l10n.quizSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // ── Чипы — центрированы ──────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<OnboardingBloc, OnboardingState>(
                buildWhen: (prev, curr) =>
                    prev.selectedIndexes != curr.selectedIndexes,
                builder: (context, state) {
                  return Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(interests.length, (i) {
                        final (label, emoji) = interests[i];
                        final isSelected =
                            state.selectedIndexes.contains(i);
                        return _InterestChip(
                          label: '$emoji  $label',
                          isSelected: isSelected,
                          chipBg: chipBg,
                          chipBorder: chipBorder,
                          chipText:
                              isSelected ? chipSelectedText : chipText,
                          isDark: isDark,
                          onTap: () {
                            HapticFeedback.selectionClick();
                            context.read<OnboardingBloc>().add(
                                  OnboardingInterestToggled(i),
                                );
                          },
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ),

          // ── Счётчик ─────────────────────────────────────────────
          BlocBuilder<OnboardingBloc, OnboardingState>(
            buildWhen: (prev, curr) =>
                prev.selectedIndexes.length !=
                curr.selectedIndexes.length,
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: state.selectedIndexes.isEmpty
                    ? const SizedBox(height: 8, key: ValueKey('empty'))
                    : Padding(
                        key: ValueKey(state.selectedIndexes.length),
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: Text(
                            '${l10n.quizSelected}: '
                            '${state.selectedIndexes.length}',
                            style: TextStyle(
                              color: counterColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
              );
            },
          ),

          // ── Кнопки внизу ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: BlocBuilder<OnboardingBloc, OnboardingState>(
              builder: (context, state) {
                final hasSelection = state.selectedIndexes.isNotEmpty;
                final isSaving =
                    state.status == OnboardingStatus.saving;

                return Row(
                  children: [
                    // Пропустить
                    Expanded(
                      child: _BottomBtn(
                        label: l10n.quizSkip,
                        bg: skipBg,
                        border: skipBorder,
                        textColor: skipText,
                        isDark: isDark,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.read<OnboardingBloc>().add(
                                const OnboardingSkipped(),
                              );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Далее
                    Expanded(
                      child: isSaving
                          ? const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.brandAccent,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            )
                          : _BottomBtn(
                              label: l10n.quizNext,
                              bg: hasSelection
                                  ? AppColors.brandAccent
                                  : AppColors.brandAccent
                                      .withValues(alpha: 0.28),
                              border: Colors.transparent,
                              textColor: hasSelection
                                  ? AppColors.backgroundDark
                                  : AppColors.backgroundDark
                                      .withValues(alpha: 0.35),
                              isDark: isDark,
                              onTap: hasSelection
                                  ? () {
                                      HapticFeedback.lightImpact();
                                      context
                                          .read<OnboardingBloc>()
                                          .add(const OnboardingCompleted());
                                    }
                                  : null,
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Чип ─────────────────────────────────────────────────────────────────────

class _InterestChip extends StatefulWidget {
  const _InterestChip({
    required this.label,
    required this.isSelected,
    required this.chipBg,
    required this.chipBorder,
    required this.chipText,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final Color chipBg;
  final Color chipBorder;
  final Color chipText;
  final bool isDark;
  final VoidCallback onTap;

  @override
  State<_InterestChip> createState() => _InterestChipState();
}

class _InterestChipState extends State<_InterestChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.brandAccent
                : widget.chipBg,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.brandAccent
                  : widget.chipBorder,
              width: 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color:
                          AppColors.brandAccent.withValues(alpha: 0.28),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : (widget.isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.chipText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Нижняя кнопка ───────────────────────────────────────────────────────────

class _BottomBtn extends StatefulWidget {
  const _BottomBtn({
    required this.label,
    required this.bg,
    required this.border,
    required this.textColor,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final Color bg;
  final Color border;
  final Color textColor;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  State<_BottomBtn> createState() => _BottomBtnState();
}

class _BottomBtnState extends State<_BottomBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onTap == null;
    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: disabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            },
      onTapCancel:
          disabled ? null : () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 52,
          decoration: BoxDecoration(
            color: widget.bg,
            borderRadius: BorderRadius.circular(26),
            border: widget.border != Colors.transparent
                ? Border.all(color: widget.border, width: 1.5)
                : null,
            boxShadow: (!widget.isDark &&
                    widget.bg != AppColors.brandAccent &&
                    widget.border != Colors.transparent)
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}