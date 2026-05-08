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
import '../../features/university_detail/ui/university_detail_screen.dart';
import '../../features/welcome/ui/welcome_screen.dart';
import 'route_names.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.welcome,
        builder: (_, _) => const WelcomeScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),

      // ── Auth ──────────────────────────────────────────────
      GoRoute(
        path: RouteNames.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (_, _) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.phoneOtp,
        builder: (_, state) {
          final extra = (state.extra as Map?) ?? const {};
          return PhoneOtpScreen(
            phone: (extra['phone'] as String?) ?? '',
            verificationId: (extra['verificationId'] as String?) ?? '',
          );
        },
      ),
      GoRoute(
        path: RouteNames.profileSetup,
        builder: (_, state) {
          final extra = (state.extra as Map?) ?? const {};
          return ProfileSetupScreen(
            email: extra['email'] as String?,
            phone: extra['phone'] as String?,
          );
        },
      ),

      // ── Main shell ────────────────────────────────────────
      ShellRoute(
        builder: (_, _, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (_, _) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.notifications,
            builder: (_, _) => const NotificationsScreen(),
          ),
          GoRoute(
            path: RouteNames.profile,
            builder: (_, _) => const ProfileScreen(),
          ),
        ],
      ),

      // ── Detail screens ────────────────────────────────────
      GoRoute(
        path: '/university/:id',
        builder: (_, state) => UniversityDetailScreen(
          id: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: RouteNames.favorites,
        builder: (_, _) => const FavoritesScreen(),
      ),
      GoRoute(
        path: RouteNames.savedSearches,
        builder: (_, _) => const SavedSearchesScreen(),
      ),
      GoRoute(
        path: RouteNames.newsFeed,
        builder: (_, _) => const NewsScreen(),
      ),
      GoRoute(
        path: RouteNames.helpCenter,
        builder: (_, _) => const ProfileEntryScreen(),
      ),
      GoRoute(
        path: RouteNames.search,
        builder: (_, _) => const SearchScreen(),
      ),
      GoRoute(
        path: RouteNames.profileSettings,
        name: 'profile-settings',
        builder: (_, _) => const SettingsScreen(),
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
