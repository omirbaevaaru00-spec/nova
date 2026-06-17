// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// import '../../../core/router/route_names.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../data/favorites/favorites_repository.dart';
// import '../../../data/news/university_news_model.dart';
// import '../../../data/news/university_news_repository.dart';
// import '../../../data/programs/university_program_model.dart';
// import '../../../data/programs/university_program_repository.dart';
// import '../../../data/university/university_model.dart';
// import '../../../data/university/university_repository.dart';
// import '../../../l10n/generated/app_localizations.dart';
// import '../../favorites/global_favorites_notifier.dart';
// import '../bloc/university_detail_cubit.dart';
// import '../bloc/university_detail_state.dart';

// class UniversityDetailScreen extends StatelessWidget {
//   const UniversityDetailScreen({
//     super.key,
//     required this.id,
//     this.initialTab,
//   });

//   final String id;
//   final String? initialTab;

//   @override
//   Widget build(BuildContext context) {
//     final tab = _parseTab(initialTab);
//     return BlocProvider(
//       create: (context) => UniversityDetailCubit(
//         universityRepository: context.read<UniversityRepository>(),
//         programRepository: context.read<UniversityProgramRepository>(),
//         newsRepository: context.read<UniversityNewsRepository>(),
//       )..load(id, initialTab: tab),
//       child: _UniversityDetailView(universityId: id),
//     );
//   }

//   UniversityDetailTab _parseTab(String? tab) {
//     return switch (tab) {
//       'news' => UniversityDetailTab.news,
//       'programs' => UniversityDetailTab.programs,
//       _ => UniversityDetailTab.description,
//     };
//   }
// }

// // ─── Основной вид ─────────────────────────────────────────────────────────────

// class _UniversityDetailView extends StatelessWidget {
//   const _UniversityDetailView({required this.universityId});

//   final String universityId;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bgColor =
//         isDark ? AppColors.backgroundDark : const Color(0xFFF5F4FA);

//     return BlocBuilder<UniversityDetailCubit, UniversityDetailState>(
//       builder: (context, state) {
//         if (state.status == UniversityDetailStatus.loading ||
//             state.status == UniversityDetailStatus.initial) {
//           return Scaffold(
//             backgroundColor: bgColor,
//             body: const Center(child: CircularProgressIndicator()),
//           );
//         }
//         final uni = state.university;
//         if (uni == null) {
//           return Scaffold(
//             backgroundColor: bgColor,
//             body: Center(child: Text(l10n.searchEmpty)),
//           );
//         }
//         return Scaffold(
//           backgroundColor: bgColor,
//           body: SafeArea(
//             child: CustomScrollView(
//               slivers: [
//                 SliverToBoxAdapter(child: _TopBar(isDark: isDark)),
//                 SliverToBoxAdapter(child: _HeroImage(university: uni)),
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//                     child: _Header(
//                       university: uni,
//                       isDark: isDark,
//                       universityId: universityId,
//                     ),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                     child: _Tabs(current: state.tab, isDark: isDark),
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
//                     child: _TabContent(
//                       state: state,
//                       university: uni,
//                       isDark: isDark,
//                       universityId: universityId,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // ─── TopBar ───────────────────────────────────────────────────────────────────

// class _TopBar extends StatelessWidget {
//   const _TopBar({required this.isDark});

//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     final color = isDark ? AppColors.textInverse : AppColors.textPrimary;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () => Navigator.of(context).maybePop(),
//             icon: Icon(Icons.arrow_back_rounded, color: color, size: 24),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── HeroImage ────────────────────────────────────────────────────────────────

// class _HeroImage extends StatelessWidget {
//   const _HeroImage({required this.university});

//   final University university;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 240,
//       width: double.infinity,
//       child: university.imageUrl.isNotEmpty
//           ? Image.network(
//               university.imageUrl,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) => const _HeroPlaceholder(),
//             )
//           : const _HeroPlaceholder(),
//     );
//   }
// }

// class _HeroPlaceholder extends StatelessWidget {
//   const _HeroPlaceholder();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.divider,
//       child: const Center(
//         child: Icon(
//           Icons.school_outlined,
//           color: AppColors.authPrimaryLight,
//           size: 52,
//         ),
//       ),
//     );
//   }
// }

// // ─── Header ───────────────────────────────────────────────────────────────────

// class _Header extends StatelessWidget {
//   const _Header({
//     required this.university,
//     required this.isDark,
//     required this.universityId,
//   });

//   final University university;
//   final bool isDark;
//   final String universityId;

//   Future<void> _handleLike(BuildContext context) async {
//     HapticFeedback.lightImpact();
//     try {
//       await GlobalFavoritesNotifier.instance.toggle(universityId);
//     } on NotAuthenticatedException {
//       if (!context.mounted) return;
//       _showFavAuthSheet(context);
//     }
//   }

