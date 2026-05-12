// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../core/router/route_names.dart';
// import '../../../core/services/firebase_service.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../data/auth/auth_repository.dart';
// import '../../../data/favorites/favorites_repository_impl.dart';
// import '../../../data/profile/profile_repository_impl.dart';
// import '../../../data/university/university_repository.dart';
// import '../../../l10n/generated/app_localizations.dart';
// import '../bloc/profile_cubit.dart';
// import '../bloc/profile_state.dart';
// import '../widgets/favorite_card.dart';
// import '../widgets/scores_pill.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ProfileCubit(
//         authRepository: context.read<AuthRepository>(),
//         profileRepository: ProfileRepositoryImpl(FirebaseService.instance),
//         universityRepository: context.read<UniversityRepository>(),
//         favoritesRepository: FavoritesRepositoryImpl(FirebaseService.instance),
//       )..load(),
//       child: const _ProfileView(),
//     );
//   }
// }

// class _ProfileView extends StatelessWidget {
//   const _ProfileView();

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return BlocConsumer<ProfileCubit, ProfileState>(
//       listenWhen: (a, b) => a.status != b.status,
//       listener: (context, state) {
//         if (state.status == ProfileStatus.unauthenticated) {
//           context.go(RouteNames.register);
//         }
//       },
//       builder: (context, state) {
//         if (state.status == ProfileStatus.loading ||
//             state.status == ProfileStatus.initial) {
//           return const Scaffold(
//             backgroundColor: AppColors.surfaceMuted,
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }
//         return Scaffold(
//           backgroundColor: AppColors.surfaceMuted,
//           body: CustomScrollView(
//             slivers: [
//               SliverAppBar(
//                 backgroundColor: AppColors.surfaceMuted,
//                 elevation: 0,
//                 pinned: true,
//                 automaticallyImplyLeading: false,
//                 toolbarHeight: 56,
//                 leading: GestureDetector(
//                   onTap: () =>
//                       context.canPop() ? context.pop() : null,
//                   child: const Icon(
//                     Icons.arrow_back_rounded,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 actions: [
//                   GestureDetector(
//                     onTap: () async {
//                       await context.push(RouteNames.profileSettings);
//                       if (context.mounted) {
//                         await context.read<ProfileCubit>().load();
//                       }
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.only(right: 16),
//                       child: Icon(
//                         Icons.settings_outlined,
//                         color: AppColors.textPrimary,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SliverToBoxAdapter(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 8),
//                     _Avatar(photoUrl: state.photoUrl),
//                     const SizedBox(height: 12),
//                     Text(
//                       state.name.isNotEmpty
//                           ? state.name
//                           : l10n.profileFallbackName,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary,
//                       ),
//                     ),
//                     if (state.city.isNotEmpty) ...[
//                       const SizedBox(height: 2),
//                       Text(
//                         state.city,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: AppColors.textSecondary,
//                         ),
//                       ),
//                     ],
//                     const SizedBox(height: 16),
//                     ScoresPill(
//                       gpa: state.gpa,
//                       ielts: state.ielts,
//                       ent: state.ent,
//                     ),
//                     const SizedBox(height: 24),
//                     _FavoritesSection(favorites: state.favorites),
//                     const SizedBox(height: 40),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _Avatar extends StatelessWidget {
//   const _Avatar({required this.photoUrl});

//   final String? photoUrl;

