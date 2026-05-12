
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';

// import '../../../core/theme/app_colors.dart';
// import '../../../l10n/generated/app_localizations.dart';
// import '../bloc/notifications_cubit.dart';
// import '../bloc/notifications_state.dart';

// class NotificationsScreen extends StatelessWidget {
//   const NotificationsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => NotificationsCubit()..load(),
//       child: const _NotificationsView(),
//     );
//   }
// }

// class _NotificationsView extends StatelessWidget {
//   const _NotificationsView();

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bgColor =
//         isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;

//     return Scaffold(
//       backgroundColor: bgColor,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Заголовок ──────────────────────────────────────
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//               child: Text(
//                 l10n.screenNotifications,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w800,
//                   color:
//                       isDark ? AppColors.textInverse : AppColors.textPrimary,
//                 ),
//               ),
//             ),
//             // ── Контент ────────────────────────────────────────
//             Expanded(
//               child: BlocBuilder<NotificationsCubit, NotificationsState>(
//                 builder: (context, state) {
//                   if (state.status == NotificationsStatus.loading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (state.newsItems.isEmpty) {
//                     return _EmptyView(isDark: isDark, l10n: l10n);
//                   }

//                   // Группируем по дате
//                   final grouped = _groupByDate(state.newsItems);

//                   return ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     itemCount: grouped.length,
//                     itemBuilder: (context, index) {
//                       final entry = grouped[index];
//                       if (entry is _DateHeader) {
//                         return _DateLabel(
//                           label: entry.label,
//                           isDark: isDark,
//                         );
//                       }
//                       final item = entry as UniversityNewsItem;
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 12),
//                         child: _NewsCard(item: item, isDark: isDark),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Группирует новости по меткам дат (Сегодня / Вчера / дата).
//   List<Object> _groupByDate(List<UniversityNewsItem> items) {
//     final result = <Object>[];
//     String? lastLabel;
//     for (final item in items) {
//       final label = _dateLabel(item.publishedAt);
//       if (label != lastLabel) {
//         result.add(_DateHeader(label));
//         lastLabel = label;
//       }
//       result.add(item);
//     }
//     return result;
//   }

//   String _dateLabel(DateTime dt) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final day = DateTime(dt.year, dt.month, dt.day);
//     final diff = today.difference(day).inDays;
//     if (diff == 0) return 'Сегодня';
//     if (diff == 1) return 'Вчера';
//     return DateFormat('d MMMM', 'ru').format(dt);
//   }
// }

// class _DateHeader {
//   const _DateHeader(this.label);
//   final String label;
// }

// // ── Пустое состояние ──────────────────────────────────────────────────────────

// class _EmptyView extends StatelessWidget {
//   const _EmptyView({required this.isDark, required this.l10n});

//   final bool isDark;
//   final AppLocalizations l10n;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 40),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isDark
//                     ? AppColors.surfaceMutedDark
//                     : AppColors.backgroundLight,
//               ),
//               child: Icon(
//                 Icons.notifications_none_rounded,
//                 size: 36,
//                 color: isDark
//                     ? AppColors.textSecondary
//                     : AppColors.textMuted,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               l10n.notificationsEmpty,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 17,
//                 fontWeight: FontWeight.w600,
//                 color: isDark ? AppColors.textInverse : AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               l10n.notificationsEmptyHint,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 14,
//                 height: 1.5,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── DateLabel ─────────────────────────────────────────────────────────────────

// class _DateLabel extends StatelessWidget {
//   const _DateLabel({required this.label, required this.isDark});

//   final String label;
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8, bottom: 10),
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w600,
//           color: AppColors.textSecondary.withValues(alpha: 0.8),
//           letterSpacing: 0.3,
//         ),
//       ),
//     );
//   }
// }

// // ── NewsCard ──────────────────────────────────────────────────────────────────

// class _NewsCard extends StatelessWidget {
//   const _NewsCard({required this.item, required this.isDark});

//   final UniversityNewsItem item;
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark
//             ? AppColors.surfaceMutedDark
//             : AppColors.backgroundLight,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: isDark
//             ? []
//             : [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.05),
//                   blurRadius: 10,
//                   offset: const Offset(0, 2),
//                 ),
//               ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Левая зелёная полоска
//           Container(
//             width: 4,
//             height: 80,
//             decoration: BoxDecoration(
//               color: item.isNew ? AppColors.brandAccent : AppColors.border,
//               borderRadius: const BorderRadius.horizontal(
//                 left: Radius.circular(20),
//               ),
//             ),
//           ),
//           // Контент
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Логотип университета
//                   Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       color: isDark
//                           ? AppColors.backgroundDark
//                           : AppColors.surfaceMuted,
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: item.universityLogoUrl != null
//                           ? Image.network(
//                               item.universityLogoUrl!,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, _, _) =>
//                                   _LogoInitial(name: item.universityName),
//                             )
//                           : _LogoInitial(name: item.universityName),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Название университета
//                         Text(
//                           item.universityName,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.brandAccent,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         // Заголовок новости
//                         Text(
//                           item.title,
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                             height: 1.4,
//                             color: isDark
//                                 ? AppColors.textInverse
//                                 : AppColors.textPrimary,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         if (item.summary.isNotEmpty) ...[
//                           const SizedBox(height: 4),
//                           Text(
//                             item.summary,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: AppColors.textSecondary,
//                               height: 1.4,
//                             ),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // Время + индикатор новинки
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         DateFormat('HH:mm').format(item.publishedAt),
//                         style: const TextStyle(
//                           fontSize: 11,
//                           color: AppColors.textMuted,
//                         ),
//                       ),
//                       if (item.isNew) ...[
//                         const SizedBox(height: 6),
//                         Container(
//                           width: 8,
//                           height: 8,
//                           decoration: const BoxDecoration(
//                             color: AppColors.brandAccent,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _LogoInitial extends StatelessWidget {
//   const _LogoInitial({required this.name});

