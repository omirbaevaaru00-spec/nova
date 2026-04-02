import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/main_navigation_screen.dart';
import '../../features/university/screens/university_detail_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/main',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/university/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return UniversityDetailScreen(id: id);
        },
      ),
    ],
  );
}