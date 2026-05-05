import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:stiky/data/onboarding/onboarding_repository.dart';

import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required OnboardingRepository onboardnigRepository})
    : _onboardnigRepository = onboardnigRepository,
      super(SplashStateInitial());

  final OnboardingRepository _onboardnigRepository;
  final _logger = Logger();

  static const _minSplashDuration = Duration(milliseconds: 1800);

  Future<void> checkAuth() async {}

  Future<void> checkOnboarding() async {
    try {
      final stopwatch = Stopwatch()..start();

      final alreadyOnboarded = await _onboardnigRepository.isOnboardingCompleted();

      final elapsed = stopwatch.elapsed;
      if (elapsed < _minSplashDuration) {
        await Future.delayed(_minSplashDuration - elapsed);
      }

      if (alreadyOnboarded) {
        emit(SplashStateAlreadyOnboarded());
      } else {
        emit(SplashStateShouldOnboarding());
      }
    } catch (e, st) {
      _logger.e('checkOnboarding failed', error: e, stackTrace: st);
    }
  }
}
