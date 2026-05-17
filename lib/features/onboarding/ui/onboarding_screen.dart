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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final interests = _interests(l10n);

    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (context, state) {
        if (state.status == OnboardingStatus.finished) {
          context.go(RouteNames.home);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          body: Container(
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
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Шапка ──────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          l10n.quizTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.quizSubtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.65),
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),

                  // ── Чипы интересов ─────────────────────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BlocBuilder<OnboardingBloc, OnboardingState>(
                        buildWhen: (prev, curr) =>
                            prev.selectedIndexes != curr.selectedIndexes,
                        builder: (context, state) {
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(interests.length, (i) {
                              final (label, emoji) = interests[i];
                              return _InterestChip(
                                label: '$emoji  $label',
                                isSelected:
                                    state.selectedIndexes.contains(i),
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  context
                                      .read<OnboardingBloc>()
                                      .add(OnboardingInterestToggled(i));
                                },
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ),

                  // ── Счётчик выбранных ───────────────────────────────────
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
                                    '${l10n.quizSelected}: ${state.selectedIndexes.length}',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                      );
                    },
                  ),

                  // ── Кнопки внизу ───────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: BlocBuilder<OnboardingBloc, OnboardingState>(
                      builder: (context, state) {
                        final hasSelection =
                            state.selectedIndexes.isNotEmpty;
                        final isSaving =
                            state.status == OnboardingStatus.saving;

                        return Row(
                          children: [
                            // Кнопка «Пропустить»
                            Expanded(
                              child: _BottomButton(
                                label: l10n.quizSkip,
                                color: Colors.white.withValues(alpha: 0.15),
                                textColor: Colors.white,
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  context
                                      .read<OnboardingBloc>()
                                      .add(const OnboardingSkipped());
                                },
                              ),
                            ),
                            const SizedBox(width: 10),

                            // Кнопка «Далее» — неактивна пока ничего не выбрано
                            Expanded(
                              child: isSaving
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : _BottomButton(
                                      label: l10n.quizNext,
                                      // Цвет меняется в зависимости от выбора
                                      color: hasSelection
                                          ? AppColors.brandAccent
                                          : AppColors.brandAccent
                                              .withValues(alpha: 0.35),
                                      textColor: hasSelection
                                          ? AppColors.backgroundDark
                                          : AppColors.backgroundDark
                                              .withValues(alpha: 0.4),
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
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Чип интереса с анимацией ─────────────────────────────────────────────────

/// Анимированный чип выбора интереса.
/// При нажатии — масштаб + плавная смена цвета + свечение.
class _InterestChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InterestChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_InterestChip> createState() => _InterestChipState();
}

class _InterestChipState extends State<_InterestChip>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
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
      onTapDown: (_) {
        setState(() => _pressed = true);
        _ctrl.forward();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        _ctrl.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.brandAccent
                : Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.brandAccent
                  : Colors.white.withValues(alpha: 0.20),
              width: 1.5,
            ),
            // Свечение при выборе
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.brandAccent.withValues(alpha: 0.40),
                      blurRadius: 14,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.isSelected
                  ? AppColors.backgroundDark
                  : Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Нижняя кнопка ────────────────────────────────────────────────────────────

class _BottomButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color textColor;

  /// Если null — кнопка визуально неактивна (onTap не вызывается).
  final VoidCallback? onTap;

  const _BottomButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<_BottomButton> createState() => _BottomButtonState();
}

class _BottomButtonState extends State<_BottomButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onTap == null;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap?.call();
            },
      onTapCancel: isDisabled
          ? null
          : () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 50,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(25),
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