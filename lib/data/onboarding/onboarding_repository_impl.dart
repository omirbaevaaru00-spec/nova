import 'package:stiky/data/onboarding/onboardnig_repository.dart';

import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepositoryImpl implements OnboardnigRepository {
  OnboardingRepositoryImpl();

  static const String _onboardedKey = 'already_onboarded';

  @override
  Future<bool> alreadyOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardedKey) ?? false;
  }

  @override
  Future<void> onboarded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardedKey, true);
  }
}
