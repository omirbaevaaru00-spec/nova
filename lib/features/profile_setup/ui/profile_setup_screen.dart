// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../../../core/router/route_names.dart';
// import '../../../core/services/firebase_service.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/widgets/auth_error_mapper.dart';
// import '../../../core/widgets/auth_input_field.dart';
// import '../../../core/widgets/primary_button.dart';
// import '../../../data/auth/auth_repository.dart';
// import '../../../data/onboarding/onboarding_repository.dart';
// import '../../../data/profile/profile_repository_impl.dart';
// import '../../../l10n/generated/app_localizations.dart';
// import '../bloc/profile_setup_cubit.dart';
// import '../bloc/profile_setup_state.dart';

// class ProfileSetupScreen extends StatelessWidget {
//   const ProfileSetupScreen({super.key, this.email, this.phone});

//   final String? email;
//   final String? phone;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ProfileSetupCubit(
//         authRepository: context.read<AuthRepository>(),
//         profileRepository: ProfileRepositoryImpl(FirebaseService.instance),
//         onboardingRepository: context.read<OnboardingRepository>(),
//         email: email,
//         phone: phone,
//       ),
//       child: const _ProfileSetupView(),
//     );
//   }
// }

// class _ProfileSetupView extends StatefulWidget {
//   const _ProfileSetupView();

//   @override
//   State<_ProfileSetupView> createState() => _ProfileSetupViewState();
// }

// class _ProfileSetupViewState extends State<_ProfileSetupView> {
//   final _nameController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _nameFocus = FocusNode();
//   final _cityFocus = FocusNode();
//   final _passwordFocus = FocusNode();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _cityController.dispose();
//     _passwordController.dispose();
//     _nameFocus.dispose();
//     _cityFocus.dispose();
//     _passwordFocus.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle.dark,
//       child: Scaffold(
//         backgroundColor: AppColors.surfaceMuted,
//         body: SafeArea(
//           child: GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
//               listenWhen: (a, b) => a.status != b.status,
//               listener: (context, state) {
//                 if (state.status == ProfileSetupStatus.success) {
//                   context.go(RouteNames.home);
//                 }
//               },
//               builder: (context, state) {
//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () =>
//                                 context.canPop() ? context.pop() : null,
//                             child: const Icon(
//                               Icons.arrow_back_rounded,
//                               color: AppColors.authPrimaryLight,
//                               size: 24,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 32),
//                       Container(
//                         width: 80,
//                         height: 80,
//                         decoration: const BoxDecoration(
//                           color: AppColors.divider,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.person_rounded,
//                           color: AppColors.authPrimaryLight,
//                           size: 44,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Text(
//                         l10n.profileSetupTitle,
//                         style: const TextStyle(
//                           color: AppColors.authPrimary,
//                           fontSize: 26,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         l10n.profileSetupSubtitle,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: AppColors.textPrimary.withValues(alpha: 0.45),
//                           fontSize: 15,
//                           height: 1.4,
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                       _Label(text: l10n.profileSetupNameLabel),
//                       const SizedBox(height: 8),
//                       AuthInputField(
//                         controller: _nameController,
//                         focusNode: _nameFocus,
//                         hint: l10n.profileSetupNameHint,
//                         onChanged: context.read<ProfileSetupCubit>().nameChanged,
//                         onSubmitted: (_) => _cityFocus.requestFocus(),
//                       ),
//                       const SizedBox(height: 20),
//                       _Label(text: l10n.profileSetupCityLabel),
//                       const SizedBox(height: 8),
//                       AuthInputField(
//                         controller: _cityController,
//                         focusNode: _cityFocus,
//                         hint: l10n.profileSetupCityHint,
//                         textInputAction: state.isEmailFlow
//                             ? TextInputAction.next
//                             : TextInputAction.done,
//                         onChanged: context.read<ProfileSetupCubit>().cityChanged,
//                         onSubmitted: (_) {
//                           if (state.isEmailFlow) {
//                             _passwordFocus.requestFocus();
//                           } else {
//                             context.read<ProfileSetupCubit>().submit();
//                           }
//                         },
//                       ),
//                       if (state.isEmailFlow) ...[
//                         const SizedBox(height: 20),
//                         _Label(text: l10n.profileSetupPasswordLabel),
//                         const SizedBox(height: 8),
//                         AuthInputField(
//                           controller: _passwordController,
//                           focusNode: _passwordFocus,
//                           hint: l10n.profileSetupPasswordHint,
//                           obscureText: _obscurePassword,
//                           textInputAction: TextInputAction.done,
//                           onChanged: context
//                               .read<ProfileSetupCubit>()
//                               .passwordChanged,
//                           onSubmitted: (_) =>
//                               context.read<ProfileSetupCubit>().submit(),
//                           suffix: GestureDetector(
//                             onTap: () => setState(
//                               () => _obscurePassword = !_obscurePassword,
//                             ),
//                             child: Icon(
//                               _obscurePassword
//                                   ? Icons.visibility_off_outlined
//                                   : Icons.visibility_outlined,
//                               color: AppColors.authHint,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             l10n.profileSetupPasswordHint,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: AppColors.textPrimary
//                                   .withValues(alpha: 0.4),
//                             ),
//                           ),
//                         ),
//                       ],
//                       if (state.failure != null) ...[
//                         const SizedBox(height: 12),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             localizeAuthFailure(state.failure!, l10n),
//                             style: const TextStyle(
//                               color: AppColors.danger,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ),
//                       ],
//                       const SizedBox(height: 40),
//                       PrimaryButton(
//                         label: l10n.profileSetupContinue,
//                         loading:
//                             state.status == ProfileSetupStatus.loading,
//                         enabled: state.canContinue,
//                         onTap: () =>
//                             context.read<ProfileSetupCubit>().submit(),
//                       ),
//                       const SizedBox(height: 32),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// }

