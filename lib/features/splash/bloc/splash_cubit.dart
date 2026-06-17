
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/onboarding/onboarding_repository.dart';
import '../../favorites/global_favorites_notifier.dart';
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
  final _log = Logger();

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

      final isAuth = _auth.isAuthenticated;

      if (isAuth) {
        final uid = FirebaseService.instance.currentUid!;

        // Загружаем лайки в фоне — не блокируем навигацию
        GlobalFavoritesNotifier.instance.load();

        // Инициализируем FCM в фоне
        _initPush(uid);
      }

      // Авторизованный и неавторизованный — оба идут на home.
      // Неавторизованный увидит каталог, профиль покажет заглушку.
      emit(state.copyWith(status: SplashStatus.authenticated));
    } catch (e) {
      _log.e('SplashCubit.bootstrap', error: e);
      emit(state.copyWith(
        status: SplashStatus.failure,
        error: e.toString(),
      ));
    }
  }

  /// Инициализирует push-уведомления в фоне.
  /// Не блокирует навигацию — ошибки логируем, не пробрасываем.
  Future<void> _initPush(String uid) async {
    try {
      await FirebaseService.instance.requestNotificationPermission();
      await FirebaseService.instance.saveFcmToken(uid);
      _log.i('SplashCubit: FCM токен сохранён для $uid');
    } catch (e) {
      _log.w('SplashCubit: ошибка инициализации FCM', error: e);
    }
  }

  Future<void> _padSplash(Stopwatch stopwatch) async {
    final elapsed = stopwatch.elapsed;
    if (elapsed < _minSplashDuration) {
      await Future.delayed(_minSplashDuration - elapsed);
    }
  }
}