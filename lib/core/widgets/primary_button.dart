import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Округлая кнопка с тенью в стиле auth-флоу.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool loading;
  final bool enabled;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  bool get _isInteractive => widget.enabled && !widget.loading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          _isInteractive ? (_) => setState(() => _pressed = true) : null,
      onTapUp: _isInteractive
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: widget.enabled ? AppColors.authPrimary : AppColors.authDisabled,
            borderRadius: BorderRadius.circular(28),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: AppColors.authPrimary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : const [],
          ),
          child: Center(
            child: widget.loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: AppColors.textInverse,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppColors.textInverse,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
