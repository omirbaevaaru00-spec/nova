import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTheme {
  // ── Shared ──────────────────────────────────────────────────────────────────

  static const _radius = 14.0;
  static const _buttonHeight = 52.0;

  static ButtonStyle _elevatedStyle(Color bg, Color fg, {Color? disabled}) =>
      ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor: disabled ?? AppColors.inactiveLight,
        disabledForegroundColor: AppColors.textInverse,
        elevation: 0,
        minimumSize: const Size(double.infinity, _buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      );

  static InputDecorationTheme _inputTheme(Color fill, Color hint) =>
      InputDecorationTheme(
        filled: true,
        fillColor: fill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide:
              const BorderSide(color: AppColors.brandAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: const BorderSide(color: AppColors.danger, width: 2),
        ),
        hintStyle: TextStyle(color: hint, fontSize: 15),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      );

  // ── Light ────────────────────────────────────────────────────────────────────

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'SF Pro Display', // подставь своё если есть
        scaffoldBackgroundColor: AppColors.surfaceMuted,
        colorScheme: const ColorScheme.light(
          primary: AppColors.brandAccent,
          primaryContainer: AppColors.brandPrimary,
          secondary: AppColors.brandPrimary,
          surface: AppColors.backgroundLight,
          error: AppColors.danger,
          onPrimary: AppColors.textPrimary,
          onSecondary: AppColors.textInverse,
          onSurface: AppColors.textPrimary,
          onError: AppColors.textInverse,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundLight,
          foregroundColor: AppColors.textPrimary,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.backgroundLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.border),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: _elevatedStyle(
            AppColors.brandAccent,
            AppColors.textPrimary,
            disabled: AppColors.inactiveLight,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.border, width: 1.5),
            elevation: 0,
            minimumSize: const Size(double.infinity, _buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        inputDecorationTheme: _inputTheme(
          AppColors.backgroundLight,
          AppColors.textMuted,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.backgroundLight,
          selectedItemColor: AppColors.brandAccent,
          unselectedItemColor: AppColors.textMuted,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
              TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
          space: 1,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceMuted,
          selectedColor: AppColors.brandAccent,
          disabledColor: AppColors.inactiveLight,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          side: const BorderSide(color: AppColors.border),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.brandAccent,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.brandAccent,
          foregroundColor: AppColors.textPrimary,
          elevation: 4,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.textPrimary,
          contentTextStyle: const TextStyle(color: AppColors.textInverse),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

  // ── Dark ─────────────────────────────────────────────────────────────────────

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.brandAccent,
          primaryContainer: AppColors.brandPrimary,
          secondary: AppColors.brandPrimary,
          surface: AppColors.surfaceMutedDark,
          error: AppColors.danger,
          onPrimary: AppColors.textPrimary,
          onSecondary: AppColors.textInverse,
          onSurface: AppColors.textInverse,
          onError: AppColors.textInverse,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundDark,
          foregroundColor: AppColors.textInverse,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.textInverse),
          titleTextStyle: TextStyle(
            color: AppColors.textInverse,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surfaceMutedDark,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Color(0xFF2C2F36)),
          ),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: _elevatedStyle(
            AppColors.brandAccent,
            AppColors.textPrimary,
            disabled: AppColors.inactive,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textInverse,
            side: const BorderSide(color: Color(0xFF3A3D44), width: 1.5),
            elevation: 0,
            minimumSize: const Size(double.infinity, _buttonHeight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.textMuted,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        inputDecorationTheme: _inputTheme(
          AppColors.surfaceMutedDark,
          AppColors.textSecondary,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surfaceMutedDark,
          selectedItemColor: AppColors.brandAccent,
          unselectedItemColor: AppColors.textMuted,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
              TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: TextStyle(fontSize: 11),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFF2C2F36),
          thickness: 1,
          space: 1,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.surfaceMutedDark,
          selectedColor: AppColors.brandAccent,
          disabledColor: AppColors.inactive,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textInverse,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          side: const BorderSide(color: Color(0xFF3A3D44)),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.brandAccent,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.brandAccent,
          foregroundColor: AppColors.textPrimary,
          elevation: 4,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.surfaceMutedDark,
          contentTextStyle: const TextStyle(color: AppColors.textInverse),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
}