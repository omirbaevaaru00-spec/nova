// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stiky/data/onboarding/onboarding_repository.dart';


// class OnboardingRepositoryImpl implements OnboardingRepository {
//   static const String _kOnboardingCompletedKey = 'onboarding_completed';
//   static const String _kInterestsKey = 'user_interests';

//   final SharedPreferences _prefs;

//   OnboardingRepositoryImpl(this._prefs);

//   @override
//   Future<bool> isOnboardingCompleted() async {
//     return _prefs.getBool(_kOnboardingCompletedKey) ?? false;
//   }

//   @override
//   Future<void> completeOnboarding() async {
//     await _prefs.setBool(_kOnboardingCompletedKey, true);
//   }

//   @override
//   Future<List<String>> getSavedInterests() async {
//     return _prefs.getStringList(_kInterestsKey) ?? const [];
//   }

//   @override
//   Future<void> saveInterests(List<String> interestKeys) async {
//     await _prefs.setStringList(_kInterestsKey, interestKeys);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_repository.dart';

/// Реализация [OnboardingRepository] через SharedPreferences.
///
/// Ключи SharedPreferences:
/// - `onboarding_completed` — bool, пройден ли квиз
/// - `interests` — List<String>, выбранные интересы
class OnboardingRepositoryImpl implements OnboardingRepository {
  static const _keyCompleted = 'onboarding_completed';
  static const _keyInterests = 'interests';

  OnboardingRepositoryImpl(SharedPreferences prefs);

  @override
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyCompleted) ?? false;
  }

  @override
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyCompleted, true);
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
  }
}