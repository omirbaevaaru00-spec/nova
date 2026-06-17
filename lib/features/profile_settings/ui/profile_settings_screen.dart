
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../../../core/localization/locale_controller.dart';
// import '../../../core/router/route_names.dart';
// import '../../../core/services/firebase_service.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/theme_controller.dart';
// import '../../../data/auth/auth_repository.dart';
// import '../../../data/news/university_news_repository.dart';
// import '../../../data/onboarding/onboarding_repository.dart';
// import '../../../data/profile/profile_repository_impl.dart';
// import '../../../data/programs/university_program_repository.dart';
// import '../../../l10n/generated/app_localizations.dart';
// import '../../../utils/university_seed_data.dart';
// import '../bloc/profile_settings_cubit.dart';
// import '../bloc/profile_settings_state.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ProfileSettingsCubit(
//         authRepository: context.read<AuthRepository>(),
//         profileRepository: ProfileRepositoryImpl(FirebaseService.instance),
//         onboardingRepository: context.read<OnboardingRepository>(),
//         firebaseService: FirebaseService.instance,
//       )..load(),
//       child: const _SettingsView(),
//     );
//   }
// }

// class _SettingsView extends StatelessWidget {
//   const _SettingsView();

//   static const _interestEmojis = {
//     'it': '💻',
//     'medicine': '🩺',
//     'business': '📊',
//     'grants': '🎓',
//     'design': '🎨',
//     'law': '⚖️',
//     'pedagogy': '📚',
//     'engineering': '⚙️',
//     'bachelor': '🏫',
//     'college': '🏢',
//     'master': '🎯',
//   };

//   String _profileSubtitle(ProfileSettingsState s, AppLocalizations l10n) {
//     final parts = <String>[
//       if (s.name.isNotEmpty) s.name,
//       if (s.city.isNotEmpty) s.city,
//     ];
//     return parts.isEmpty ? l10n.settingsEmpty : parts.join(' · ');
//   }

//   String _scoresSubtitle(ProfileSettingsState s, AppLocalizations l10n) {
//     final parts = <String>[
//       if (s.gpa.isNotEmpty) 'GPA: ${s.gpa}',
//       if (s.ielts.isNotEmpty) 'IELTS: ${s.ielts}',
//       if (s.ent.isNotEmpty) 'ЕНТ: ${s.ent}',
//     ];
//     return parts.isEmpty ? l10n.settingsEmpty : parts.join(' · ');
//   }

//   String _interestsSubtitle(ProfileSettingsState s, AppLocalizations l10n) {
//     if (s.interests.isEmpty) return l10n.settingsInterestsEmpty;
//     return s.interests.take(5).map((k) => _interestEmojis[k] ?? k).join('  ');
//   }

//   String _languageLabel(BuildContext context, AppLocalizations l10n) {
//     return switch (LocaleController.instance.locale.languageCode) {
//       'kk' => l10n.languageKazakh,
//       'en' => l10n.languageEnglish,
//       _ => l10n.languageRussian,
//     };
//   }

//   void _showSnackBar(BuildContext context, String text) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(text),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 2),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         margin: const EdgeInsets.all(16),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bgColor =
//         isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;

//     return AnimatedBuilder(
//       animation: ThemeController.instance,
//       builder: (context, _) {
//         return BlocConsumer<ProfileSettingsCubit, ProfileSettingsState>(
//           listenWhen: (a, b) => a.status != b.status,
//           listener: (context, state) {
//             switch (state.status) {
//               case ProfileSettingsStatus.saved:
//                 _showSnackBar(context, l10n.settingsSaved);
//               case ProfileSettingsStatus.saveError:
//                 _showSnackBar(context, l10n.settingsSaveError);
//               case ProfileSettingsStatus.photoError:
//                 _showSnackBar(context, l10n.settingsPhotoError);
//               case ProfileSettingsStatus.signedOut:
//                 context.go(RouteNames.register);
//               default:
//                 break;
//             }
//           },
//           builder: (context, state) {
//             return Scaffold(
//               backgroundColor: bgColor,
//               appBar: AppBar(
//                 backgroundColor: bgColor,
//                 elevation: 0,
//                 scrolledUnderElevation: 0,
//                 leading: GestureDetector(
//                   onTap: () => context.pop(),
//                   child: Container(
//                     margin: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: isDark
//                           ? AppColors.surfaceMutedDark
//                           : AppColors.backgroundLight,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.06),
//                           blurRadius: 8,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       CupertinoIcons.back,
//                       color: isDark
//                           ? AppColors.textInverse
//                           : AppColors.textPrimary,
//                       size: 20,
//                     ),
//                   ),
//                 ),
//                 title: Text(
//                   l10n.settingsTitle,
//                   style: TextStyle(
//                     color: isDark
//                         ? AppColors.textInverse
//                         : AppColors.textPrimary,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 17,
//                   ),
//                 ),
//                 centerTitle: true,
//               ),
//               body: ListView(
//                 padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
//                 children: [
//                   // ── Профиль ────────────────────────────────────────────
//                   _SettingsItem(
//                     isDark: isDark,
//                     icon: CupertinoIcons.person,
//                     iconColor: AppColors.brandPrimary,
//                     title: l10n.settingsEditProfile,
//                     subtitle: _profileSubtitle(state, l10n),
//                     onTap: () => _editProfile(context, state, l10n),
//                   ),
//                   const SizedBox(height: 10),

