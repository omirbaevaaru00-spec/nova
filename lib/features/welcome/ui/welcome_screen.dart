import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/welcome_cubit.dart';
import '../bloc/welcome_state.dart';
import '../widgets/globe_painter.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WelcomeCubit(),
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.brandPrimary,
                AppColors.brandPrimaryDark,
                AppColors.brandPrimaryDeep,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                const Positioned(top: 12, right: 16, child: _LocaleSwitcher()),
                const Positioned.fill(child: _WelcomeContent()),
                Positioned(
                  bottom: 48,
                  left: 28,
                  right: 28,
                  child: _SkipButton(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.go(RouteNames.onboarding);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeContent extends StatelessWidget {
  const _WelcomeContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(
          l10n.appTitle,
          style: TextStyle(
            color: AppColors.textInverse,
            fontSize: 46,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            letterSpacing: -1.0,
            height: 1.0,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            l10n.welcomeDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textInverse.withValues(alpha: 0.85),
              fontSize: 15,
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Переключатель языка: ru → kk → en → ru ──────────────────────────────────

class _LocaleSwitcher extends StatelessWidget {
  const _LocaleSwitcher();

  /// Короткая метка языка для отображения в переключателе.
  /// l10n содержит готовые ru/kk варианты — для en добавляем своё значение,
  /// так как localeShortEn может быть не определён в .arb файлах.
  String _shortLabel(String languageCode, AppLocalizations l10n) {
    return switch (languageCode) {
      'kk' => l10n.localeShortKk,
      'en' => 'EN',
      _ => l10n.localeShortRu,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<WelcomeCubit, WelcomeState>(
      builder: (context, state) {
        final label = _shortLabel(state.locale.languageCode, l10n);
        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            context.read<WelcomeCubit>().toggleLocale();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.textInverse.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.textInverse.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CustomPaint(
                  size: Size(16, 16),
                  painter: GlobePainter(color: AppColors.textInverse),
                ),
                const SizedBox(width: 6),
                // AnimatedSwitcher для плавной смены метки языка
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: Text(
                    label,
                    key: ValueKey(label),
                    style: const TextStyle(
                      color: AppColors.textInverse,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Кнопка "Пропустить" ──────────────────────────────────────────────────────

class _SkipButton extends StatefulWidget {
  const _SkipButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_SkipButton> createState() => _SkipButtonState();
}

class _SkipButtonState extends State<_SkipButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.textInverse.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.textInverse.withValues(alpha: 0.25),
            ),
          ),
          child: Center(
            child: Text(
              l10n.welcomeSkip,
              style: const TextStyle(
                color: AppColors.textInverse,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}