//   final String name;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         name.isNotEmpty ? name[0].toUpperCase() : 'U',
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w800,
//           color: AppColors.brandAccent,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/route_names.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/notifications_cubit.dart';
import '../bloc/notifications_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(
        firebaseService: FirebaseService.instance,
      )..load(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Заголовок ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              child: Text(
                l10n.screenNotifications,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: isDark
                      ? AppColors.textInverse
                      : AppColors.textPrimary,
                ),
              ),
            ),
            // ── Контент ────────────────────────────────────────
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  // Загрузка
                  if (state.status == NotificationsStatus.loading ||
                      state.status == NotificationsStatus.initial) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  // Не авторизован — заглушка с кнопкой
                  if (state.status ==
                      NotificationsStatus.unauthenticated) {
                    return _UnauthView(isDark: isDark, l10n: l10n);
                  }

                  // Нет новостей (нет избранных или коллекция пуста)
                  if (state.newsItems.isEmpty) {
                    return _EmptyView(isDark: isDark, l10n: l10n);
                  }

                  // Список новостей сгруппированных по датам
                  final grouped = _groupByDate(state.newsItems);
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<NotificationsCubit>().load(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: grouped.length,
                      itemBuilder: (context, index) {
                        final entry = grouped[index];
                        if (entry is _DateHeader) {
                          return _DateLabel(
                              label: entry.label, isDark: isDark);
                        }
                        final item = entry as UniversityNewsItem;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => context
                                .read<NotificationsCubit>()
                                .markAsRead(item.id),
                            child: _NewsCard(
                                item: item, isDark: isDark),
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
    );
  }

  List<Object> _groupByDate(List<UniversityNewsItem> items) {
    final result = <Object>[];
    String? lastLabel;
    for (final item in items) {
      final label = _dateLabel(item.publishedAt);
      if (label != lastLabel) {
        result.add(_DateHeader(label));
        lastLabel = label;
      }
      result.add(item);
    }
    return result;
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(day).inDays;
    if (diff == 0) return 'Сегодня';
    if (diff == 1) return 'Вчера';
    return DateFormat('d MMMM', 'ru').format(dt);
  }
}

class _DateHeader {
  const _DateHeader(this.label);
  final String label;
}

// ── Не авторизован ────────────────────────────────────────────────────────────

class _UnauthView extends StatelessWidget {
  const _UnauthView({required this.isDark, required this.l10n});

  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.surfaceMutedDark
                    : AppColors.backgroundLight,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 36,
                color: AppColors.brandAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.notificationsAuthRequired,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.textInverse
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.notificationsAuthSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 50,
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
                  l10n.actionRegister,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Нет новостей ──────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.isDark, required this.l10n});

  final bool isDark;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? AppColors.surfaceMutedDark
                    : AppColors.backgroundLight,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 36,
                color: isDark
                    ? AppColors.textSecondary
                    : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.notificationsEmpty,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.textInverse
                    : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.notificationsEmptyHint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── DateLabel ─────────────────────────────────────────────────────────────────

class _DateLabel extends StatelessWidget {
  const _DateLabel({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary.withValues(alpha: 0.8),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ── NewsCard ──────────────────────────────────────────────────────────────────

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item, required this.isDark});

  final UniversityNewsItem item;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceMutedDark
            : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(20),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Цветная полоска — зелёная если новая
          Container(
            width: 4,
            height: 88,
            decoration: BoxDecoration(
              color: item.isNew
                  ? AppColors.brandAccent
                  : AppColors.border,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Лого университета
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: isDark
                          ? AppColors.backgroundDark
                          : AppColors.surfaceMuted,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: item.universityLogoUrl != null
                          ? Image.network(
                              item.universityLogoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) =>
                                  _LogoInitial(
                                      name: item.universityName),
                            )
                          : _LogoInitial(name: item.universityName),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Название университета
                        Text(
                          item.universityName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brandAccent,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Заголовок новости
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: isDark
                                ? AppColors.textInverse
                                : AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.summary.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.summary,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Время + точка «новое»
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(item.publishedAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                      if (item.isNew) ...[
                        const SizedBox(height: 6),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.brandAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoInitial extends StatelessWidget {
  const _LogoInitial({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: AppColors.brandAccent,
        ),
      ),
    );
  }
}