//   void _showFavAuthSheet(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     showModalBottomSheet<void>(
//       context: context,
//       backgroundColor: AppColors.backgroundLight,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (sheetCtx) => Padding(
//         padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: AppColors.divider,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Icon(Icons.favorite_rounded,
//                 color: AppColors.danger, size: 44),
//             const SizedBox(height: 16),
//             Text(
//               l10n.favoriteAuthRequired,
//               style: const TextStyle(
//                 color: AppColors.textPrimary,
//                 fontSize: 20,
//                 fontWeight: FontWeight.w800,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               l10n.favoriteAuthSubtitle,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: AppColors.textSecondary,
//                 fontSize: 14,
//                 height: 1.4,
//               ),
//             ),
//             const SizedBox(height: 28),
//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(sheetCtx);
//                   context.push(RouteNames.register);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.authPrimary,
//                   foregroundColor: AppColors.textInverse,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(26)),
//                   elevation: 0,
//                 ),
//                 child: Text(
//                   l10n.actionRegister,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextButton(
//               onPressed: () => Navigator.pop(sheetCtx),
//               child: Text(
//                 l10n.actionLater,
//                 style: const TextStyle(
//                   color: AppColors.textSecondary,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final locale = Localizations.localeOf(context).languageCode;
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // Логотип
//         Container(
//           width: 64,
//           height: 64,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color:
//                 isDark ? AppColors.surfaceMutedDark : AppColors.surfaceMuted,
//             border: Border.all(color: AppColors.border),
//           ),
//           child: ClipOval(
//             child: university.logoUrl.isNotEmpty
//                 ? Image.network(
//                     university.logoUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) =>
//                         _Initial(name: university.name.localized(locale)),
//                   )
//                 : _Initial(name: university.name.localized(locale)),
//           ),
//         ),
//         const SizedBox(width: 14),

//         // Название и город
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 university.name.localized(locale),
//                 style: TextStyle(
//                   fontSize: 17,
//                   fontWeight: FontWeight.w700,
//                   color: isDark
//                       ? AppColors.textInverse
//                       : AppColors.textPrimary,
//                   height: 1.25,
//                 ),
//               ),
//               const SizedBox(height: 3),
//               Text(
//                 university.city.localized(locale),
//                 style: const TextStyle(
//                     fontSize: 13, color: AppColors.textSecondary),
//               ),
//             ],
//           ),
//         ),

//         // Кнопка лайка с анимацией пружины
//         ValueListenableBuilder<Set<String>>(
//           valueListenable: GlobalFavoritesNotifier.instance,
//           builder: (_, favorites, __) {
//             final isFav = favorites.contains(universityId);
//             return _LikeButton(
//               isDark: isDark,
//               isFav: isFav,
//               onTap: () => _handleLike(context),
//             );
//           },
//         ),
//         const SizedBox(width: 10),

//         // Кнопка отзывов
//         _ActionButton(
//           isDark: isDark,
//           onTap: () => context.push('/university/$universityId/reviews'),
//           child: Icon(
//             Icons.chat_bubble_outline_rounded,
//             size: 20,
//             color:
//                 isDark ? AppColors.textInverse : AppColors.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─── Кнопка лайка с пружинной анимацией ──────────────────────────────────────

// /// При нажатии — иконка сжимается и выпрыгивает обратно.
// /// При переключении isLiked — плавный swap иконки через AnimatedSwitcher.
// class _LikeButton extends StatefulWidget {
//   const _LikeButton({
//     required this.isDark,
//     required this.isFav,
//     required this.onTap,
//   });

//   final bool isDark;
//   final bool isFav;
//   final VoidCallback onTap;

//   @override
//   State<_LikeButton> createState() => _LikeButtonState();
// }

