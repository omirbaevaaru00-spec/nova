import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Контроллер языка приложения.
class LocaleController extends ChangeNotifier {
  static LocaleController _instance = LocaleController._();
  static LocaleController get instance => _instance;
  LocaleController._();

  /// Только для тестов — пересоздаёт синглтон.
  static void resetForTest() {
    _instance = LocaleController._();
  }

  static const _key = 'app_language';
  static const _supportedCodes = ['ru', 'kk'];

  Locale _locale = const Locale('ru');
  Locale get locale => _locale;

  /// Инициализация: определяет язык при старте приложения.
Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString(_key);

  if (saved != null && _supportedCodes.contains(saved)) {
    _locale = Locale(saved);
  } else {
    // Безопасное получение языка устройства
    final deviceCode = PlatformDispatcher.instance.locale.languageCode;
    _locale = _supportedCodes.contains(deviceCode)
        ? Locale(deviceCode)
        : const Locale('ru');
    await prefs.setString(_key, _locale.languageCode);
  }
  notifyListeners();
}
  /// Смена языка пользователем.
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }
}