import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/favorites/favorites_repository_impl.dart';
import '../../../data/university/university_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/favorites_cubit.dart';
import '../bloc/favorites_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => FavoritesCubit(
        favoritesRepository: FavoritesRepositoryImpl(FirebaseService.instance),
        universityRepository: context.read<UniversityRepository>(),
      )..load(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.screenFavorites)),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            if (state.status == FavoritesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.favoriteAuthSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final u = state.items[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.surfaceMuted,
                  ),
                  child: Text(u.name),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
