// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../../../core/theme/app_colors.dart';
// import '../../../data/university/university_model.dart';

// class FavoriteCard extends StatelessWidget {
//   const FavoriteCard({super.key, required this.university});

//   final University university;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () =>
//           context.push('/university/${university.id}', extra: university),
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.backgroundLight,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(16)),
//               child: Image.network(
//                 university.imageUrl,
//                 height: 110,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, _, _) => Container(
//                   height: 110,
//                   color: AppColors.surfaceMuted,
//                   child: const Icon(
//                     Icons.school_outlined,
//                     color: AppColors.authPrimaryLight,
//                     size: 36,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
//               child: Row(
//                 children: [
//                   _Logo(university: university),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       university.name,
//                       style: const TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Logo extends StatelessWidget {
//   const _Logo({required this.university});

//   final University university;

//   @override
//   Widget build(BuildContext context) {
//     final initial = Center(
//       child: Text(
//         university.name.isNotEmpty ? university.name[0] : 'U',
//         style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w700,
//           color: AppColors.authPrimaryLight,
//         ),
//       ),
//     );
//     return Container(
//       width: 28,
//       height: 28,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: AppColors.surfaceMuted,
//         border: Border.all(color: AppColors.border),
//       ),
//       child: ClipOval(
//         child: university.logoUrl.isNotEmpty
//             ? Image.network(
//                 university.logoUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, _, _) => initial,
//               )
//             : initial,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/university/university_model.dart';

/// Карточка избранного университета в сетке профиля.
/// Поддерживает светлую и тёмную тему.
class FavoriteCard extends StatelessWidget {
  const FavoriteCard({super.key, required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;

    return GestureDetector(
      onTap: () => context.push('/university/${university.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceMutedDark
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение вуза
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(19),
                ),
                child: university.imageUrl.isNotEmpty
                    ? Image.network(
                        university.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _Placeholder(isDark: isDark),
                      )
                    : _Placeholder(isDark: isDark),
              ),
            ),

            // Лого + название
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Логотип
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? AppColors.backgroundDark
                            : AppColors.surfaceMuted,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF2C2F36)
                              : AppColors.border,
                        ),
                      ),
                      child: ClipOval(
                        child: university.logoUrl.isNotEmpty
                            ? Image.network(
                                university.logoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _Initial(
                                  name: university.name.localized(locale),
                                  isDark: isDark,
                                ),
                              )
                            : _Initial(
                                name: university.name.localized(locale),
                                isDark: isDark,
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Название и город
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            university.name.localized(locale),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textInverse
                                  : AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            university.city.localized(locale),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: isDark ? AppColors.backgroundDark : AppColors.surfaceMuted,
      child: Icon(
        Icons.school_outlined,
        size: 32,
        color: isDark ? AppColors.textSecondary : AppColors.textMuted,
      ),
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({required this.name, required this.isDark});
  final String name;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: isDark
              ? AppColors.brandAccent
              : AppColors.authPrimaryLight,
        ),
      ),
    );
  }
}