// class _LikeButtonState extends State<_LikeButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _ctrl;
//   late final Animation<double> _springScale;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 450),
//     );
//     _springScale = TweenSequence<double>([
//       TweenSequenceItem(
//         tween: Tween(begin: 1.0, end: 1.55)
//             .chain(CurveTween(curve: Curves.easeOut)),
//         weight: 35,
//       ),
//       TweenSequenceItem(
//         tween: Tween(begin: 1.55, end: 0.80)
//             .chain(CurveTween(curve: Curves.easeIn)),
//         weight: 30,
//       ),
//       TweenSequenceItem(
//         tween: Tween(begin: 0.80, end: 1.0)
//             .chain(CurveTween(curve: Curves.elasticOut)),
//         weight: 35,
//       ),
//     ]).animate(_ctrl);
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _ActionButton(
//       isDark: widget.isDark,
//       onTap: () {
//         _ctrl.forward(from: 0);
//         widget.onTap();
//       },
//       child: ScaleTransition(
//         scale: _springScale,
//         child: AnimatedSwitcher(
//           duration: const Duration(milliseconds: 220),
//           switchInCurve: Curves.easeIn,
//           switchOutCurve: Curves.easeOut,
//           transitionBuilder: (child, animation) => ScaleTransition(
//             scale: animation,
//             child: child,
//           ),
//           child: Icon(
//             widget.isFav
//                 ? Icons.favorite_rounded
//                 : Icons.favorite_border_rounded,
//             key: ValueKey(widget.isFav),
//             color: widget.isFav
//                 ? AppColors.danger
//                 : (widget.isDark
//                     ? AppColors.textInverse
//                     : AppColors.textPrimary),
//             size: 20,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── Базовая кнопка-иконка ────────────────────────────────────────────────────

// class _ActionButton extends StatelessWidget {
//   const _ActionButton({
//     required this.isDark,
//     required this.onTap,
//     required this.child,
//   });

//   final bool isDark;
//   final VoidCallback onTap;
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 42,
//         height: 42,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isDark
//               ? AppColors.surfaceMutedDark
//               : AppColors.backgroundLight,
//           border: Border.all(
//             color: isDark ? Colors.transparent : AppColors.border,
//           ),
//         ),
//         child: Center(child: child),
//       ),
//     );
//   }
// }

// // ─── Буква-заглушка логотипа ──────────────────────────────────────────────────

// class _Initial extends StatelessWidget {
//   const _Initial({required this.name});

//   final String name;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         name.isNotEmpty ? name[0].toUpperCase() : 'U',
//         style: const TextStyle(
//           fontSize: 22,
//           fontWeight: FontWeight.w800,
//           color: AppColors.authPrimaryLight,
//         ),
//       ),
//     );
//   }
// }

// // ─── Вкладки ──────────────────────────────────────────────────────────────────

// class _Tabs extends StatelessWidget {
//   const _Tabs({required this.current, required this.isDark});

//   final UniversityDetailTab current;
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return Row(
//       children: [
//         _TabItem(
//           label: l10n.universityTabDescription,
//           tab: UniversityDetailTab.description,
//           current: current,
//           isDark: isDark,
//         ),
//         const SizedBox(width: 4),
//         _TabItem(
//           label: l10n.universityTabPrograms,
//           tab: UniversityDetailTab.programs,
//           current: current,
//           isDark: isDark,
//         ),
//         const SizedBox(width: 4),
//         _TabItem(
//           label: l10n.universityTabNews,
//           tab: UniversityDetailTab.news,
//           current: current,
//           isDark: isDark,
//         ),
//       ],
//     );
//   }
// }

// class _TabItem extends StatelessWidget {
//   const _TabItem({
//     required this.label,
//     required this.tab,
//     required this.current,
//     required this.isDark,
//   });

//   final String label;
//   final UniversityDetailTab tab;
//   final UniversityDetailTab current;
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     final isSelected = tab == current;
//     final activeColor =
//         isDark ? AppColors.textInverse : AppColors.textPrimary;

//     return GestureDetector(
//       onTap: () => context.read<UniversityDetailCubit>().selectTab(tab),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         curve: Curves.easeOut,
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: isSelected
//             ? BoxDecoration(
//                 color: isDark
//                     ? AppColors.surfaceMutedDark
//                     : AppColors.backgroundLight,
//                 border: Border.all(color: activeColor, width: 1.5),
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withValues(alpha: 0.06),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               )
//             : null,
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight:
//                 isSelected ? FontWeight.w600 : FontWeight.w400,
//             color: isSelected ? activeColor : AppColors.textSecondary,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── Контент вкладки ──────────────────────────────────────────────────────────

// class _TabContent extends StatelessWidget {
//   const _TabContent({
//     required this.state,
//     required this.university,
//     required this.isDark,
//     required this.universityId,
//   });

//   final UniversityDetailState state;
//   final University university;
//   final bool isDark;
//   final String universityId;

//   @override
//   Widget build(BuildContext context) {
//     final locale = Localizations.localeOf(context).languageCode;
//     final l10n = AppLocalizations.of(context);
//     switch (state.tab) {
//       case UniversityDetailTab.description:
//         return Column(
//           children: [
//             _Card(
//               isDark: isDark,
//               child: Text(
//                 university.description.localized(locale),
//                 style: TextStyle(
//                   fontSize: 15,
//                   height: 1.6,
//                   color: isDark
//                       ? AppColors.textInverse
//                       : AppColors.textPrimary,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 14),
//             _ContactsCard(university: university, isDark: isDark),
//             const SizedBox(height: 14),
//             _AdmissionCard(
//                 university: university, l10n: l10n, isDark: isDark),
//           ],
//         );

//       case UniversityDetailTab.programs:
//         if (state.programsLoading) {
//           return const SizedBox(
//             height: 200,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
//         if (state.programs.isEmpty) {
//           return _EmptyTab(isDark: isDark, label: l10n.universityNewsEmpty);
//         }
//         return Column(
//           children: state.programs
//               .map((p) => Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: _ProgramItem(program: p, isDark: isDark),
//                   ))
//               .toList(),
//         );

//       case UniversityDetailTab.news:
//         if (state.newsLoading) {
//           return const SizedBox(
//             height: 200,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
//         if (state.news.isEmpty) {
//           return _EmptyTab(isDark: isDark, label: l10n.universityNewsEmpty);
//         }
//         return Column(
//           children: state.news
//               .map((n) => Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: _NewsItem(news: n, isDark: isDark),
//                   ))
//               .toList(),
//         );
//     }
//   }
// }

// // ─── Пустая вкладка ───────────────────────────────────────────────────────────

// class _EmptyTab extends StatelessWidget {
//   const _EmptyTab({required this.isDark, required this.label});

//   final bool isDark;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: Center(
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 16,
//             color: (isDark ? AppColors.textInverse : AppColors.textPrimary)
//                 .withValues(alpha: 0.4),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── ProgramItem ──────────────────────────────────────────────────────────────

// class _ProgramItem extends StatelessWidget {
//   const _ProgramItem({required this.program, required this.isDark});

//   final UniversityProgram program;
//   final bool isDark;

//   void _showDialog(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     showDialog<void>(
//       context: context,
//       builder: (ctx) => Dialog(
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(24)),
//         backgroundColor: isDark
//             ? AppColors.surfaceMutedDark
//             : AppColors.backgroundLight,
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 44,
//                     height: 44,
//                     decoration: BoxDecoration(
//                       color: AppColors.brandAccent.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.school_rounded,
//                         color: AppColors.brandAccent, size: 22),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Text(
//                       program.name.localized(context.locale.languageCode),
//                       style: TextStyle(
//                         fontSize: 17,
//                         fontWeight: FontWeight.w700,
//                         color: isDark
//                             ? AppColors.textInverse
//                             : AppColors.textPrimary,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 program.description.localized(context.locale.languageCode),
//                 style: TextStyle(
//                   fontSize: 14,
//                   height: 1.5,
//                   color: isDark
//                       ? AppColors.textInverse.withValues(alpha: 0.8)
//                       : AppColors.textSecondary,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               _InfoRow(
//                 icon: Icons.military_tech_rounded,
//                 label: l10n.professionDuration,
//                 value: program.degree.localized(context.locale.languageCode),
//                 isDark: isDark,
//               ),
//               const SizedBox(height: 8),
//               _InfoRow(
//                 icon: Icons.access_time_rounded,
//                 label: l10n.professionDuration,
//                 value: program.duration,
//                 isDark: isDark,
//               ),
//               const SizedBox(height: 8),
//               _InfoRow(
//                 icon: Icons.attach_money_rounded,
//                 label: l10n.professionCost,
//                 value: program.costRange,
//                 isDark: isDark,
//               ),
//               const SizedBox(height: 8),
//               _InfoRow(
//                 icon: Icons.language_rounded,
//                 label: l10n.professionLanguage,
//                 value: program.languages.join(', '),
//                 isDark: isDark,
//               ),
//               if (program.jobs.isNotEmpty) ...[
//                 const SizedBox(height: 8),
//                 _InfoRow(
//                   icon: Icons.work_outline_rounded,
//                   label: l10n.professionJobs,
//                   value: program.jobs.join(', '),
//                   isDark: isDark,
//                 ),
//               ],
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.of(ctx).pop(),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.brandAccent,
//                     foregroundColor: AppColors.backgroundDark,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14)),
//                     elevation: 0,
//                   ),
//                   child: Text(
//                     l10n.actionClose,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w700, fontSize: 15),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showDialog(context),
//       child: _Card(
//         isDark: isDark,
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     program.name.localized(context.locale.languageCode),
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: isDark
//                           ? AppColors.textInverse
//                           : AppColors.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     '${program.degree} · ${program.duration}',
//                     style: const TextStyle(
//                       fontSize: 13,
//                       color: AppColors.textSecondary,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: 30,
//               height: 30,
//               decoration: BoxDecoration(
//                 color: AppColors.brandAccent.withValues(alpha: 0.15),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.info_outline_rounded,
//                   size: 17, color: AppColors.brandAccent),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// extension on BuildContext {
//   get locale => null;
// }