// class _Label extends StatelessWidget {
//   const _Label({required this.text});

//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         text,
//         style: const TextStyle(
//           color: AppColors.authPrimary,
//           fontSize: 14,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/auth_error_mapper.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/onboarding/onboarding_repository.dart';
import '../../../data/profile/profile_repository_impl.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/profile_setup_cubit.dart';
import '../bloc/profile_setup_state.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key, this.email, this.phone});

  final String? email;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileSetupCubit(
        authRepository: context.read<AuthRepository>(),
        profileRepository: ProfileRepositoryImpl(FirebaseService.instance),
        onboardingRepository: context.read<OnboardingRepository>(),
        email: email,
        phone: phone,
      ),
      child: const _ProfileSetupView(),
    );
  }
}

class _ProfileSetupView extends StatefulWidget {
  const _ProfileSetupView();

  @override
  State<_ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<_ProfileSetupView> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _cityFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _nameFocused = false;
  bool _cityFocused = false;
  bool _passwordFocused = false;

  bool _nameTouched = false;
  bool _cityTouched = false;
  bool _passwordTouched = false;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(
        () => setState(() => _nameFocused = _nameFocus.hasFocus));
    _cityFocus.addListener(
        () => setState(() => _cityFocused = _cityFocus.hasFocus));
    _passwordFocus.addListener(
        () => setState(() => _passwordFocused = _passwordFocus.hasFocus));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _cityFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  String? _nameError() {
    if (!_nameTouched) return null;
    if (_nameController.text.trim().isEmpty) return 'Введите имя';
    if (_nameController.text.trim().length < 2) return 'Минимум 2 символа';
    return null;
  }

  String? _cityError() {
    if (!_cityTouched) return null;
    if (_cityController.text.trim().isEmpty) return 'Введите город';
    if (_cityController.text.trim().length < 2) return 'Минимум 2 символа';
    return null;
  }

  String? _passwordError() {
    if (!_passwordTouched) return null;
    if (_passwordController.text.isEmpty) return 'Введите пароль';
    if (_passwordController.text.length < 6) return 'Минимум 6 символов';
    return null;
  }

