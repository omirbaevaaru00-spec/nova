import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/router/route_names.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/favorites/favorites_repository_impl.dart';
import '../../../data/profile/profile_repository_impl.dart';
import '../../../data/university/university_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/profile_cubit.dart';
import '../bloc/profile_state.dart';
import '../widgets/favorite_card.dart';
import '../widgets/scores_pill.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        authRepository: context.read<AuthRepository>(),
        profileRepository: ProfileRepositoryImpl(FirebaseService.instance),
        universityRepository: context.read<UniversityRepository>(),
        favoritesRepository: FavoritesRepositoryImpl(FirebaseService.instance),
      )..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (a, b) => a.status != b.status,
      listener: (context, state) {
        if (state.status == ProfileStatus.unauthenticated) {
          context.go(RouteNames.register);
        }
      },
      builder: (context, state) {
        if (state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.initial) {
          return const Scaffold(
            backgroundColor: AppColors.surfaceMuted,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.surfaceMuted,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.surfaceMuted,
                elevation: 0,
                pinned: true,
                automaticallyImplyLeading: false,
                toolbarHeight: 56,
                leading: GestureDetector(
                  onTap: () =>
                      context.canPop() ? context.pop() : null,
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () async {
                      await context.push(RouteNames.profileSettings);
                      if (context.mounted) {
                        await context.read<ProfileCubit>().load();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.settings_outlined,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _Avatar(photoUrl: state.photoUrl),
                    const SizedBox(height: 12),
                    Text(
                      state.name.isNotEmpty
                          ? state.name
                          : l10n.profileFallbackName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (state.city.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        state.city,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    ScoresPill(
                      gpa: state.gpa,
                      ielts: state.ielts,
                      ent: state.ent,
                    ),
                    const SizedBox(height: 24),
                    _FavoritesSection(favorites: state.favorites),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photoUrl});

  final String? photoUrl;

  void _showPhotoSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showCupertinoModalPopup(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(l10n.profilePhotoTitle),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(sheetContext);
              await ImagePicker().pickImage(source: ImageSource.camera);
              // TODO: загрузить выбранное фото в Firebase Storage через сервис.
            },
            child: Text(l10n.profilePhotoTake),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(sheetContext);
              await ImagePicker().pickImage(source: ImageSource.gallery);
              // TODO: загрузить выбранное фото в Firebase Storage через сервис.
            },
            child: Text(l10n.profilePhotoPick),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(sheetContext),
          child: Text(l10n.actionCancel),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPhotoSheet(context),
      child: Stack(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.warning,
              image: photoUrl != null
                  ? DecorationImage(
                      image: NetworkImage(photoUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: photoUrl == null
                ? const Icon(
                    CupertinoIcons.person_fill,
                    color: AppColors.textInverse,
                    size: 48,
                  )
                : null,
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.brandPrimary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surfaceMuted,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.textInverse,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesSection extends StatelessWidget {
  const _FavoritesSection({required this.favorites});

  final List favorites;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l10n.profileFavoritesSection,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (favorites.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                const Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.textMuted,
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.profileFavoritesEmpty,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, i) =>
                FavoriteCard(university: favorites[i]),
          ),
      ],
    );
  }
}