// // ─── NewsItem ─────────────────────────────────────────────────────────────────

// class _NewsItem extends StatelessWidget {
//   const _NewsItem({required this.news, required this.isDark});

//   final UniversityNews news;
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     final dateStr =
//         DateFormat('d MMMM yyyy', 'ru').format(news.publishedAt);
//     return _Card(
//       isDark: isDark,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (news.imageUrl.isNotEmpty) ...[
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 news.imageUrl,
//                 height: 160,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => const SizedBox.shrink(),
//               ),
//             ),
//             const SizedBox(height: 12),
//           ],
//           Text(
//             dateStr,
//             style: const TextStyle(
//               fontSize: 12,
//               color: AppColors.textSecondary,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             news.title,
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w700,
//               height: 1.3,
//               color: isDark
//                   ? AppColors.textInverse
//                   : AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             news.body,
//             style: TextStyle(
//               fontSize: 14,
//               height: 1.5,
//               color: isDark
//                   ? AppColors.textInverse.withValues(alpha: 0.75)
//                   : AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── InfoRow ──────────────────────────────────────────────────────────────────

// class _InfoRow extends StatelessWidget {
//   const _InfoRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.isDark,
//   });

//   final IconData icon;
//   final String label;
//   final String value;
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 17, color: AppColors.brandAccent),
//         const SizedBox(width: 8),
//         Expanded(
//           child: RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: '$label: ',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     color: isDark
//                         ? AppColors.textInverse
//                         : AppColors.textPrimary,
//                   ),
//                 ),
//                 TextSpan(
//                   text: value,
//                   style: const TextStyle(
//                       fontSize: 14, color: AppColors.textSecondary),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ─── ContactsCard ─────────────────────────────────────────────────────────────

