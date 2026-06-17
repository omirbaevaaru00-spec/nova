// import 'package:logger/logger.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'onboarding_repository.dart';

// /// Реализация [OnboardingRepository] через SharedPreferences.
// ///
// /// Ключи SharedPreferences:
// /// - `onboarding_completed` — bool, пройден ли квиз (или нажата "Пропустить")
// /// - `interests` — List<String>, выбранные интересы
// class OnboardingRepositoryImpl implements OnboardingRepository {
//   static const _keyCompleted = 'onboarding_completed';
//   static const _keyInterests = 'interests';
//   final _log = Logger();

//   OnboardingRepositoryImpl(SharedPreferences prefs);

//   @override
//   Future<bool> isOnboardingCompleted() async {
//     final prefs = await SharedPreferences.getInstance();
//     final value = prefs.getBool(_keyCompleted) ?? false;
//     _log.i('isOnboardingCompleted: $value');
//     return value;
//   }

//   @override
//   Future<void> completeOnboarding() async {
//     final prefs = await SharedPreferences.getInstance();
//     final ok = await prefs.setBool(_keyCompleted, true);
//     _log.i('completeOnboarding: записано = $ok');
//   }

//   @override
//   Future<List<String>> getSavedInterests() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList(_keyInterests) ?? [];
//   }

//   @override
//   Future<void> saveInterests(List<String> interestKeys) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList(_keyInterests, interestKeys);
//   }

//   /// Удаляет все локальные данные онбординга.
//   /// Вызывается при удалении аккаунта — пользователь
//   /// пройдёт квиз заново при следующей регистрации.
//   @override
//   Future<void> clearAll() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_keyCompleted);
//     await prefs.remove(_keyInterests);
//     _log.i('clearAll: onboarding-данные удалены');
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_repository.dart';

/// Реализация [OnboardingRepository] через SharedPreferences.
///
/// Ключи SharedPreferences:
/// - `onboarding_completed` — bool, пройден ли квиз (или нажата "Пропустить")
/// - `interests` — List<String>, выбранные интересы
class OnboardingRepositoryImpl implements OnboardingRepository {
  static const _keyCompleted = 'onboarding_completed';
  static const _keyInterests = 'interests';

  OnboardingRepositoryImpl(SharedPreferences prefs);

  @override
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(_keyCompleted) ?? false;
    debugPrint('🟢🟢🟢 isOnboardingCompleted: $value 🟢🟢🟢');
    return value;
  }

  @override
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setBool(_keyCompleted, true);
    debugPrint('🔵🔵🔵 completeOnboarding: записано = $ok 🔵🔵🔵');
  }

  @override
  Future<List<String>> getSavedInterests() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyInterests) ?? [];
  }

  @override
  Future<void> saveInterests(List<String> interestKeys) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyInterests, interestKeys);
  }

  /// Удаляет все локальные данные онбординга.
  /// Вызывается при удалении аккаунта — пользователь
  /// пройдёт квиз заново при следующей регистрации.
  @override
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCompleted);
    await prefs.remove(_keyInterests);
    debugPrint('🔴🔴🔴 clearAll: onboarding-данные удалены 🔴🔴🔴');
  }
}