//                   // ── Баллы ──────────────────────────────────────────────
//                   _SettingsItem(
//                     isDark: isDark,
//                     icon: CupertinoIcons.star_fill,
//                     iconColor: AppColors.warning,
//                     title: l10n.settingsEditScores,
//                     subtitle: _scoresSubtitle(state, l10n),
//                     onTap: context
//                             .read<ProfileSettingsCubit>()
//                             .isAuthenticated
//                         ? () => _editScores(context, state, l10n)
//                         : () => _showAuthRequired(context, l10n),
//                   ),
//                   const SizedBox(height: 10),

//                   // ── Интересы ───────────────────────────────────────────
//                   _SettingsItem(
//                     isDark: isDark,
//                     icon: CupertinoIcons.doc_checkmark,
//                     iconColor: AppColors.warning,
//                     title: l10n.settingsQuiz,
//                     subtitle: _interestsSubtitle(state, l10n),
//                     onTap: () async {
//                       await context.push(RouteNames.onboarding);
//                       if (context.mounted) {
//                         await context
//                             .read<ProfileSettingsCubit>()
//                             .reloadInterests();
//                       }
//                     },
//                   ),
//                   const SizedBox(height: 10),

//                   // ── Язык ───────────────────────────────────────────────
//                   _SettingsItem(
//                     isDark: isDark,
//                     icon: CupertinoIcons.globe,
//                     iconColor: AppColors.success,
//                     title: l10n.settingsLanguageItem,
//                     subtitle: _languageLabel(context, l10n),
//                     onTap: () => _pickLanguage(context, l10n),
//                   ),
//                   const SizedBox(height: 10),

//                   // ── Тема ───────────────────────────────────────────────
//                   _SettingsItemWithToggle(
//                     isDark: isDark,
//                     icon: CupertinoIcons.moon_fill,
//                     iconColor: const Color(0xFF7C3AED),
//                     title: l10n.settingsThemeItem,
//                     value: ThemeController.instance.isDark,
//                     onChanged: (v) => ThemeController.instance.setDark(v),
//                   ),
//                   const SizedBox(height: 10),

//                   // ── Поддержка ──────────────────────────────────────────
//                   _SettingsItem(
//                     isDark: isDark,
//                     icon: CupertinoIcons.question_circle,
//                     iconColor: AppColors.brandAccent,
//                     title: l10n.settingsHelpItem,
//                     subtitle: l10n.settingsHelpSubtitle,
//                     onTap: () => context.push(RouteNames.support),
//                   ),
//                   const SizedBox(height: 10),

//                   // ── Загрузить данные в Firebase (временная кнопка) ─────
//                   _SeedButton(isDark: isDark),
//                   const SizedBox(height: 32),

//                   // ── Выход ──────────────────────────────────────────────
//                   _DangerButton(
//                     isDark: isDark,
//                     icon: CupertinoIcons.square_arrow_left,
//                     label: l10n.settingsLogoutItem,
//                     onTap: () => _confirmSignOut(context, l10n),
//                   ),
//                   const SizedBox(height: 12),

//                   // ── Удалить аккаунт ────────────────────────────────────
//                   _DangerButton(
//                     isDark: isDark,
//                     icon: CupertinoIcons.trash,
//                     label: l10n.settingsDeleteAccount,
//                     onTap: () => _confirmDeleteAccount(context, l10n),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   void _editProfile(
//     BuildContext context,
//     ProfileSettingsState state,
//     AppLocalizations l10n,
//   ) {
//     final cubit = context.read<ProfileSettingsCubit>();
//     showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _ProfileBottomSheet(
//         initialName: state.name,
//         initialCity: state.city,
//         l10n: l10n,
//         onSave: (name, city) => cubit.updateProfile(name: name, city: city),
//       ),
//     );
//   }

//   void _editScores(
//     BuildContext context,
//     ProfileSettingsState state,
//     AppLocalizations l10n,
//   ) {
//     final cubit = context.read<ProfileSettingsCubit>();
//     showModalBottomSheet<void>(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => _ScoresBottomSheet(
//         initialGpa: state.gpa,
//         initialIelts: state.ielts,
//         initialEnt: state.ent,
//         l10n: l10n,
//         onSave: (gpa, ielts, ent) =>
//             cubit.updateScores(gpa: gpa, ielts: ielts, ent: ent),
//       ),
//     );
//   }

//   void _showAuthRequired(BuildContext context, AppLocalizations l10n) {
//     showCupertinoDialog(
//       context: context,
//       builder: (dialogContext) => CupertinoAlertDialog(
//         title: Text(l10n.settingsAuthTitle),
//         content: Text(l10n.settingsAuthText),
//         actions: [
//           CupertinoDialogAction(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: Text(l10n.actionOk),
//           ),
//         ],
//       ),
//     );
//   }

