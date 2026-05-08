import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Универсальное текстовое поле в стиле auth-флоу.
class AuthInputField extends StatelessWidget {
  const AuthInputField({
    super.key,
    required this.controller,
    required this.hint,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
    this.suffix,
    this.prefixIcon,
    this.hasError = false,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffix;
  final IconData? prefixIcon;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasError
              ? AppColors.danger.withValues(alpha: 0.4)
              : AppColors.divider,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.authHint, fontSize: 15),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: AppColors.authHint, size: 20)
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: suffix != null
              ? Padding(padding: const EdgeInsets.only(right: 14), child: suffix)
              : null,
          suffixIconConstraints: const BoxConstraints(),
        ),
      ),
    );
  }
}