//   void _showPhotoSheet(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     showCupertinoModalPopup(
//       context: context,
//       builder: (sheetContext) => CupertinoActionSheet(
//         title: Text(l10n.profilePhotoTitle),
//         actions: [
//           CupertinoActionSheetAction(
//             onPressed: () async {
//               Navigator.pop(sheetContext);
//               await ImagePicker().pickImage(source: ImageSource.camera);
//               // TODO: загрузить выбранное фото в Firebase Storage через сервис.
//             },
//             child: Text(l10n.profilePhotoTake),
//           ),
//           CupertinoActionSheetAction(
//             onPressed: () async {
//               Navigator.pop(sheetContext);
//               await ImagePicker().pickImage(source: ImageSource.gallery);
//               // TODO: загрузить выбранное фото в Firebase Storage через сервис.
//             },
//             child: Text(l10n.profilePhotoPick),
//           ),
//         ],
//         cancelButton: CupertinoActionSheetAction(
//           isDestructiveAction: true,
//           onPressed: () => Navigator.pop(sheetContext),
//           child: Text(l10n.actionCancel),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showPhotoSheet(context),
//       child: Stack(
//         children: [
//           Container(
//             width: 96,
//             height: 96,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColors.warning,
//               image: photoUrl != null
//                   ? DecorationImage(
//                       image: NetworkImage(photoUrl!),
//                       fit: BoxFit.cover,
//                     )
//                   : null,
//             ),
//             child: photoUrl == null
//                 ? const Icon(
//                     CupertinoIcons.person_fill,
//                     color: AppColors.textInverse,
//                     size: 48,
//                   )
//                 : null,
//           ),
//           Positioned(
//             bottom: 2,
//             right: 2,
//             child: Container(
//               width: 26,
//               height: 26,
//               decoration: BoxDecoration(
//                 color: AppColors.brandPrimary,
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: AppColors.surfaceMuted,
//                   width: 2,
//                 ),
//               ),
//               child: const Icon(
//                 Icons.add,
//                 color: AppColors.textInverse,
//                 size: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FavoritesSection extends StatelessWidget {
//   const _FavoritesSection({required this.favorites});

//   final List favorites;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           l10n.profileFavoritesSection,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         const SizedBox(height: 12),
//         if (favorites.isEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 32),
//             child: Column(
//               children: [
//                 const Icon(
//                   Icons.favorite_border_rounded,
//                   color: AppColors.textMuted,
//                   size: 48,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   l10n.profileFavoritesEmpty,
//                   style: const TextStyle(
//                     color: AppColors.textSecondary,
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           )
//         else
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             gridDelegate:
//                 const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//               childAspectRatio: 0.82,
//             ),
//             itemCount: favorites.length,
//             itemBuilder: (context, i) =>
//                 FavoriteCard(university: favorites[i]),
//           ),
//       ],
//     );
//   }
// }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // ── Загрузка ─────────────────────────────────────────────
        if (state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.initial) {
          return Scaffold(
            backgroundColor: bgColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // ── Не авторизован: показываем заглушку С навбаром ──────
        // Навбар остаётся — НЕ делаем context.go, остаёмся внутри ShellRoute.
        if (state.status == ProfileStatus.unauthenticated) {
          return _UnauthenticatedView(isDark: isDark, l10n: l10n);
        }

        // ── Авторизован ──────────────────────────────────────────
        return Scaffold(
          backgroundColor: bgColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: bgColor,
                elevation: 0,
                pinned: true,
                automaticallyImplyLeading: false,
                toolbarHeight: 56,
                actions: [
                  GestureDetector(
                    onTap: () async {
                      await context.push(RouteNames.profileSettings);
                      if (context.mounted) {
                        await context.read<ProfileCubit>().load();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.settings_outlined,
                        color: isDark
                            ? AppColors.textInverse
                            : AppColors.textPrimary,
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textInverse
                            : AppColors.textPrimary,
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

// ── Заглушка для неавторизованных (внутри ShellRoute — навбар виден) ─────────

class _UnauthenticatedView extends StatelessWidget {
  const _UnauthenticatedView({required this.isDark, required this.l10n});

  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Иллюстрация
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColors.surfaceMutedDark
                      : AppColors.backgroundLight,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  CupertinoIcons.person_fill,
                  size: 52,
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                l10n.profileUnauthTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color:
                      isDark ? AppColors.textInverse : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.profileUnauthSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 36),
              // Кнопка «Войти / Зарегистрироваться»
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.push(RouteNames.register),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandAccent,
                    foregroundColor: AppColors.backgroundDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.profileUnauthCta,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Вход
              TextButton(
                onPressed: () => context.push(RouteNames.login),
                child: Text(
                  l10n.profileUnauthLogin,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textInverse.withValues(alpha: 0.7)
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────────

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
              // TODO: загрузить фото в Firebase Storage через репозиторий.
            },
            child: Text(l10n.profilePhotoTake),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(sheetContext);
              await ImagePicker().pickImage(source: ImageSource.gallery);
              // TODO: загрузить фото в Firebase Storage через репозиторий.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  color: isDark
                      ? AppColors.backgroundDark
                      : AppColors.surfaceMuted,
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

// ── FavoritesSection ──────────────────────────────────────────────────────────

class _FavoritesSection extends StatelessWidget {
  const _FavoritesSection({required this.favorites});

  final List favorites;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          l10n.profileFavoritesSection,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textInverse : AppColors.textPrimary,
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