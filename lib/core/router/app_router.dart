import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/phone_otp/ui/phone_otp_screen.dart';
import '../../features/profile_setup/ui/profile_setup_screen.dart';
import '../../features/register/ui/register_screen.dart';
import '../../features/forgot_password/ui/forgot_password_screen.dart';
import '../../features/login/ui/login_screen.dart';
import '../../features/favorites/ui/favorites_screen.dart';
import '../../features/home/ui/home_screen.dart';
import '../../features/search/ui/search_screen.dart';
import '../../features/main_navigation/ui/main_navigation_screen.dart';
import '../../features/news/ui/news_screen.dart';
import '../../features/notifications/ui/notifications_screen.dart';
import '../../features/onboarding/ui/onboarding_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/profile_settings/ui/profile_settings_screen.dart';
import '../../features/profile_entry/ui/profile_entry_screen.dart';
import '../../features/saved_searches/ui/saved_searches_screen.dart';
import '../../features/splash/ui/splash_page.dart';
import '../../features/university_detail/ui/reviews_screen.dart';
import '../../features/university_detail/ui/university_detail_screen.dart';
import '../../features/welcome/ui/welcome_screen.dart';
import 'route_names.dart';

abstract final class AppRouter {
  static GoRouter createRouter() => GoRouter(
        initialLocation: RouteNames.splash,
        routes: [
          GoRoute(
            path: RouteNames.splash,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SplashPage(),
            ),
          ),
          GoRoute(
            path: RouteNames.welcome,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const WelcomeScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.onboarding,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const OnboardingScreen(),
            ),
          ),

          // ── Auth ────────────────────────────────────────────
          GoRoute(
            path: RouteNames.login,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const LoginScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.register,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const RegisterScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.forgotPassword,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const ForgotPasswordScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.phoneOtp,
            pageBuilder: (_, state) {
              final extra = (state.extra as Map?) ?? const {};
              return MaterialPage(
                key: state.pageKey,
                child: PhoneOtpScreen(
                  phone: (extra['phone'] as String?) ?? '',
                  verificationId:
                      (extra['verificationId'] as String?) ?? '',
                ),
              );
            },
          ),
          GoRoute(
            path: RouteNames.profileSetup,
            pageBuilder: (_, state) {
              final extra = (state.extra as Map?) ?? const {};
              return MaterialPage(
                key: state.pageKey,
                child: ProfileSetupScreen(
                  email: extra['email'] as String?,
                  phone: extra['phone'] as String?,
                ),
              );
            },
          ),

          // ── Main shell ──────────────────────────────────────
          ShellRoute(
            builder: (_, __, child) => MainNavigationScreen(child: child),
            routes: [
              GoRoute(
                path: RouteNames.home,
                pageBuilder: (_, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const HomeScreen(),
                ),
              ),
              GoRoute(
                path: RouteNames.notifications,
                pageBuilder: (_, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const NotificationsScreen(),
                ),
              ),
              GoRoute(
                path: RouteNames.profile,
                pageBuilder: (_, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),

          // ── Detail screens ──────────────────────────────────
          GoRoute(
            path: '/university/:id',
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: UniversityDetailScreen(
                id: state.pathParameters['id'] ?? '',
              ),
            ),
            routes: [
              GoRoute(
                path: 'reviews',
                pageBuilder: (_, state) => MaterialPage(
                  key: state.pageKey,
                  child: ReviewsScreen(
                    universityId: state.pathParameters['id'] ?? '',
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.favorites,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const FavoritesScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.savedSearches,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const SavedSearchesScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.newsFeed,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const NewsScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.helpCenter,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const ProfileEntryScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.search,
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const SearchScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.profileSettings,
            name: 'profile-settings',
            pageBuilder: (_, state) => MaterialPage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),
        ],
        errorBuilder: (context, state) => Scaffold(
          body: Center(
            child: Text(
              'Page not found: ${state.uri}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
}