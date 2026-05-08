import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/locale_controller.dart';
import 'core/router/app_router.dart';
import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/auth/auth_repository.dart';
import 'data/auth/auth_repository_impl.dart';
import 'data/onboarding/onboarding_repository.dart';
import 'data/onboarding/onboarding_repository_impl.dart';
import 'data/search/search_history_repository.dart';
import 'data/search/search_history_repository_impl.dart';
import 'data/university/university_repository.dart';
import 'data/university/university_repository_impl.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.instance.init();
  await LocaleController.instance.init();
  await ThemeController.instance.init();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepositoryImpl(FirebaseService.instance),
        ),
        RepositoryProvider<OnboardingRepository>(
          create: (_) => OnboardingRepositoryImpl(prefs),
        ),
        RepositoryProvider<UniversityRepository>(
          create: (_) => const UniversityRepositoryImpl(),
        ),
        RepositoryProvider<SearchHistoryRepository>(
          create: (_) => SearchHistoryRepositoryImpl(prefs),
        ),
      ],
      child: const StikyApp(),
    ),
  );
}

class StikyApp extends StatelessWidget {
  const StikyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeController.instance.mode,
        );
      },
    );
  }
}
