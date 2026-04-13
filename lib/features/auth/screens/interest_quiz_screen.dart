import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../core/router/route_names.dart';

class InterestQuizScreen extends StatefulWidget {
  const InterestQuizScreen({super.key});

  @override
  State<InterestQuizScreen> createState() => _InterestQuizScreenState();
}

class _InterestQuizScreenState extends State<InterestQuizScreen> {
  final Set<int> _selected = {};

  void _toggle(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _selected.contains(index)
          ? _selected.remove(index)
          : _selected.add(index);
    });
  }

  void _proceed() {
    HapticFeedback.lightImpact();
    // TODO: сохранить выбранные интересы в UserRepository
    context.go(RouteNames.home);
  }

  void _skip() {
    HapticFeedback.selectionClick();
    context.go(RouteNames.home);
  }

  /// Список интересов берётся из локализации — реагирует на смену языка.
  List<(String, String)> _interests(AppLocalizations l10n) => [
    (l10n.interestIT,          '💻'),
    (l10n.interestMedicine,    '🩺'),
    (l10n.interestBusiness,    '📊'),
    (l10n.interestGrants,      '🎓'),
    (l10n.interestDesign,      '🎨'),
    (l10n.interestLaw,         '⚖️'),
    (l10n.interestPedagogy,    '📚'),
    (l10n.interestEngineering, '⚙️'),
    (l10n.interestBachelor,    '🏫'),
    (l10n.interestCollege,     '🏢'),
    (l10n.interestMaster,      '🎯'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final interests = _interests(l10n);

    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                // ── Верхняя часть ──────────────────────────────
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
                            color: Colors.white.withOpacity(0.12),
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
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 14,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),

                // ── Чипы интересов ─────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(interests.length, (i) {
                        final (label, emoji) = interests[i];
                        return _InterestChip(
                          label: '$emoji  $label',
                          isSelected: _selected.contains(i),
                          onTap: () => _toggle(i),
                        );
                      }),
                    ),
                  ),
                ),

                // ── Счётчик выбранных ──────────────────────────
                if (_selected.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(
                        '${l10n.quizSelected}: ${_selected.length}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                // ── Кнопки внизу ───────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: _BottomButton(
                          label: l10n.quizSkip,
                          color: Colors.white.withOpacity(0.15),
                          textColor: Colors.white,
                          onTap: _skip,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _BottomButton(
                          label: l10n.quizNext,
                          color: const Color(0xFF2ECC9A),
                          textColor: Colors.white,
                          onTap: _proceed,
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
              : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2ECC9A)
                : Colors.white.withOpacity(0.18),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.85),
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