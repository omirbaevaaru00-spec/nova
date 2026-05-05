import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stiky/data/onboarding/onboarding_repository.dart';
import 'package:stiky/data/onboarding/onboarding_repository_impl.dart';
import 'firebase_options.dart';

import 'core/router/app_router.dart';
import 'core/localization/locale_controller.dart';
import 'core/theme/theme_controller.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  await LocaleController.instance.init();
  await ThemeController.instance.init();
  final prefs = await SharedPreferences.getInstance();

  // 2. Создаём репозиторий
  final onboardingRepository = OnboardingRepositoryImpl(prefs);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<OnboardingRepository>.value(
          value: onboardingRepository,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Слушаем оба контроллера
    return AnimatedBuilder(
      animation: Listenable.merge([
        LocaleController.instance,
        ThemeController.instance,
      ]),
      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          locale: LocaleController.instance.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,

          // ── Светлая тема ──
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5B61F6),
              brightness: Brightness.light,
            ),
          ),

          // ── Тёмная тема ──
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5B61F6),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF1C1C1E),
          ),

          // ← теперь управляется ThemeController
          themeMode: ThemeController.instance.mode,
        );
      },
    );
  }
}
