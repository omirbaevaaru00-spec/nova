import 'package:go_router/go_router.dart';
import 'package:stiky/features/splash/ui/splash_page.dart';

import '../../features/auth/screens/welcome_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      // GoRoute(
      //   path: '/onboarding',
      //   builder: (context, state) => const OnboardingScreen(),
      // ),
      // GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      // ShellRoute(
      //   builder: (context, state, child) => MainShell(child: child),
      //   routes: [],
      // ),
    ],
  );
}