// class _ContactsCard extends StatelessWidget {
//   const _ContactsCard({required this.university, required this.isDark});

//   final University university;
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     final rows = <Widget>[];

//     void addRow(IconData icon, String text) {
//       if (rows.isNotEmpty) {
//         rows.add(Divider(
//           height: 20,
//           color: (isDark ? AppColors.textInverse : AppColors.textPrimary)
//               .withValues(alpha: 0.08),
//         ));
//       }
//       rows.add(Row(
//         children: [
//           Icon(icon, color: AppColors.textSecondary, size: 20),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 15,
//                 color: isDark
//                     ? AppColors.textInverse
//                     : AppColors.textPrimary,
//               ),
//             ),
//           ),
//           const Icon(Icons.chevron_right_rounded,
//               color: AppColors.textMuted, size: 20),
//         ],
//       ));
//     }

//     if (university.website.isNotEmpty) {
//       addRow(Icons.language_rounded, university.website);
//     }
//     if (university.instagram.isNotEmpty) {
//       addRow(Icons.camera_alt_outlined, university.instagram);
//     }
//     if (university.phone != null && university.phone!.isNotEmpty) {
//       addRow(Icons.phone_outlined, university.phone!);
//     }
//     if (university.email != null && university.email!.isNotEmpty) {
//       addRow(Icons.email_outlined, university.email!);
//     }
//     if (rows.isEmpty) return const SizedBox.shrink();
//     return _Card(isDark: isDark, child: Column(children: rows));
//   }
// }

// // ─── AdmissionCard ────────────────────────────────────────────────────────────

// class _AdmissionCard extends StatelessWidget {
//   const _AdmissionCard({
//     required this.university,
//     required this.l10n,
//     required this.isDark,
//   });

