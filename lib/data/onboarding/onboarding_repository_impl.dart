import 'package:shared_preferences/shared_preferences.dart';
import 'package:stiky/data/onboarding/onboarding_repository.dart';


class OnboardingRepositoryImpl implements OnboardingRepository {
  static const String _kOnboardingCompletedKey = 'onboarding_completed';
  static const String _kInterestsKey = 'user_interests';

  final SharedPreferences _prefs;

  OnboardingRepositoryImpl(this._prefs);

  @override
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(_kOnboardingCompletedKey) ?? false;
  }

  @override
  Future<void> completeOnboarding() async {
    await _prefs.setBool(_kOnboardingCompletedKey, true);
  }

  @override
  Future<List<String>> getSavedInterests() async {
    return _prefs.getStringList(_kInterestsKey) ?? const [];
  }

  @override
  Future<void> saveInterests(List<String> interestKeys) async {
    await _prefs.setStringList(_kInterestsKey, interestKeys);
  }
}