//   void _pickLanguage(BuildContext context, AppLocalizations l10n) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (sheetContext) => CupertinoActionSheet(
//         title: Text(l10n.chooseLanguage),
//         actions: [
//           CupertinoActionSheetAction(
//             onPressed: () {
//               LocaleController.instance.setLocale(const Locale('ru'));
//               Navigator.pop(sheetContext);
//             },
//             child: Text(l10n.languageRussian),
//           ),
//           CupertinoActionSheetAction(
//             onPressed: () {
//               LocaleController.instance.setLocale(const Locale('kk'));
//               Navigator.pop(sheetContext);
//             },
//             child: Text(l10n.languageKazakh),
//           ),
//           CupertinoActionSheetAction(
//             onPressed: () {
//               LocaleController.instance.setLocale(const Locale('en'));
//               Navigator.pop(sheetContext);
//             },
//             child: Text(l10n.languageEnglish),
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

//   void _confirmSignOut(BuildContext context, AppLocalizations l10n) {
//     final cubit = context.read<ProfileSettingsCubit>();
//     showCupertinoDialog(
//       context: context,
//       builder: (dialogContext) => CupertinoAlertDialog(
//         title: Text(l10n.settingsLogoutConfirmTitle),
//         content: Text(l10n.settingsLogoutConfirmText),
//         actions: [
//           CupertinoDialogAction(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: Text(l10n.actionCancel),
//           ),
//           CupertinoDialogAction(
//             isDestructiveAction: true,
//             onPressed: () {
//               Navigator.pop(dialogContext);
//               cubit.signOut();
//             },
//             child: Text(l10n.actionExit),
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmDeleteAccount(BuildContext context, AppLocalizations l10n) {
//     final cubit = context.read<ProfileSettingsCubit>();
//     showCupertinoDialog(
//       context: context,
//       builder: (dialogContext) => CupertinoAlertDialog(
//         title: Text(l10n.settingsDeleteAccountConfirmTitle),
//         content: Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: Text(l10n.settingsDeleteAccountConfirmBody),
//         ),
//         actions: [
//           CupertinoDialogAction(
//             onPressed: () => Navigator.pop(dialogContext),
//             child: Text(l10n.settingsDeleteAccountCancel),
//           ),
//           CupertinoDialogAction(
//             isDestructiveAction: true,
//             onPressed: () async {
//               Navigator.pop(dialogContext);
//               await cubit.deleteAccount();
//               if (context.mounted) {
//                 context.go(RouteNames.welcome);
//               }
//             },
//             child: Text(l10n.settingsDeleteAccountConfirm),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Кнопка загрузки данных в Firebase ───────────────────────────────────────

// class _SeedButton extends StatefulWidget {
//   const _SeedButton({required this.isDark});
//   final bool isDark;

//   @override
//   State<_SeedButton> createState() => _SeedButtonState();
// }

// class _SeedButtonState extends State<_SeedButton> {
//   bool _loading = false;
//   String _status = '';

//   Future<void> _runSeed() async {
//     setState(() {
//       _loading = true;
//       _status = 'Загрузка...';
//     });

//     try {
//       final programRepo = context.read<UniversityProgramRepository>();
//       final newsRepo = context.read<UniversityNewsRepository>();

//       int programCount = 0;
//       int newsCount = 0;

//       for (final entry in kSeedPrograms.entries) {
//         await programRepo.seedPrograms(entry.key, entry.value);
//         programCount += entry.value.length;
//         if (mounted) {
//           setState(() => _status = 'Загружаю ${entry.key}...');
//         }
//       }

//       for (final entry in kSeedNews.entries) {
//         await newsRepo.seedNews(entry.key, entry.value);
//         newsCount += entry.value.length;
//       }

//       if (mounted) {
//         setState(() {
//           _status = '✅ $programCount программ и $newsCount новостей загружено!';
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _status = '❌ Ошибка: $e');
//       }
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = widget.isDark;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       decoration: BoxDecoration(
//         color: isDark
//             ? const Color(0xFF1A2A1A)
//             : const Color(0xFFE8F5E9),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 34,
//                 height: 34,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
//                   borderRadius: BorderRadius.circular(9),
//                 ),
//                 child: const Icon(
//                   Icons.cloud_upload_outlined,
//                   color: Color(0xFF4CAF50),
//                   size: 18,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '🔧 Загрузить данные в Firebase',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF4CAF50),
//                       ),
//                     ),
//                     Text(
//                       'Программы и новости всех вузов',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (_loading)
//                 const SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Color(0xFF4CAF50),
//                   ),
//                 )
//               else
//                 GestureDetector(
//                   onTap: _runSeed,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF4CAF50),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Text(
//                       'Запустить',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           if (_status.isNotEmpty) ...[
//             const SizedBox(height: 10),
//             Text(
//               _status,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _status.startsWith('✅')
//                     ? const Color(0xFF4CAF50)
//                     : _status.startsWith('❌')
//                         ? Colors.red
//                         : AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }

// // ─── Кнопка-секция настроек ───────────────────────────────────────────────────

// class _SettingsItem extends StatelessWidget {
//   const _SettingsItem({
//     required this.isDark,
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.onTap,
//     this.subtitle,
//   });

//   final bool isDark;
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final String? subtitle;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: isDark
//               ? AppColors.surfaceMutedDark
//               : AppColors.backgroundLight,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
//           ),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 34,
//               height: 34,
//               decoration: BoxDecoration(
//                 color: iconColor.withValues(alpha: 0.12),
//                 borderRadius: BorderRadius.circular(9),
//               ),
//               child: Icon(icon, color: iconColor, size: 18),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: isDark
//                           ? AppColors.textInverse
//                           : AppColors.textPrimary,
//                     ),
//                   ),
//                   if (subtitle != null) ...[
//                     const SizedBox(height: 2),
//                     Text(
//                       subtitle!,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//             Icon(
//               CupertinoIcons.chevron_right,
//               size: 16,
//               color: AppColors.textMuted,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ─── Переключатель темы ───────────────────────────────────────────────────────

// class _SettingsItemWithToggle extends StatelessWidget {
//   const _SettingsItemWithToggle({
//     required this.isDark,
//     required this.icon,
//     required this.iconColor,
//     required this.title,
//     required this.value,
//     required this.onChanged,
//   });

//   final bool isDark;
//   final IconData icon;
//   final Color iconColor;
//   final String title;
//   final bool value;
//   final ValueChanged<bool> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       decoration: BoxDecoration(
//         color: isDark
//             ? AppColors.surfaceMutedDark
//             : AppColors.backgroundLight,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 34,
//             height: 34,
//             decoration: BoxDecoration(
//               color: iconColor.withValues(alpha: 0.12),
//               borderRadius: BorderRadius.circular(9),
//             ),
//             child: Icon(icon, color: iconColor, size: 18),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//                 color: isDark ? AppColors.textInverse : AppColors.textPrimary,
//               ),
//             ),
//           ),
//           CupertinoSwitch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: AppColors.brandAccent,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Кнопка опасного действия (выход / удалить) ───────────────────────────────

// class _DangerButton extends StatelessWidget {
//   const _DangerButton({
//     required this.isDark,
//     required this.icon,
//     required this.label,
//     required this.onTap,
//   });

//   final bool isDark;
//   final IconData icon;
//   final String label;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           color: isDark
//               ? AppColors.surfaceMutedDark
//               : AppColors.backgroundLight,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: AppColors.danger.withValues(alpha: 0.25),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: AppColors.danger, size: 18),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 15,
//                 fontWeight: FontWeight.w600,
//                 color: AppColors.danger,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// // ─── Bottom Sheet: Редактирование профиля ─────────────────────────────────────

// class _ProfileBottomSheet extends StatefulWidget {
//   const _ProfileBottomSheet({
//     required this.initialName,
//     required this.initialCity,
//     required this.l10n,
//     required this.onSave,
//   });

//   final String initialName;
//   final String initialCity;
//   final AppLocalizations l10n;
//   final void Function(String name, String city) onSave;

//   @override
//   State<_ProfileBottomSheet> createState() => _ProfileBottomSheetState();
// }

// class _ProfileBottomSheetState extends State<_ProfileBottomSheet> {
//   late final TextEditingController _nameCtrl;
//   late final TextEditingController _cityCtrl;

//   @override
//   void initState() {
//     super.initState();
//     _nameCtrl = TextEditingController(text: widget.initialName);
//     _cityCtrl = TextEditingController(text: widget.initialCity);
//   }

//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _cityCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: isDark
//                     ? const Color(0xFF3A3A3C)
//                     : const Color(0xFFD1D1D6),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             widget.l10n.settingsEditProfile,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: isDark ? Colors.white : AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 24),
//           _SheetField(
//             controller: _nameCtrl,
//             label: widget.l10n.dialogNamePlaceholder,
//             icon: CupertinoIcons.person,
//             isDark: isDark,
//             autofocus: true,
//           ),
//           const SizedBox(height: 12),
//           _SheetField(
//             controller: _cityCtrl,
//             label: widget.l10n.dialogCityPlaceholder,
//             icon: CupertinoIcons.location,
//             isDark: isDark,
//           ),
//           const SizedBox(height: 28),
//           SizedBox(
//             width: double.infinity,
//             height: 52,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 widget.onSave(
//                   _nameCtrl.text.trim(),
//                   _cityCtrl.text.trim(),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.brandPrimary,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16)),
//                 elevation: 0,
//               ),
//               child: Text(
//                 widget.l10n.actionSave,
//                 style: const TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Bottom Sheet: Редактирование баллов ──────────────────────────────────────

// class _ScoresBottomSheet extends StatefulWidget {
//   const _ScoresBottomSheet({
//     required this.initialGpa,
//     required this.initialIelts,
//     required this.initialEnt,
//     required this.l10n,
//     required this.onSave,
//   });

//   final String initialGpa;
//   final String initialIelts;
//   final String initialEnt;
//   final AppLocalizations l10n;
//   final void Function(String gpa, String ielts, String ent) onSave;

//   @override
//   State<_ScoresBottomSheet> createState() => _ScoresBottomSheetState();
// }

// class _ScoresBottomSheetState extends State<_ScoresBottomSheet> {
//   late final TextEditingController _gpaCtrl;
//   late final TextEditingController _ieltsCtrl;
//   late final TextEditingController _entCtrl;

//   @override
//   void initState() {
//     super.initState();
//     _gpaCtrl = TextEditingController(text: widget.initialGpa);
//     _ieltsCtrl = TextEditingController(text: widget.initialIelts);
//     _entCtrl = TextEditingController(text: widget.initialEnt);
//   }

//   @override
//   void dispose() {
//     _gpaCtrl.dispose();
//     _ieltsCtrl.dispose();
//     _entCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bottomInset = MediaQuery.of(context).viewInsets.bottom;

//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: isDark
//                     ? const Color(0xFF3A3A3C)
//                     : const Color(0xFFD1D1D6),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             widget.l10n.settingsEditScores,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: isDark ? Colors.white : AppColors.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 6),
//           const Text(
//             'Укажи баллы для подбора подходящих вузов',
//             style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
//           ),
//           const SizedBox(height: 24),
//           _ScoreSheetField(
//             controller: _gpaCtrl,
//             label: 'GPA',
//             hint: widget.l10n.dialogGpaPlaceholder,
//             color: AppColors.brandAccent,
//             isDark: isDark,
//             keyboardType:
//                 const TextInputType.numberWithOptions(decimal: true),
//             autofocus: true,
//           ),
//           const SizedBox(height: 12),
//           _ScoreSheetField(
//             controller: _ieltsCtrl,
//             label: 'IELTS',
//             hint: widget.l10n.dialogIeltsPlaceholder,
//             color: AppColors.brandPrimary,
//             isDark: isDark,
//             keyboardType:
//                 const TextInputType.numberWithOptions(decimal: true),
//           ),
//           const SizedBox(height: 12),
//           _ScoreSheetField(
//             controller: _entCtrl,
//             label: widget.l10n.profileScoresEnt,
//             hint: widget.l10n.dialogEntPlaceholder,
//             color: AppColors.warning,
//             isDark: isDark,
//             keyboardType: TextInputType.number,
//           ),
//           const SizedBox(height: 28),
//           SizedBox(
//             width: double.infinity,
//             height: 52,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 widget.onSave(
//                   _gpaCtrl.text.trim(),
//                   _ieltsCtrl.text.trim(),
//                   _entCtrl.text.trim(),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.brandAccent,
//                 foregroundColor: AppColors.backgroundDark,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16)),
//                 elevation: 0,
//               ),
//               child: Text(
//                 widget.l10n.actionSave,
//                 style: const TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.w600),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Поле ввода для профиля ───────────────────────────────────────────────────

// class _SheetField extends StatelessWidget {
//   const _SheetField({
//     required this.controller,
//     required this.label,
//     required this.icon,
//     required this.isDark,
//     this.autofocus = false,
//     this.keyboardType,
//   });

//   final TextEditingController controller;
//   final String label;
//   final IconData icon;
//   final bool isDark;
//   final bool autofocus;
//   final TextInputType? keyboardType;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: TextField(
//         controller: controller,
//         autofocus: autofocus,
//         keyboardType: keyboardType,
//         style: TextStyle(
//           fontSize: 16,
//           color: isDark ? Colors.white : AppColors.textPrimary,
//         ),
//         decoration: InputDecoration(
//           hintText: label,
//           hintStyle: const TextStyle(
//               color: AppColors.textSecondary, fontSize: 16),
//           prefixIcon:
//               Icon(icon, color: AppColors.textSecondary, size: 20),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16, vertical: 16),
//         ),
//       ),
//     );
//   }
// }

// // ─── Поле ввода для баллов ────────────────────────────────────────────────────

// class _ScoreSheetField extends StatelessWidget {
//   const _ScoreSheetField({
//     required this.controller,
//     required this.label,
//     required this.hint,
//     required this.color,
//     required this.isDark,
//     required this.keyboardType,
//     this.autofocus = false,
//   });

//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final Color color;
//   final bool isDark;
//   final TextInputType keyboardType;
//   final bool autofocus;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: color.withValues(alpha: 0.25)),
//       ),
//       child: TextField(
//         controller: controller,
//         autofocus: autofocus,
//         keyboardType: keyboardType,
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: isDark ? Colors.white : AppColors.textPrimary,
//         ),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: const TextStyle(
//               color: AppColors.textSecondary,
//               fontSize: 15,
//               fontWeight: FontWeight.w400),
//           prefixIcon: Container(
//             width: 56,
//             alignment: Alignment.center,
//             child: Text(
//               label,
//               style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700,
//                   color: color),
//             ),
//           ),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16, vertical: 16),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/router/route_names.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/news/university_news_repository.dart';
import '../../../data/onboarding/onboarding_repository.dart';
import '../../../data/profile/profile_repository_impl.dart';
import '../../../data/programs/university_program_repository.dart';
import '../../../data/university/university_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/university_cards_seed.dart';
import '../../../utils/university_seed_data.dart';
import '../bloc/profile_settings_cubit.dart';
import '../bloc/profile_settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileSettingsCubit(
        authRepository: context.read<AuthRepository>(),
        profileRepository: ProfileRepositoryImpl(FirebaseService.instance),
        onboardingRepository: context.read<OnboardingRepository>(),
        firebaseService: FirebaseService.instance,
      )..load(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  static const _interestEmojis = {
    'it': '💻',
    'medicine': '🩺',
    'business': '📊',
    'grants': '🎓',
    'design': '🎨',
    'law': '⚖️',
    'pedagogy': '📚',
    'engineering': '⚙️',
    'bachelor': '🏫',
    'college': '🏢',
    'master': '🎯',
  };

  String _profileSubtitle(ProfileSettingsState s, AppLocalizations l10n) {
    final parts = <String>[
      if (s.name.isNotEmpty) s.name,
      if (s.city.isNotEmpty) s.city,
    ];
    return parts.isEmpty ? l10n.settingsEmpty : parts.join(' · ');
  }

  String _scoresSubtitle(ProfileSettingsState s, AppLocalizations l10n) {
    final parts = <String>[
      if (s.gpa.isNotEmpty) 'GPA: ${s.gpa}',
      if (s.ielts.isNotEmpty) 'IELTS: ${s.ielts}',
      if (s.ent.isNotEmpty) 'ЕНТ: ${s.ent}',
    ];
    return parts.isEmpty ? l10n.settingsEmpty : parts.join(' · ');
  }

  String _interestsSubtitle(ProfileSettingsState s, AppLocalizations l10n) {
    if (s.interests.isEmpty) return l10n.settingsInterestsEmpty;
    return s.interests.take(5).map((k) => _interestEmojis[k] ?? k).join('  ');
  }

  String _languageLabel(BuildContext context, AppLocalizations l10n) {
    return switch (LocaleController.instance.locale.languageCode) {
      'kk' => l10n.languageKazakh,
      'en' => l10n.languageEnglish,
      _ => l10n.languageRussian,
    };
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;

    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) {
        return BlocConsumer<ProfileSettingsCubit, ProfileSettingsState>(
          listenWhen: (a, b) => a.status != b.status,
          listener: (context, state) {
            switch (state.status) {
              case ProfileSettingsStatus.saved:
                _showSnackBar(context, l10n.settingsSaved);
              case ProfileSettingsStatus.saveError:
                _showSnackBar(context, l10n.settingsSaveError);
              case ProfileSettingsStatus.photoError:
                _showSnackBar(context, l10n.settingsPhotoError);
              case ProfileSettingsStatus.signedOut:
                context.go(RouteNames.register);
              default:
                break;
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: bgColor,
              appBar: AppBar(
                backgroundColor: bgColor,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceMutedDark
                          : AppColors.backgroundLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      CupertinoIcons.back,
                      color: isDark
                          ? AppColors.textInverse
                          : AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
                title: Text(
                  l10n.settingsTitle,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textInverse
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                centerTitle: true,
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                children: [
                  // ── Профиль ────────────────────────────────────────────
                  _SettingsItem(
                    isDark: isDark,
                    icon: CupertinoIcons.person,
                    iconColor: AppColors.brandPrimary,
                    title: l10n.settingsEditProfile,
                    subtitle: _profileSubtitle(state, l10n),
                    onTap: () => _editProfile(context, state, l10n),
                  ),
                  const SizedBox(height: 10),

                  // ── Баллы ──────────────────────────────────────────────
                  _SettingsItem(
                    isDark: isDark,
                    icon: CupertinoIcons.star_fill,
                    iconColor: AppColors.warning,
                    title: l10n.settingsEditScores,
                    subtitle: _scoresSubtitle(state, l10n),
                    onTap: context
                            .read<ProfileSettingsCubit>()
                            .isAuthenticated
                        ? () => _editScores(context, state, l10n)
                        : () => _showAuthRequired(context, l10n),
                  ),
                  const SizedBox(height: 10),

                  // ── Интересы ───────────────────────────────────────────
                  _SettingsItem(
                    isDark: isDark,
                    icon: CupertinoIcons.doc_checkmark,
                    iconColor: AppColors.warning,
                    title: l10n.settingsQuiz,
                    subtitle: _interestsSubtitle(state, l10n),
                    onTap: () async {
                      await context.push(RouteNames.onboarding);
                      if (context.mounted) {
                        await context
                            .read<ProfileSettingsCubit>()
                            .reloadInterests();
                      }
                    },
                  ),
                  const SizedBox(height: 10),

                  // ── Язык ───────────────────────────────────────────────
                  _SettingsItem(
                    isDark: isDark,
                    icon: CupertinoIcons.globe,
                    iconColor: AppColors.success,
                    title: l10n.settingsLanguageItem,
                    subtitle: _languageLabel(context, l10n),
                    onTap: () => _pickLanguage(context, l10n),
                  ),
                  const SizedBox(height: 10),

                  // ── Тема ───────────────────────────────────────────────
                  _SettingsItemWithToggle(
                    isDark: isDark,
                    icon: CupertinoIcons.moon_fill,
                    iconColor: const Color(0xFF7C3AED),
                    title: l10n.settingsThemeItem,
                    value: ThemeController.instance.isDark,
                    onChanged: (v) => ThemeController.instance.setDark(v),
                  ),
                  const SizedBox(height: 10),

                  // ── Поддержка ──────────────────────────────────────────
                  _SettingsItem(
                    isDark: isDark,
                    icon: CupertinoIcons.question_circle,
                    iconColor: AppColors.brandAccent,
                    title: l10n.settingsHelpItem,
                    subtitle: l10n.settingsHelpSubtitle,
                    onTap: () => context.push(RouteNames.support),
                  ),
                  const SizedBox(height: 10),

                  // ── Загрузить данные в Firebase (временная кнопка) ─────
                  _SeedButton(isDark: isDark),
                  const SizedBox(height: 32),

                  // ── Выход ──────────────────────────────────────────────
                  _DangerButton(
                    isDark: isDark,
                    icon: CupertinoIcons.square_arrow_left,
                    label: l10n.settingsLogoutItem,
                    onTap: () => _confirmSignOut(context, l10n),
                  ),
                  const SizedBox(height: 12),

                  // ── Удалить аккаунт ────────────────────────────────────
                  _DangerButton(
                    isDark: isDark,
                    icon: CupertinoIcons.trash,
                    label: l10n.settingsDeleteAccount,
                    onTap: () => _confirmDeleteAccount(context, l10n),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _editProfile(
    BuildContext context,
    ProfileSettingsState state,
    AppLocalizations l10n,
  ) {
    final cubit = context.read<ProfileSettingsCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ProfileBottomSheet(
        initialName: state.name,
        initialCity: state.city,
        l10n: l10n,
        onSave: (name, city) => cubit.updateProfile(name: name, city: city),
      ),
    );
  }

  void _editScores(
    BuildContext context,
    ProfileSettingsState state,
    AppLocalizations l10n,
  ) {
    final cubit = context.read<ProfileSettingsCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ScoresBottomSheet(
        initialGpa: state.gpa,
        initialIelts: state.ielts,
        initialEnt: state.ent,
        l10n: l10n,
        onSave: (gpa, ielts, ent) =>
            cubit.updateScores(gpa: gpa, ielts: ielts, ent: ent),
      ),
    );
  }

  void _showAuthRequired(BuildContext context, AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(l10n.settingsAuthTitle),
        content: Text(l10n.settingsAuthText),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.actionOk),
          ),
        ],
      ),
    );
  }

  void _pickLanguage(BuildContext context, AppLocalizations l10n) {
    showCupertinoModalPopup(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(l10n.chooseLanguage),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              LocaleController.instance.setLocale(const Locale('ru'));
              Navigator.pop(sheetContext);
            },
            child: Text(l10n.languageRussian),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              LocaleController.instance.setLocale(const Locale('kk'));
              Navigator.pop(sheetContext);
            },
            child: Text(l10n.languageKazakh),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              LocaleController.instance.setLocale(const Locale('en'));
              Navigator.pop(sheetContext);
            },
            child: Text(l10n.languageEnglish),
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

  void _confirmSignOut(BuildContext context, AppLocalizations l10n) {
    final cubit = context.read<ProfileSettingsCubit>();
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(l10n.settingsLogoutConfirmTitle),
        content: Text(l10n.settingsLogoutConfirmText),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.actionCancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.signOut();
            },
            child: Text(l10n.actionExit),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, AppLocalizations l10n) {
    final cubit = context.read<ProfileSettingsCubit>();
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(l10n.settingsDeleteAccountConfirmTitle),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(l10n.settingsDeleteAccountConfirmBody),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.settingsDeleteAccountCancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(dialogContext);
              await cubit.deleteAccount();
              if (context.mounted) {
                context.go(RouteNames.welcome);
              }
            },
            child: Text(l10n.settingsDeleteAccountConfirm),
          ),
        ],
      ),
    );
  }
}