//   final University university;
//   final AppLocalizations l10n;
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     final lines = <String>[
//       if (university.minEnt != null)
//         l10n.universityMinEnt(university.minEnt!),
//       if (university.minGpa != null)
//         l10n.universityMinGpa(university.minGpa!),
//       if (university.minIelts != null)
//         l10n.universityMinIelts(university.minIelts!),
//       if (university.languages.isNotEmpty)
//         '${l10n.universityLanguage}: ${university.languages.join(', ')}',
//       if (university.format.isNotEmpty)
//         '${l10n.universityFormat}: ${university.format}',
//       if (university.duration.isNotEmpty)
//         '${l10n.universityDuration}: ${university.duration}',
//       if (university.costRange.isNotEmpty)
//         '${l10n.universityCost}: ${university.costRange}',
//     ];
//     if (lines.isEmpty) return const SizedBox.shrink();
//     return _Card(
//       isDark: isDark,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             l10n.universityAdmissionTitle,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w700,
//               color: isDark
//                   ? AppColors.textInverse
//                   : AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 14),
//           ...lines.map((line) => Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Text(
//                   line,
//                   style: TextStyle(
//                     fontSize: 15,
//                     height: 1.5,
//                     color: isDark
//                         ? AppColors.textInverse
//                         : AppColors.textPrimary,
//                   ),
//                 ),
//               )),
//         ],
//       ),
//     );
//   }
// }

// // ─── Общая карточка ───────────────────────────────────────────────────────────

// class _Card extends StatelessWidget {
//   const _Card({required this.child, required this.isDark});

//   final Widget child;
//   final bool isDark;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: isDark
//             ? AppColors.surfaceMutedDark
//             : const Color(0xFFEFEDF6),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: child,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/favorites/favorites_repository.dart';
import '../../../data/news/university_news_model.dart';
import '../../../data/news/university_news_repository.dart';
import '../../../data/programs/university_program_model.dart';
import '../../../data/programs/university_program_repository.dart';
import '../../../data/university/university_model.dart';
import '../../../data/university/university_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../favorites/global_favorites_notifier.dart';
import '../bloc/university_detail_cubit.dart';
import '../bloc/university_detail_state.dart';

class UniversityDetailScreen extends StatelessWidget {
  const UniversityDetailScreen({
    super.key,
    required this.id,
    this.initialTab,
  });

  final String id;
  final String? initialTab;

  @override
  Widget build(BuildContext context) {
    final tab = _parseTab(initialTab);
    return BlocProvider(
      create: (context) => UniversityDetailCubit(
        universityRepository: context.read<UniversityRepository>(),
        programRepository: context.read<UniversityProgramRepository>(),
        newsRepository: context.read<UniversityNewsRepository>(),
      )..load(id, initialTab: tab),
      child: _UniversityDetailView(universityId: id),
    );
  }

  UniversityDetailTab _parseTab(String? tab) {
    return switch (tab) {
      'news' => UniversityDetailTab.news,
      'programs' => UniversityDetailTab.programs,
      _ => UniversityDetailTab.description,
    };
  }
}

// ─── Основной вид ─────────────────────────────────────────────────────────────

class _UniversityDetailView extends StatelessWidget {
  const _UniversityDetailView({required this.universityId});

  final String universityId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : const Color(0xFFF5F4FA);

    return BlocBuilder<UniversityDetailCubit, UniversityDetailState>(
      builder: (context, state) {
        if (state.status == UniversityDetailStatus.loading ||
            state.status == UniversityDetailStatus.initial) {
          return Scaffold(
            backgroundColor: bgColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final uni = state.university;
        if (uni == null) {
          return Scaffold(
            backgroundColor: bgColor,
            body: Center(child: Text(l10n.searchEmpty)),
          );
        }
        return Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _TopBar(isDark: isDark)),
                SliverToBoxAdapter(child: _HeroImage(university: uni)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: _Header(
                      university: uni,
                      isDark: isDark,
                      universityId: universityId,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _Tabs(current: state.tab, isDark: isDark),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                    // ── AnimatedSwitcher для плавной смены контента ──────
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        // Слайд + fade: новый контент въезжает снизу
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(0, 0.06),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ));
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                      // key — чтобы AnimatedSwitcher понял что контент сменился
                      child: KeyedSubtree(
                        key: ValueKey(state.tab),
                        child: _TabContent(
                          state: state,
                          university: uni,
                          isDark: isDark,
                          universityId: universityId,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── TopBar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.textInverse : AppColors.textPrimary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(Icons.arrow_back_rounded, color: color, size: 24),
          ),
        ],
      ),
    );
  }
}

// ─── HeroImage ────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: university.imageUrl.isNotEmpty
          ? Image.network(
              university.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _HeroPlaceholder(),
            )
          : const _HeroPlaceholder(),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.divider,
      child: const Center(
        child: Icon(
          Icons.school_outlined,
          color: AppColors.authPrimaryLight,
          size: 52,
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.university,
    required this.isDark,
    required this.universityId,
  });

  final University university;
  final bool isDark;
  final String universityId;

  Future<void> _handleLike(BuildContext context) async {
    HapticFeedback.lightImpact();
    try {
      await GlobalFavoritesNotifier.instance.toggle(universityId);
    } on NotAuthenticatedException {
      if (!context.mounted) return;
      _showFavAuthSheet(context);
    }
  }

  void _showFavAuthSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.backgroundLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Icon(Icons.favorite_rounded,
                color: AppColors.danger, size: 44),
            const SizedBox(height: 16),
            Text(
              l10n.favoriteAuthRequired,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.favoriteAuthSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(sheetCtx);
                  context.push(RouteNames.register);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.authPrimary,
                  foregroundColor: AppColors.textInverse,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26)),
                  elevation: 0,
                ),
                child: Text(
                  l10n.actionRegister,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(sheetCtx),
              child: Text(
                l10n.actionLater,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isDark ? AppColors.surfaceMutedDark : AppColors.surfaceMuted,
            border: Border.all(color: AppColors.border),
          ),
          child: ClipOval(
            child: university.logoUrl.isNotEmpty
                ? Image.network(
                    university.logoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        _Initial(name: university.name.localized(locale)),
                  )
                : _Initial(name: university.name.localized(locale)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                university.name.localized(locale),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.textInverse
                      : AppColors.textPrimary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                university.city.localized(locale),
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        ValueListenableBuilder<Set<String>>(
          valueListenable: GlobalFavoritesNotifier.instance,
          builder: (_, favorites, __) {
            final isFav = favorites.contains(universityId);
            return _LikeButton(
              isDark: isDark,
              isFav: isFav,
              onTap: () => _handleLike(context),
            );
          },
        ),
        const SizedBox(width: 10),
        _ActionButton(
          isDark: isDark,
          onTap: () => context.push('/university/$universityId/reviews'),
          child: Icon(
            Icons.chat_bubble_outline_rounded,
            size: 20,
            color:
                isDark ? AppColors.textInverse : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ─── Кнопка лайка с пружинной анимацией ──────────────────────────────────────

class _LikeButton extends StatefulWidget {
  const _LikeButton({
    required this.isDark,
    required this.isFav,
    required this.onTap,
  });

  final bool isDark;
  final bool isFav;
  final VoidCallback onTap;

  @override
  State<_LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<_LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _springScale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _springScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.55)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.55, end: 0.80)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.80, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 35,
      ),
    ]).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ActionButton(
      isDark: widget.isDark,
      onTap: () {
        _ctrl.forward(from: 0);
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _springScale,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: Icon(
            widget.isFav
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            key: ValueKey(widget.isFav),
            color: widget.isFav
                ? AppColors.danger
                : (widget.isDark
                    ? AppColors.textInverse
                    : AppColors.textPrimary),
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ─── Базовая кнопка-иконка ────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.isDark,
    required this.onTap,
    required this.child,
  });

  final bool isDark;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? AppColors.surfaceMutedDark
              : AppColors.backgroundLight,
          border: Border.all(
            color: isDark ? Colors.transparent : AppColors.border,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}

// ─── Буква-заглушка логотипа ──────────────────────────────────────────────────

class _Initial extends StatelessWidget {
  const _Initial({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.authPrimaryLight,
        ),
      ),
    );
  }
}

