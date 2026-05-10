import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Логотип NOVA: квадрат с буквой «N» + надпись.
class NovaLogo extends StatelessWidget {
  const NovaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.authPrimaryLight,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Center(
            child: Text(
              'N',
              style: TextStyle(
                color: AppColors.textInverse,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'NOVA',
          style: TextStyle(
            color: AppColors.authPrimaryLight,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
