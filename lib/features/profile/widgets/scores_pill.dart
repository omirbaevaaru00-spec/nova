import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ScoresPill extends StatelessWidget {
  const ScoresPill({super.key, this.gpa, this.ielts, this.ent});

  final num? gpa;
  final num? ielts;
  final num? ent;

  static const _empty = '—';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ScoreText(label: 'gpa', value: gpa?.toString() ?? _empty),
          const _Separator(),
          _ScoreText(label: 'ielts', value: ielts?.toString() ?? _empty),
          const _Separator(),
          _ScoreText(label: 'ент', value: ent?.toString() ?? _empty),
        ],
      ),
    );
  }
}

class _ScoreText extends StatelessWidget {
  const _ScoreText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label : $value',
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return const Text(':', style: TextStyle(color: AppColors.textSecondary));
  }
}
