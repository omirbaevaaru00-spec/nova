import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stiky/core/router/route_names.dart';
import 'package:stiky/data/onboarding/onboarding_repository_impl.dart';
import 'package:stiky/features/splash/bloc/splash_cubit.dart';
import 'package:stiky/features/splash/bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final repository = OnboardingRepositoryImpl();

        return SplashCubit(onboardnigRepository: repository)..checkOnboarding();
      },
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
        if (state is SplashStateShouldOnboarding) {
          context.go(RouteNames.welcome);
        } else if (state is SplashStateAlreadyOnboarded) {
          context.go(RouteNames.home);
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
                  'assets/images/nova_logo.png',
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