// ─── Вкладки со скользящим индикатором (iOS-стиль) ──────────────────────────

class _Tabs extends StatefulWidget {
  const _Tabs({required this.current, required this.isDark});

  final UniversityDetailTab current;
  final bool isDark;

  @override
  State<_Tabs> createState() => _TabsState();
}

class _TabsState extends State<_Tabs> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = widget.isDark;

    final tabs = [
      (UniversityDetailTab.description, l10n.universityTabDescription),
      (UniversityDetailTab.programs, l10n.universityTabPrograms),
      (UniversityDetailTab.news, l10n.universityTabNews),
    ];

    final currentIndex = tabs.indexWhere((t) => t.$1 == widget.current);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1C1C1E)
            : const Color(0xFFE5E5EA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - 8) / 3;

          return Stack(
            children: [
              // ── Скользящий индикатор ──────────────────────────────────
              AnimatedPositioned(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                left: currentIndex * itemWidth,
                top: 0,
                bottom: 0,
                width: itemWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF3A3A3C)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                ),
              ),

              // ── Текстовые кнопки поверх индикатора ───────────────────
              Row(
                children: List.generate(tabs.length, (i) {
                  final (tab, label) = tabs[i];
                  final isSelected = tab == widget.current;

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      context
                          .read<UniversityDetailCubit>()
                          .selectTab(tab);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: itemWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? (isDark
                                    ? Colors.white
                                    : AppColors.textPrimary)
                                : AppColors.textSecondary,
                            letterSpacing: isSelected ? -0.1 : 0,
                          ),
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── Контент вкладки ──────────────────────────────────────────────────────────

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.state,
    required this.university,
    required this.isDark,
    required this.universityId,
  });

  final UniversityDetailState state;
  final University university;
  final bool isDark;
  final String universityId;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);
    switch (state.tab) {
      case UniversityDetailTab.description:
        return Column(
          children: [
            _Card(
              isDark: isDark,
              child: Text(
                university.description.localized(locale),
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: isDark
                      ? AppColors.textInverse
                      : AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 14),
            _ContactsCard(university: university, isDark: isDark),
            const SizedBox(height: 14),
            _AdmissionCard(
                university: university, l10n: l10n, isDark: isDark),
          ],
        );

      case UniversityDetailTab.programs:
        if (state.programsLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.programs.isEmpty) {
          return _EmptyTab(isDark: isDark, label: l10n.universityNewsEmpty);
        }
        return Column(
          children: state.programs
              .map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ProgramItem(program: p, isDark: isDark),
                  ))
              .toList(),
        );

      case UniversityDetailTab.news:
        if (state.newsLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.news.isEmpty) {
          return _EmptyTab(isDark: isDark, label: l10n.universityNewsEmpty);
        }
        return Column(
          children: state.news
              .map((n) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _NewsItem(news: n, isDark: isDark),
                  ))
              .toList(),
        );
    }
  }
}

// ─── Пустая вкладка ───────────────────────────────────────────────────────────

class _EmptyTab extends StatelessWidget {
  const _EmptyTab({required this.isDark, required this.label});

