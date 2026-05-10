import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/router/route_names.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/onboarding/onboarding_repository.dart';
import '../../../data/profile/profile_repository_impl.dart';
import '../../../l10n/generated/app_localizations.dart';
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
    return s.interests
        .take(5)
        .map((k) => _interestEmojis[k] ?? k)
        .join('  ');
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
              backgroundColor: AppColors.surfaceMuted,
              appBar: AppBar(
                backgroundColor: AppColors.surfaceMuted,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.back,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
                title: Text(
                  l10n.settingsTitle,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                centerTitle: true,
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                children: [
                  _SettingsItem(
                    icon: CupertinoIcons.person,
                    iconColor: AppColors.brandPrimary,
                    title: l10n.settingsEditProfile,
                    subtitle: _profileSubtitle(state, l10n),
                    onTap: () => _editProfile(context, state, l10n),
                  ),
                  const SizedBox(height: 10),
                  _SettingsItem(
                    icon: CupertinoIcons.star_fill,
                    iconColor: const Color(0xFFFF9500),
                    title: l10n.settingsEditScores,
                    subtitle: _scoresSubtitle(state, l10n),
                    onTap: context.read<ProfileSettingsCubit>().isAuthenticated
                        ? () => _editScores(context, state, l10n)
                        : () => _showAuthRequired(context, l10n),
                  ),
                  const SizedBox(height: 10),
                  _SettingsItem(
                    icon: CupertinoIcons.doc_checkmark,
                    iconColor: const Color(0xFFFF9500),
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
                  _SettingsItem(
                    icon: CupertinoIcons.globe,
                    iconColor: AppColors.success,
                    title: l10n.settingsLanguageItem,
                    subtitle: _languageLabel(context, l10n),
                    onTap: () => _pickLanguage(context, l10n),
                  ),
                  const SizedBox(height: 10),
                  _SettingsItemWithToggle(
                    icon: CupertinoIcons.moon_fill,
                    iconColor: AppColors.warning,
                    title: l10n.settingsThemeItem,
                    value: ThemeController.instance.isDark,
                    onChanged: (v) => ThemeController.instance.setDark(v),
                  ),
                  const SizedBox(height: 10),
                  if (state.status == ProfileSettingsStatus.uploadingPhoto)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  else
                    _SettingsItem(
                      icon: CupertinoIcons.camera,
                      iconColor: AppColors.info,
                      title: l10n.settingsPhotoItem,
                      subtitle: l10n.settingsPhotoSubtitle,
                      onTap: () => _pickPhotoSource(context, l10n),
                    ),
                  const SizedBox(height: 10),
                  _SettingsItem(
                    icon: CupertinoIcons.question_circle,
                    iconColor: AppColors.textSecondary,
                    title: l10n.settingsHelpItem,
                    subtitle: l10n.settingsHelpSubtitle,
                    onTap: () => context.push(RouteNames.helpCenter),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () => _confirmSignOut(context, l10n),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.danger.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.square_arrow_left,
                            color: AppColors.danger,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.settingsLogoutItem,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.danger,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  void _pickPhotoSource(BuildContext context, AppLocalizations l10n) {
    final cubit = context.read<ProfileSettingsCubit>();
    showCupertinoModalPopup(
      context: context,
      builder: (sheetContext) => CupertinoActionSheet(
        title: Text(l10n.profilePhotoTitle),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(sheetContext);
              await _pickAndUpload(cubit, ImageSource.camera);
            },
            child: Text(l10n.profilePhotoTake),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(sheetContext);
              await _pickAndUpload(cubit, ImageSource.gallery);
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

  Future<void> _pickAndUpload(
    ProfileSettingsCubit cubit,
    ImageSource source,
  ) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked == null) return;
    await cubit.uploadAvatar(picked.path);
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
}

class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

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
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
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
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
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
            const Icon(
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

class _SettingsItemWithToggle extends StatelessWidget {
  const _SettingsItemWithToggle({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
  });

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
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
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
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
