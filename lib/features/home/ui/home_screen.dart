import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/onboarding/onboarding_repository.dart';
import '../../../data/profile/profile_repository_impl.dart';
import '../../../data/university/university_repository.dart';
import '../../favorites/global_favorites_notifier.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';
import '../widgets/university_feed_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        GlobalFavoritesNotifier.instance.load();
        return HomeCubit(
          universityRepository: context.read<UniversityRepository>(),
          onboardingRepository: context.read<OnboardingRepository>(),
          profileRepository: ProfileRepositoryImpl(FirebaseService.instance),
        )..load();
      },
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.surfaceMuted,
        body: SafeArea(
          child: Column(
            children: [
              const _HomeAppBar(),
              const Divider(height: 1, color: AppColors.border),
              Expanded(
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    if (state.status == HomeStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return RefreshIndicator(
                      onRefresh: () => context.read<HomeCubit>().load(),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        itemCount: state.feed.length,
                        itemBuilder: (context, index) {
                          final uni = state.feed[index];
                          return UniversityFeedCard(
                            university: uni,
                            onTap: () => context.push(
                              '/university/${uni.id}',
                              extra: uni,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.authPrimaryLight,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/sticky_logo.png',
                height: 32,
                fit: BoxFit.contain,
                color: AppColors.textInverse,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.push(RouteNames.search),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.textInverse.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: AppColors.textInverse,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
