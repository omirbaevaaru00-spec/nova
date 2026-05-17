import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/localization/locale_controller.dart';
import 'core/router/app_router.dart';
import 'core/services/firebase_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'data/auth/auth_repository.dart';
import 'data/auth/auth_repository_impl.dart';
import 'data/news/university_news_repository.dart';
import 'data/news/university_news_repository_impl.dart';
import 'data/onboarding/onboarding_repository.dart';
import 'data/onboarding/onboarding_repository_impl.dart';
import 'data/programs/university_program_repository.dart';
import 'data/programs/university_program_repository_impl.dart';
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
          create: (_) => UniversityRepositoryImpl(FirebaseService.instance),
        ),
        RepositoryProvider<UniversityProgramRepository>(
          create: (_) =>
              UniversityProgramRepositoryImpl(FirebaseService.instance),
        ),
        RepositoryProvider<UniversityNewsRepository>(
          create: (_) =>
              UniversityNewsRepositoryImpl(FirebaseService.instance),
        ),
        RepositoryProvider<SearchHistoryRepository>(
          create: (_) => SearchHistoryRepositoryImpl(prefs),
        ),
      ],
      child: const StikyApp(),
    ),
  );
}

class StikyApp extends StatefulWidget {
  const StikyApp({super.key});

  @override
  State<StikyApp> createState() => _StikyAppState();
}

class _StikyAppState extends State<StikyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter();
    LocaleController.instance.addListener(_onConfigChanged);
    ThemeController.instance.addListener(_onConfigChanged);
  }

  @override
  void dispose() {
    _router.dispose();
    LocaleController.instance.removeListener(_onConfigChanged);
    ThemeController.instance.removeListener(_onConfigChanged);
    super.dispose();
  }

  void _onConfigChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      locale: LocaleController.instance.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeController.instance.mode,
      // Найди MaterialApp.router и добавь:
themeAnimationDuration: const Duration(milliseconds: 350),
themeAnimationCurve: Curves.easeInOut,
    );
  }
}