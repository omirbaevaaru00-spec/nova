import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stiky/features/profile_settings/bloc/profile_settings_cubit.dart';
import 'package:stiky/features/profile_settings/bloc/profile_settings_state.dart';

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
import '../../../l10n/generated/app_localizations.dart';
import '../../../utils/university_seed_data.dart';



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
    final nameCtrl = TextEditingController(text: state.name);
    final cityCtrl = TextEditingController(text: state.city);
    final cubit = context.read<ProfileSettingsCubit>();

    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(l10n.settingsEditProfile),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              CupertinoTextField(
                controller: nameCtrl,
                placeholder: l10n.dialogNamePlaceholder,
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: cityCtrl,
                placeholder: l10n.dialogCityPlaceholder,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.actionCancel),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.updateProfile(
                name: nameCtrl.text.trim(),
                city: cityCtrl.text.trim(),
              );
            },
            child: Text(l10n.actionSave),
          ),
        ],
      ),
    );
  }

  void _editScores(
    BuildContext context,
    ProfileSettingsState state,
    AppLocalizations l10n,
  ) {
    final gpaCtrl = TextEditingController(text: state.gpa);
    final ieltsCtrl = TextEditingController(text: state.ielts);
    final entCtrl = TextEditingController(text: state.ent);
    final cubit = context.read<ProfileSettingsCubit>();

    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(l10n.settingsEditScores),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              CupertinoTextField(
                controller: gpaCtrl,
                placeholder: l10n.dialogGpaPlaceholder,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: ieltsCtrl,
                placeholder: l10n.dialogIeltsPlaceholder,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: entCtrl,
                placeholder: l10n.dialogEntPlaceholder,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.actionCancel),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.updateScores(
                gpa: gpaCtrl.text.trim(),
                ielts: ieltsCtrl.text.trim(),
                ent: entCtrl.text.trim(),
              );
            },
            child: Text(l10n.actionSave),
          ),
        ],
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

      int programCount = 0;
      int newsCount = 0;

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

      if (mounted) {
        setState(() {
          _status = '✅ $programCount программ и $newsCount новостей загружено!';
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A2A1A)
            : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
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
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  color: Color(0xFF4CAF50),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🔧 Загрузить данные в Firebase',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    Text(
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
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF4CAF50),
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
                      color: const Color(0xFF4CAF50),
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
                    ? const Color(0xFF4CAF50)
                    : _status.startsWith('❌')
                        ? Colors.red
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