  final bool isDark;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: (isDark ? AppColors.textInverse : AppColors.textPrimary)
                .withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

// ─── ProgramItem ──────────────────────────────────────────────────────────────

class _ProgramItem extends StatelessWidget {
  const _ProgramItem({required this.program, required this.isDark});

  final UniversityProgram program;
  final bool isDark;

  void _showDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark
            ? AppColors.surfaceMutedDark
            : AppColors.backgroundLight,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.brandAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.school_rounded,
                        color: AppColors.brandAccent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      program.name.localized(locale),
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.textInverse
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                program.description.localized(locale),
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark
                      ? AppColors.textInverse.withValues(alpha: 0.8)
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.military_tech_rounded,
                label: l10n.professionDuration,
                value: program.degree.localized(locale),
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.access_time_rounded,
                label: l10n.professionDuration,
                value: program.duration,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.attach_money_rounded,
                label: l10n.professionCost,
                value: program.costRange,
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.language_rounded,
                label: l10n.professionLanguage,
                value: program.languages.join(', '),
                isDark: isDark,
              ),
              if (program.jobs.isNotEmpty) ...[
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.work_outline_rounded,
                  label: l10n.professionJobs,
                  value: program.jobs
                      .map((j) => j.localized(locale))
                      .join(', '),
                  isDark: isDark,
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandAccent,
                    foregroundColor: AppColors.backgroundDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.actionClose,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return GestureDetector(
      onTap: () => _showDialog(context),
      child: _Card(
        isDark: isDark,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.name.localized(locale),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textInverse
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${program.degree.localized(locale)} · ${program.duration}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.brandAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.info_outline_rounded,
                  size: 17, color: AppColors.brandAccent),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── NewsItem ─────────────────────────────────────────────────────────────────

class _NewsItem extends StatelessWidget {
  const _NewsItem({required this.news, required this.isDark});

  final UniversityNews news;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final dateStr =
        DateFormat('d MMMM yyyy', 'ru').format(news.publishedAt);
    return _Card(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (news.imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                news.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            dateStr,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            news.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.3,
              color: isDark
                  ? AppColors.textInverse
                  : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            news.body,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: isDark
                  ? AppColors.textInverse.withValues(alpha: 0.75)
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── InfoRow ──────────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.brandAccent),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textInverse
                        : AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── ContactsCard ─────────────────────────────────────────────────────────────

class _ContactsCard extends StatelessWidget {
  const _ContactsCard({required this.university, required this.isDark});

  final University university;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    void addRow(IconData icon, String text) {
      if (rows.isNotEmpty) {
        rows.add(Divider(
          height: 20,
          color: (isDark ? AppColors.textInverse : AppColors.textPrimary)
              .withValues(alpha: 0.08),
        ));
      }
      rows.add(Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: isDark
                    ? AppColors.textInverse
                    : AppColors.textPrimary,
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textMuted, size: 20),
        ],
      ));
    }

    if (university.website.isNotEmpty) {
      addRow(Icons.language_rounded, university.website);
    }
    if (university.instagram.isNotEmpty) {
      addRow(Icons.camera_alt_outlined, university.instagram);
    }
    if (university.phone != null && university.phone!.isNotEmpty) {
      addRow(Icons.phone_outlined, university.phone!);
    }
    if (university.email != null && university.email!.isNotEmpty) {
      addRow(Icons.email_outlined, university.email!);
    }
    if (rows.isEmpty) return const SizedBox.shrink();
    return _Card(isDark: isDark, child: Column(children: rows));
  }
}

// ─── AdmissionCard ────────────────────────────────────────────────────────────

class _AdmissionCard extends StatelessWidget {
  const _AdmissionCard({
    required this.university,
    required this.l10n,
    required this.isDark,
  });

  final University university;
  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final lines = <String>[
      if (university.minEnt != null)
        l10n.universityMinEnt(university.minEnt!),
      if (university.minGpa != null)
        l10n.universityMinGpa(university.minGpa!),
      if (university.minIelts != null)
        l10n.universityMinIelts(university.minIelts!),
      if (university.languages.isNotEmpty)
        '${l10n.universityLanguage}: ${university.languages.join(', ')}',
      if (university.format.isNotEmpty)
        '${l10n.universityFormat}: ${university.format}',
      if (university.duration.isNotEmpty)
        '${l10n.universityDuration}: ${university.duration}',
      if (university.costRange.isNotEmpty)
        '${l10n.universityCost}: ${university.costRange}',
    ];
    if (lines.isEmpty) return const SizedBox.shrink();
    return _Card(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.universityAdmissionTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.textInverse
                  : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...lines.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  line,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: isDark
                        ? AppColors.textInverse
                        : AppColors.textPrimary,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ─── Общая карточка ───────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.isDark});

  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceMutedDark
            : const Color(0xFFEFEDF6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}