// ─── Кнопка загрузки данных в Firebase ───────────────────────────────────────

class _SeedButton extends StatefulWidget {
  const _SeedButton({required this.isDark});
  final bool isDark;

  @override
  State<_SeedButton> createState() => _SeedButtonState();
}

class _SeedButtonState extends State<_SeedButton> {
  bool _loading = false;
  String _status = '';

  Future<void> _runSeed() async {
    setState(() {
      _loading = true;
      _status = 'Загрузка...';
    });

    try {
      final programRepo = context.read<UniversityProgramRepository>();
      final newsRepo = context.read<UniversityNewsRepository>();
      final universityRepo = context.read<UniversityRepository>();

      int programCount = 0;
      int newsCount = 0;
      int cardCount = 0;

      for (final entry in kSeedPrograms.entries) {
        await programRepo.seedPrograms(entry.key, entry.value);
        programCount += entry.value.length;
        if (mounted) {
          setState(() => _status = 'Загружаю ${entry.key}...');
        }
      }

      for (final entry in kSeedNews.entries) {
        await newsRepo.seedNews(entry.key, entry.value);
        newsCount += entry.value.length;
      }

      // ── Переводы карточек университетов (name/city/description/languages) ──
      for (final entry in kUniversityCardTranslations.entries) {
        await universityRepo.patchMissingFields(entry.key, entry.value);
        cardCount++;
        if (mounted) {
          setState(() => _status = 'Перевожу карточку ${entry.key}...');
        }
      }

      if (mounted) {
        setState(() {
          _status =
              '✅ $programCount программ, $newsCount новостей, $cardCount карточек переведено!';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _status = '❌ Ошибка: $e');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    const accent = AppColors.brandAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.12 : 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accent.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  color: accent,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔧 Загрузить данные в Firebase',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? accent
                            : AppColors.brandPrimary,
                      ),
                    ),
                    const Text(
                      'Программы и новости всех вузов',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (_loading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isDark ? accent : AppColors.brandPrimary,
                  ),
                )
              else
                GestureDetector(
                  onTap: _runSeed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Запустить',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (_status.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              _status,
              style: TextStyle(
                fontSize: 12,
                color: _status.startsWith('✅')
                    ? AppColors.success
                    : _status.startsWith('❌')
                        ? AppColors.danger
                        : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Кнопка-секция настроек ───────────────────────────────────────────────────

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceMutedDark
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textInverse
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Переключатель темы ───────────────────────────────────────────────────────

class _SettingsItemWithToggle extends StatelessWidget {
  const _SettingsItemWithToggle({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceMutedDark
            : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textInverse : AppColors.textPrimary,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.brandAccent,
          ),
        ],
      ),
    );
  }
}

// ─── Кнопка опасного действия (выход / удалить) ───────────────────────────────

class _DangerButton extends StatelessWidget {
  const _DangerButton({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool isDark;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.surfaceMutedDark
              : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.danger.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.danger, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.danger,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// ─── Bottom Sheet: Редактирование профиля ─────────────────────────────────────

class _ProfileBottomSheet extends StatefulWidget {
  const _ProfileBottomSheet({
    required this.initialName,
    required this.initialCity,
    required this.l10n,
    required this.onSave,
  });

  final String initialName;
  final String initialCity;
  final AppLocalizations l10n;
  final void Function(String name, String city) onSave;

  @override
  State<_ProfileBottomSheet> createState() => _ProfileBottomSheetState();
}

class _ProfileBottomSheetState extends State<_ProfileBottomSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _cityCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _cityCtrl = TextEditingController(text: widget.initialCity);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF3A3A3C)
                    : const Color(0xFFD1D1D6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.l10n.settingsEditProfile,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _SheetField(
            controller: _nameCtrl,
            label: widget.l10n.dialogNamePlaceholder,
            icon: CupertinoIcons.person,
            isDark: isDark,
            autofocus: true,
          ),
          const SizedBox(height: 12),
          _SheetField(
            controller: _cityCtrl,
            label: widget.l10n.dialogCityPlaceholder,
            icon: CupertinoIcons.location,
            isDark: isDark,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onSave(
                  _nameCtrl.text.trim(),
                  _cityCtrl.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                widget.l10n.actionSave,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Sheet: Редактирование баллов ──────────────────────────────────────

class _ScoresBottomSheet extends StatefulWidget {
  const _ScoresBottomSheet({
    required this.initialGpa,
    required this.initialIelts,
    required this.initialEnt,
    required this.l10n,
    required this.onSave,
  });

  final String initialGpa;
  final String initialIelts;
  final String initialEnt;
  final AppLocalizations l10n;
  final void Function(String gpa, String ielts, String ent) onSave;

  @override
  State<_ScoresBottomSheet> createState() => _ScoresBottomSheetState();
}

class _ScoresBottomSheetState extends State<_ScoresBottomSheet> {
  late final TextEditingController _gpaCtrl;
  late final TextEditingController _ieltsCtrl;
  late final TextEditingController _entCtrl;

  @override
  void initState() {
    super.initState();
    _gpaCtrl = TextEditingController(text: widget.initialGpa);
    _ieltsCtrl = TextEditingController(text: widget.initialIelts);
    _entCtrl = TextEditingController(text: widget.initialEnt);
  }

  @override
  void dispose() {
    _gpaCtrl.dispose();
    _ieltsCtrl.dispose();
    _entCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF3A3A3C)
                    : const Color(0xFFD1D1D6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.l10n.settingsEditScores,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Укажи баллы для подбора подходящих вузов',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          _ScoreSheetField(
            controller: _gpaCtrl,
            label: 'GPA',
            hint: widget.l10n.dialogGpaPlaceholder,
            color: AppColors.brandAccent,
            isDark: isDark,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
          ),
          const SizedBox(height: 12),
          _ScoreSheetField(
            controller: _ieltsCtrl,
            label: 'IELTS',
            hint: widget.l10n.dialogIeltsPlaceholder,
            color: AppColors.brandPrimary,
            isDark: isDark,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          _ScoreSheetField(
            controller: _entCtrl,
            label: widget.l10n.profileScoresEnt,
            hint: widget.l10n.dialogEntPlaceholder,
            color: AppColors.warning,
            isDark: isDark,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onSave(
                  _gpaCtrl.text.trim(),
                  _ieltsCtrl.text.trim(),
                  _entCtrl.text.trim(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandAccent,
                foregroundColor: AppColors.backgroundDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: Text(
                widget.l10n.actionSave,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Поле ввода для профиля ───────────────────────────────────────────────────

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    this.autofocus = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isDark;
  final bool autofocus;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(
              color: AppColors.textSecondary, fontSize: 16),
          prefixIcon:
              Icon(icon, color: AppColors.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

// ─── Поле ввода для баллов ────────────────────────────────────────────────────

class _ScoreSheetField extends StatelessWidget {
  const _ScoreSheetField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.color,
    required this.isDark,
    required this.keyboardType,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final Color color;
  final bool isDark;
  final TextInputType keyboardType;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w400),
          prefixIcon: Container(
            width: 56,
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}