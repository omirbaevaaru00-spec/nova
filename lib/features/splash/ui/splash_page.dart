import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/onboarding/onboarding_repository.dart';
import '../bloc/splash_cubit.dart';
import '../bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(
        authRepository: context.read<AuthRepository>(),
        onboardingRepository: context.read<OnboardingRepository>(),
      )..bootstrap(),
      child: const _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        switch (state.status) {
          case SplashStatus.shouldOnboard:
            context.go(RouteNames.welcome);
          case SplashStatus.shouldLogin:
            context.go(RouteNames.login);
          case SplashStatus.authenticated:
            context.go(RouteNames.home);
          case SplashStatus.initial:
          case SplashStatus.failure:
            break;
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [scheme.primary, scheme.primaryContainer, scheme.surface],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/sticky_logo.png',
                  width: 180,
                  height: 180,
                ),
                const SizedBox(height: 32),
                CircularProgressIndicator(color: scheme.onPrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