  bool _isFormValid(ProfileSetupState state) {
    final nameOk = _nameController.text.trim().length >= 2;
    final cityOk = _cityController.text.trim().length >= 2;
    final passwordOk =
        !state.isEmailFlow || _passwordController.text.length >= 6;
    return nameOk && cityOk && passwordOk;
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.register);
    }
  }

  void _submit(BuildContext context, ProfileSetupState state) {
    setState(() {
      _nameTouched = true;
      _cityTouched = true;
      if (state.isEmailFlow) _passwordTouched = true;
    });
    if (!_isFormValid(state)) return;
    HapticFeedback.lightImpact();
    context.read<ProfileSetupCubit>().submit();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: BlocConsumer<ProfileSetupCubit, ProfileSetupState>(
              listenWhen: (a, b) => a.status != b.status,
              listener: (context, state) {
                if (state.status == ProfileSetupStatus.success) {
                  context.go(RouteNames.home);
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ── Назад ─────────────────────────────────────────
                      GestureDetector(
                        onTap: () => _handleBack(context),
                        child: _CircleIconButton(isDark: isDark),
                      ),
                      const SizedBox(height: 32),

                      // ── Иконка ────────────────────────────────────────
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E2025)
                                : AppColors.divider,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF3A3D44)
                                  : AppColors.border,
                            ),
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: isDark
                                ? AppColors.brandAccent
                                : AppColors.authPrimaryLight,
                            size: 44,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Заголовок ─────────────────────────────────────
                      Center(
                        child: Text(
                          l10n.profileSetupTitle,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.brandAccent
                                : AppColors.brandPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          l10n.profileSetupSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // ── Имя ───────────────────────────────────────────
                      _FieldLabel(
                          text: l10n.profileSetupNameLabel, isDark: isDark),
                      const SizedBox(height: 8),
                      _SetupField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        isDark: isDark,
                        isFocused: _nameFocused,
                        hasError: _nameError() != null,
                        hint: l10n.profileSetupNameHint,
                        prefixIcon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        onChanged: (v) {
                          setState(() => _nameTouched = true);
                          context.read<ProfileSetupCubit>().nameChanged(v);
                        },
                        onSubmitted: (_) => _cityFocus.requestFocus(),
                      ),
                      _FieldError(error: _nameError()),
                      const SizedBox(height: 16),

                      // ── Город ─────────────────────────────────────────
                      _FieldLabel(
                          text: l10n.profileSetupCityLabel, isDark: isDark),
                      const SizedBox(height: 8),
                      _SetupField(
                        controller: _cityController,
                        focusNode: _cityFocus,
                        isDark: isDark,
                        isFocused: _cityFocused,
                        hasError: _cityError() != null,
                        hint: l10n.profileSetupCityHint,
                        prefixIcon: Icons.location_on_outlined,
                        textInputAction: state.isEmailFlow
                            ? TextInputAction.next
                            : TextInputAction.done,
                        onChanged: (v) {
                          setState(() => _cityTouched = true);
                          context.read<ProfileSetupCubit>().cityChanged(v);
                        },
                        onSubmitted: (_) {
                          if (state.isEmailFlow) {
                            _passwordFocus.requestFocus();
                          } else {
                            _submit(context, state);
                          }
                        },
                      ),
                      _FieldError(error: _cityError()),

                      // ── Пароль ────────────────────────────────────────
                      if (state.isEmailFlow) ...[
                        const SizedBox(height: 16),
                        _FieldLabel(
                            text: l10n.profileSetupPasswordLabel,
                            isDark: isDark),
                        const SizedBox(height: 8),
                        _SetupField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          isDark: isDark,
                          isFocused: _passwordFocused,
                          hasError: _passwordError() != null,
                          hint: l10n.profileSetupPasswordHint,
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onChanged: (v) {
                            setState(() => _passwordTouched = true);
                            context
                                .read<ProfileSetupCubit>()
                                .passwordChanged(v);
                          },
                          onSubmitted: (_) => _submit(context, state),
                          suffix: GestureDetector(
                            onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: isDark
                                    ? const Color(0xFF6B7280)
                                    : AppColors.textMuted,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        _FieldError(error: _passwordError()),
                      ],

                      // ── Ошибка сервера ────────────────────────────────
                      if (state.failure != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  AppColors.danger.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  size: 16, color: AppColors.danger),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  localizeAuthFailure(state.failure!, l10n),
                                  style: const TextStyle(
                                    color: AppColors.danger,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 36),

                      // ── Кнопка продолжить ─────────────────────────────
                      PrimaryButton(
                        label: l10n.profileSetupContinue,
                        loading:
                            state.status == ProfileSetupStatus.loading,
                        enabled: state.canContinue && _isFormValid(state),
                        onTap: () => _submit(context, state),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Переиспользуемые компоненты ──────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text, required this.isDark});
  final String text;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: isDark ? AppColors.textInverse : AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }
}

class _FieldError extends StatelessWidget {
  const _FieldError({required this.error});
  final String? error;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: error != null
          ? Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      size: 14, color: AppColors.danger),
                  const SizedBox(width: 5),
                  Text(
                    error!,
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _SetupField extends StatelessWidget {
  const _SetupField({
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.isFocused,
    required this.hasError,
    required this.hint,
    required this.prefixIcon,
    required this.onChanged,
    required this.onSubmitted,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.suffix,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final bool isFocused;
  final bool hasError;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final Widget? suffix;

  Color get _borderColor {
    if (hasError) return AppColors.danger;
    if (isFocused) return AppColors.brandAccent;
    return isDark ? const Color(0xFF3A3D44) : AppColors.border;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2025) : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _borderColor,
          width: isFocused || hasError ? 2 : 1.5,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: (hasError ? AppColors.danger : AppColors.brandAccent)
                      .withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: Icon(
              prefixIcon,
              color: isFocused
                  ? AppColors.brandAccent
                  : (isDark ? const Color(0xFF6B7280) : AppColors.textMuted),
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              textInputAction: textInputAction,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimary,
                fontSize: 16,
              ),
              cursorColor: AppColors.brandAccent,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: isDark
                      ? const Color(0xFF6B7280)
                      : AppColors.textMuted,
                  fontSize: 15,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 18,
                ),
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2025) : AppColors.backgroundLight,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? const Color(0xFF3A3D44) : AppColors.border,
        ),
      ),
      child: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 18,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }
}