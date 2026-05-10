import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stiky/data/onboarding/onboarding_repository.dart';
import 'package:stiky/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:stiky/features/onboarding/bloc/onboarding_event.dart';
import 'package:stiky/features/onboarding/bloc/onboarding_state.dart';

import '../../../../core/router/route_names.dart';
import '../../../../l10n/generated/app_localizations.dart';

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
                  Color(0xFF3B4FD8),
                  Color(0xFF2F3FBF),
                  Color(0xFF1E2D8A),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                isSelected: state.selectedIndexes.contains(i),
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
                  BlocBuilder<OnboardingBloc, OnboardingState>(
                    buildWhen: (prev, curr) =>
                        prev.selectedIndexes.length !=
                        curr.selectedIndexes.length,
                    builder: (context, state) {
                      if (state.selectedIndexes.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: Text(
                            '${l10n.quizSelected}: ${state.selectedIndexes.length}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: Row(
                      children: [
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
                        Expanded(
                          child: BlocBuilder<OnboardingBloc, OnboardingState>(
                            buildWhen: (prev, curr) =>
                                prev.status != curr.status,
                            builder: (context, state) {
                              if (state.status == OnboardingStatus.saving) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              }
                              return _BottomButton(
                                label: l10n.quizNext,
                                color: const Color(0xFF2ECC9A),
                                textColor: Colors.white,
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  context
                                      .read<OnboardingBloc>()
                                      .add(const OnboardingCompleted());
                                },
                              );
                            },
                          ),
                        ),
                      ],
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

class _InterestChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InterestChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2ECC9A)
              : Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2ECC9A)
                : Colors.white.withValues(alpha: 0.18),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.85),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _BottomButton extends StatefulWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

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
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
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