import 'package:flutter/material.dart';

/// Единая палитра цветов приложения Sticky.
/// Все имена совместимы с текущим кодом проекта.
abstract class AppColors {
  // ─── Бренд-цвета ──────────────────────────────────────────────────────────
  static const Color brandPrimary     = Color(0xFF1A2B8A);
  static const Color brandPrimaryDark = Color(0xFF152270);
  static const Color brandPrimaryDeep = Color(0xFF0E1650);
  static const Color brandAccent      = Color(0xFF35E7C7);

  // ─── Фон ──────────────────────────────────────────────────────────────────
  static const Color backgroundLight  = Color(0xFFFFFFFF);
  static const Color backgroundDark   = Color(0xFF101010);
  static const Color surfaceMuted     = Color(0xFFF5F4FA);
  static const Color surfaceMutedDark = Color(0xFF242628);

  // ─── Авторизация ──────────────────────────────────────────────────────────
  /// Основная кнопка авторизации (бирюза)
  static const Color authPrimary      = brandAccent;
  /// AppBar / шапка (синий бренд)
  static const Color authPrimaryLight = brandPrimary;
  /// Placeholder / hint в полях ввода авторизации
  static const Color authHint         = Color(0xFF9CA3AF);
  /// Неактивная кнопка авторизации
  static const Color authDisabled     = Color(0xFFB2F0E8);

  // ─── Текст ────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF0A0A0A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted     = Color(0xFFB0B8C1);
  static const Color textInverse   = Color(0xFFFFFFFF);

  // ─── Компоненты ───────────────────────────────────────────────────────────
  static const Color border    = Color(0xFFE5E7EB);
  static const Color divider   = Color(0xFFEEEEEE);
  static const Color shadow    = Color(0x14000000);

  // ─── Семантика ────────────────────────────────────────────────────────────
  static const Color danger        = Color(0xFFFF0022);
  static const Color success       = Color(0xFF2ECC9A);
  /// Фоновый цвет для success-состояний (карточки, плашки)
  static const Color successSurface = Color(0xFFDFFAF4);
  static const Color warning       = Color(0xFFFFB300);

  // ─── Неактивные состояния ─────────────────────────────────────────────────
  static const Color inactive      = Color(0xFF2AA790);
  static const Color inactiveLight = Color(0xFF8FE4D0);
}