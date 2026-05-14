import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_repository.dart';
import '../../../data/onboarding/onboarding_repository.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required AuthRepository authRepository,
    required OnboardingRepository onboardingRepository,
  })  : _auth = authRepository,
        _onboarding = onboardingRepository,
        super(const SplashState());

  final AuthRepository _auth;
  final OnboardingRepository _onboarding;

  static const _minSplashDuration = Duration(milliseconds: 1500);

  Future<void> bootstrap() async {
    final stopwatch = Stopwatch()..start();
    try {
      final onboarded = await _onboarding.isOnboardingCompleted();
      await _padSplash(stopwatch);

      if (!onboarded) {
        // Первый запуск — показываем welcome → onboarding
        emit(state.copyWith(status: SplashStatus.shouldOnboard));
        return;
      }

      // Онбординг пройден — всегда идём на home.
      // Авторизованный увидит полный профиль, неавторизованный — каталог.
      // Войти/зарегистрироваться можно через экран профиля.
      emit(
        state.copyWith(
          status: _auth.isAuthenticated
              ? SplashStatus.authenticated
              : SplashStatus.authenticated, // оба варианта → home
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SplashStatus.failure, error: e.toString()));
    }
  }

  Future<void> _padSplash(Stopwatch stopwatch) async {
    final elapsed = stopwatch.elapsed;
    if (elapsed < _minSplashDuration) {
      await Future.delayed(_minSplashDuration - elapsed);
    }
  }
}