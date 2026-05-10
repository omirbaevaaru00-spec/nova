import 'package:flutter/material.dart';

/// Палитра приложения. В виджетах используем только токены отсюда —
/// никаких `Color(0xFF…)` в UI-коде.
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────
  static const Color brandPrimary = Color(0xFF3B4FD8);
  static const Color brandPrimaryDark = Color(0xFF2F3FBF);
  static const Color brandPrimaryDeep = Color(0xFF1E2D8A);
  static const Color brandAccent = Color(0xFF2ECC9A);

  // ── Surfaces ─────────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF101010);
  static const Color surfaceDark = Color(0xFF1C1C1E);
  static const Color surfaceMuted = Color(0xFFF0EEF8);
  static const Color surfaceMutedDark = Color(0xFF2C2F36);

  // ── Text ─────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFBBBBBB);

  // ── Status ───────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color successSurface = Color(0xFFE8F5E9);
  static const Color danger = Color(0xFFE53935);
  static const Color info = Color(0xFF1DA1F2);
  static const Color warning = Color(0xFFA8123B);

  // ── Borders / Dividers ───────────────────────────────────────
  static const Color border = Color(0xFFE0DDEF);
  static const Color divider = Color(0xFFDDDBEE);

  // ── Auth-flow specific (deep purple variants) ────────────────
  static const Color authPrimary = Color(0xFF2B2B8A);
  static const Color authPrimaryLight = Color(0xFF3B3B8E);
  static const Color authHint = Color(0xFF9E9CBB);
  static const Color authDisabled = Color(0xFFAAAAAA);
}
