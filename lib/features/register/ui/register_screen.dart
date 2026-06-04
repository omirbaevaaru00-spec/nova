// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../../../core/router/route_names.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/widgets/auth_error_mapper.dart';
// import '../../../core/widgets/google_sign_in_button.dart';
// import '../../../core/widgets/primary_button.dart';
// import '../../../data/auth/auth_repository.dart';
// import '../../../l10n/generated/app_localizations.dart';
// import '../bloc/register_cubit.dart';
// import '../bloc/register_state.dart';

// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           RegisterCubit(authRepository: context.read<AuthRepository>()),
//       child: const _RegisterView(),
//     );
//   }
// }

// class _RegisterView extends StatefulWidget {
//   const _RegisterView();

//   @override
//   State<_RegisterView> createState() => _RegisterViewState();
// }

// class _RegisterViewState extends State<_RegisterView> {
//   final _phoneController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneFocus = FocusNode();
//   final _emailFocus = FocusNode();

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _emailController.dispose();
//     _phoneFocus.dispose();
//     _emailFocus.dispose();
//     super.dispose();
//   }

//   void _handleStateChange(BuildContext context, RegisterState state) {
//     switch (state.status) {
//       case RegisterStatus.smsSent:
//         if (state.verificationId == null) return;
//         context.push(
//           RouteNames.phoneOtp,
//           extra: {
//             'phone': state.fullPhone,
//             'verificationId': state.verificationId,
//           },
//         );
//       case RegisterStatus.needsProfileSetup:
//         context.go(
//           RouteNames.profileSetup,
//           extra: state.mode == RegisterMode.email
//               ? {'email': state.currentInput}
//               : null,
//         );
//       case RegisterStatus.needsLogin:
//         context.push(
//           RouteNames.login,
//           extra: {'email': state.currentInput},
//         );
//       case RegisterStatus.authenticated:
//         context.go(RouteNames.home);
//       case RegisterStatus.idle:
//       case RegisterStatus.loading:
//       case RegisterStatus.failure:
//         break;
//     }
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
//             child: BlocConsumer<RegisterCubit, RegisterState>(
//               listenWhen: (a, b) => a.status != b.status,
//               listener: _handleStateChange,
//               builder: (context, state) {
//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 16),
//                       _BackButton(),
//                       const SizedBox(height: 20),
//                       Image.asset('assets/images/sticky_logo.png', height: 48),
//                       const SizedBox(height: 28),
//                       Text(
//                         l10n.registerTitle,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: AppColors.authPrimary,
//                           fontSize: 22,
//                           fontWeight: FontWeight.w800,
//                           height: 1.2,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                       const SizedBox(height: 28),
//                       _ModeToggle(
//                         mode: state.mode,
//                         onChanged: (m) {
//                           HapticFeedback.selectionClick();
//                           context.read<RegisterCubit>().setMode(m);
//                           (m == RegisterMode.phone
//                                   ? _phoneFocus
//                                   : _emailFocus)
//                               .requestFocus();
//                         },
//                       ),
//                       const SizedBox(height: 24),
//                       AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 220),
//                         child: state.mode == RegisterMode.phone
//                             ? _PhoneField(
//                                 key: const ValueKey('phone'),
//                                 controller: _phoneController,
//                                 focusNode: _phoneFocus,
//                                 onChanged: context
//                                     .read<RegisterCubit>()
//                                     .phoneChanged,
//                                 onSubmitted: (_) =>
//                                     context.read<RegisterCubit>().proceed(),
//                               )
//                             : _EmailField(
//                                 key: const ValueKey('email'),
//                                 controller: _emailController,
//                                 focusNode: _emailFocus,
//                                 onChanged: context
//                                     .read<RegisterCubit>()
//                                     .emailChanged,
//                                 onSubmitted: (_) =>
//                                     context.read<RegisterCubit>().proceed(),
//                               ),
//                       ),
//                       if (state.failure != null) ...[
//                         const SizedBox(height: 10),
//                         Text(
//                           localizeAuthFailure(state.failure!, l10n),
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: AppColors.danger,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ],
//                       const SizedBox(height: 14),
//                       Text(
//                         l10n.registerPolicy,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: AppColors.authPrimaryLight,
//                           fontSize: 13,
//                           decoration: TextDecoration.underline,
//                           decorationColor: AppColors.authPrimaryLight,
//                         ),
//                       ),
//                       const SizedBox(height: 28),
//                       PrimaryButton(
//                         label: l10n.registerProceed,
//                         loading: state.status == RegisterStatus.loading,
//                         enabled: state.canProceed,
//                         onTap: () =>
//                             context.read<RegisterCubit>().proceed(),
//                       ),
//                       const SizedBox(height: 16),
//                       _OrDivider(label: l10n.orDivider),
//                       const SizedBox(height: 16),
//                       GoogleSignInButton(
//                         label: l10n.googleContinue,
//                         loading: state.status == RegisterStatus.loading,
//                         onTap: () async {
//                           await context
//                               .read<RegisterCubit>()
//                               .signInWithGoogle();
//                         },
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             l10n.registerHasAccountPrefix,
//                             style: TextStyle(
//                               color: AppColors.textPrimary
//                                   .withValues(alpha: 0.45),
//                               fontSize: 14,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => context.go(RouteNames.login),
//                             child: Text(
//                               l10n.registerLoginAction,
//                               style: const TextStyle(
//                                 color: AppColors.authPrimaryLight,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w700,
//                               ),
//                             ),
//                           ),
//                         ],
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

// class _BackButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () => context.canPop()
//               ? context.pop()
//               : context.go(RouteNames.welcome),
//           child: const Icon(
//             Icons.arrow_back_rounded,
//             color: AppColors.authPrimaryLight,
//             size: 24,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _ModeToggle extends StatelessWidget {
//   const _ModeToggle({required this.mode, required this.onChanged});

//   final RegisterMode mode;
//   final ValueChanged<RegisterMode> onChanged;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return Container(
//       height: 48,
//       decoration: BoxDecoration(
//         color: AppColors.divider,
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Row(
//         children: [
//           _ToggleTab(
//             label: l10n.registerModePhone,
//             selected: mode == RegisterMode.phone,
//             onTap: () => onChanged(RegisterMode.phone),
//           ),
//           _ToggleTab(
//             label: l10n.registerModeEmail,
//             selected: mode == RegisterMode.email,
//             onTap: () => onChanged(RegisterMode.email),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ToggleTab extends StatelessWidget {
//   const _ToggleTab({
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 200),
//           margin: const EdgeInsets.all(4),
//           decoration: BoxDecoration(
//             color: selected ? AppColors.backgroundLight : Colors.transparent,
//             borderRadius: BorderRadius.circular(11),
//             boxShadow: selected
//                 ? [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.08),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ]
//                 : const [],
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: selected
//                     ? AppColors.authPrimary
//                     : AppColors.authHint,
//                 fontSize: 13,
//                 fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _PhoneField extends StatelessWidget {
//   const _PhoneField({
//     super.key,
//     required this.controller,
//     required this.focusNode,
//     required this.onChanged,
//     required this.onSubmitted,
//   });

//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final ValueChanged<String> onChanged;
//   final ValueChanged<String> onSubmitted;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           l10n.registerPhoneLabel,
//           style: const TextStyle(
//             color: AppColors.authPrimary,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.divider,
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//                 decoration: const BoxDecoration(
//                   border: Border(
//                     right: BorderSide(color: AppColors.border),
//                   ),
//                 ),
//                 child: Text(
//                   l10n.registerPhoneCountryCode,
//                   style: const TextStyle(
//                     color: AppColors.authPrimary,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 child: TextField(
//                   controller: controller,
//                   focusNode: focusNode,
//                   keyboardType: TextInputType.phone,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(10),
//                   ],
//                   onChanged: onChanged,
//                   onSubmitted: onSubmitted,
//                   style: const TextStyle(
//                     color: AppColors.textPrimary,
//                     fontSize: 15,
//                   ),
//                   decoration: InputDecoration(
//                     hintText: l10n.registerPhoneHint,
//                     hintStyle: const TextStyle(
//                       color: AppColors.authHint,
//                       fontSize: 15,
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 16,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _EmailField extends StatelessWidget {
//   const _EmailField({
//     super.key,
//     required this.controller,
//     required this.focusNode,
//     required this.onChanged,
//     required this.onSubmitted,
//   });

//   final TextEditingController controller;
//   final FocusNode focusNode;
//   final ValueChanged<String> onChanged;
//   final ValueChanged<String> onSubmitted;

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           l10n.registerEmailLabel,
//           style: const TextStyle(
//             color: AppColors.authPrimary,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: AppColors.divider,
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: TextField(
//             controller: controller,
//             focusNode: focusNode,
//             keyboardType: TextInputType.emailAddress,
//             textInputAction: TextInputAction.done,
//             onChanged: onChanged,
//             onSubmitted: onSubmitted,
//             style: const TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: 15,
//             ),
//             decoration: InputDecoration(
//               hintText: l10n.registerEmailHint,
//               hintStyle: const TextStyle(
//                 color: AppColors.authHint,
//                 fontSize: 15,
//               ),
//               border: InputBorder.none,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _OrDivider extends StatelessWidget {
//   const _OrDivider({required this.label});

//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Expanded(child: Divider(color: AppColors.divider)),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: Text(
//             label,
//             style: const TextStyle(
//               color: AppColors.authHint,
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 1.2,
//             ),
//           ),
//         ),
//         const Expanded(child: Divider(color: AppColors.divider)),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/auth_error_mapper.dart';
import '../../../core/widgets/google_sign_in_button.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/register_cubit.dart';
import '../bloc/register_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RegisterCubit(authRepository: context.read<AuthRepository>()),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  bool _emailTouched = false;
  bool _emailFocused = false;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      setState(() => _emailFocused = _emailFocus.hasFocus);
      // При потере фокуса помечаем как тронутое
      if (!_emailFocus.hasFocus && _emailController.text.isNotEmpty) {
        setState(() => _emailTouched = true);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w\-.]+@[\w\-]+\.[a-zA-Z]{2,}$').hasMatch(email.trim());

  // Показываем ошибку только если поле тронуто
  String? _emailError(AppLocalizations l10n) {
    if (!_emailTouched) return null;
    final email = _emailController.text.trim();
    if (email.isEmpty) return l10n.validationEmailRequired;
    if (!_isValidEmail(email)) return l10n.validationEmailInvalid;
    return null;
  }

  bool get _isEmailValid =>
      _isValidEmail(_emailController.text);

  void _handleStateChange(BuildContext context, RegisterState state) {
    switch (state.status) {
      case RegisterStatus.needsProfileSetup:
        context.go(RouteNames.profileSetup,
            extra: {'email': state.currentInput});
      case RegisterStatus.needsLogin:
        // Email уже занят — переходим на логин с предзаполненным email
        context.push(RouteNames.login,
            extra: {'email': state.currentInput});
      case RegisterStatus.authenticated:
        context.go(RouteNames.home);
      case RegisterStatus.idle:
      case RegisterStatus.loading:
      case RegisterStatus.failure:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.surfaceMuted,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listenWhen: (a, b) => a.status != b.status,
              listener: _handleStateChange,
              builder: (context, state) {
                final emailErr = _emailError(l10n);
                final isLoading = state.status == RegisterStatus.loading;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ── Кнопка назад ─────────────────────────────────
                      _BackButton(isDark: isDark, onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(RouteNames.welcome);
                        }
                      }),
                      const SizedBox(height: 28),

                      // ── Логотип ───────────────────────────────────────
                      Center(
                        child: Image.asset(
                          'assets/images/sticky_logo.png',
                          height: 52,
                          color: isDark ? AppColors.brandAccent : null,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Заголовок ─────────────────────────────────────
                      Center(
                        child: Text(
                          'Создать аккаунт',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.brandAccent
                                : AppColors.brandPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          l10n.registerSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // ── Лейбл поля ────────────────────────────────────
                      Text(
                        l10n.registerEmailLabel,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textInverse
                              : AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ── Email поле ────────────────────────────────────
                      _EmailField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        isDark: isDark,
                        isFocused: _emailFocused,
                        hasError: emailErr != null,
                        isValid: _emailTouched && _isEmailValid,
                        hint: l10n.registerEmailHint,
                        onChanged: (v) {
                          setState(() => _emailTouched = true);
                          context.read<RegisterCubit>().emailChanged(v);
                        },
                        onSubmitted: (_) {
                          setState(() => _emailTouched = true);
                          if (_isEmailValid) {
                            context.read<RegisterCubit>().proceed();
                          }
                        },
                      ),

                      // ── Ошибки ────────────────────────────────────────
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: _buildErrorWidget(
                            emailErr, state, l10n, isDark),
                      ),

                      const SizedBox(height: 16),

                      // ── Политика ─────────────────────────────────────
                      GestureDetector(
                        onTap: () => context.push(RouteNames.privacyPolicy),
                        child: Text(
                          l10n.registerPolicy,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.brandAccent
                                : AppColors.brandPrimary,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            decorationColor: isDark
                                ? AppColors.brandAccent
                                : AppColors.brandPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Кнопка «Далее» ────────────────────────────────
                      PrimaryButton(
                        label: l10n.registerProceed,
                        loading: isLoading,
                        enabled: _isEmailValid && !isLoading,
                        onTap: () {
                          setState(() => _emailTouched = true);
                          if (_isEmailValid) {
                            HapticFeedback.lightImpact();
                            context.read<RegisterCubit>().proceed();
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      // ── Разделитель ───────────────────────────────────
                      _OrDivider(
                          label: l10n.orDivider, isDark: isDark),
                      const SizedBox(height: 16),

                      // ── Google ────────────────────────────────────────
                      GoogleSignInButton(
                        label: l10n.googleContinue,
                        loading: isLoading,
                        onTap: () async {
                          await context
                              .read<RegisterCubit>()
                              .signInWithGoogle();
                        },
                      ),
                      const SizedBox(height: 32),

                      // ── Уже есть аккаунт ──────────────────────────────
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.registerHasAccountPrefix,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go(RouteNames.login),
                              child: Text(
                                l10n.registerLoginAction,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.brandAccent
                                      : AppColors.brandPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildErrorWidget(
    String? emailErr,
    RegisterState state,
    AppLocalizations l10n,
    bool isDark,
  ) {
    // Ошибка валидации email
    if (emailErr != null) {
      return _ErrorBanner(
        message: emailErr,
        color: AppColors.danger,
      );
    }

    // Ошибка «email уже занят» — показываем сразу с кнопкой войти
    if (state.status == RegisterStatus.needsLogin) {
      return _ExistingEmailBanner(
        isDark: isDark,
        email: _emailController.text.trim(),
        onLogin: () => context.push(
          RouteNames.login,
          extra: {'email': _emailController.text.trim()},
        ),
      );
    }

    // Другие ошибки от сервера
    if (state.failure != null) {
      return _ErrorBanner(
        message: localizeAuthFailure(state.failure!, l10n),
        color: AppColors.danger,
      );
    }

    // Email валиден и не занят — зелёная подсказка
    if (_emailTouched && _isEmailValid &&
        state.status != RegisterStatus.needsLogin) {
      return const _ErrorBanner(
        message: 'Отлично! Нажмите «Далее» для продолжения',
        color: AppColors.success,
        icon: Icons.check_circle_outline_rounded,
      );
    }

    return const SizedBox.shrink();
  }
}

// ─── Email поле ───────────────────────────────────────────────────────────────

class _EmailField extends StatelessWidget {
  const _EmailField({
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.isFocused,
    required this.hasError,
    required this.isValid,
    required this.hint,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final bool isFocused;
  final bool hasError;
  final bool isValid;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  Color get _borderColor {
    if (hasError) return AppColors.danger;
    if (isValid) return AppColors.success;
    if (isFocused) return AppColors.brandAccent;
    return isDark ? const Color(0xFF3A3D44) : AppColors.border;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E2025)
            : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _borderColor,
          width: isFocused || hasError || isValid ? 2 : 1.5,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: (hasError ? AppColors.danger : AppColors.brandAccent)
                      .withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        // Явно задаём цвет — чтобы был виден в тёмной теме
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        cursorColor: AppColors.brandAccent,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: isDark
                ? const Color(0xFF6B7280)
                : AppColors.textMuted,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: isFocused
                ? AppColors.brandAccent
                : (isDark
                    ? const Color(0xFF6B7280)
                    : AppColors.textMuted),
            size: 20,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? Icon(
                  isValid
                      ? Icons.check_circle_rounded
                      : (hasError ? Icons.error_outline_rounded : null),
                  color: isValid ? AppColors.success : AppColors.danger,
                  size: 20,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}

// ─── Баннер «email уже занят» ─────────────────────────────────────────────────

class _ExistingEmailBanner extends StatelessWidget {
  const _ExistingEmailBanner({
    required this.isDark,
    required this.email,
    required this.onLogin,
  });

  final bool isDark;
  final String email;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.brandAccent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.brandAccent.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.person_outline_rounded,
              color: AppColors.brandAccent,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Аккаунт с таким email уже существует',
                    style: TextStyle(
                      color: AppColors.brandAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Войдите в существующий аккаунт',
                    style: TextStyle(
                      color: AppColors.brandAccent.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onLogin,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.brandAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Войти',
                  style: TextStyle(
                    color: AppColors.backgroundDark,
                    fontSize: 12,
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

// ─── Общий баннер ошибки/успеха ───────────────────────────────────────────────

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({
    required this.message,
    required this.color,
    this.icon = Icons.error_outline_rounded,
  });

  final String message;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Кнопка назад ────────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.isDark, required this.onTap});
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF1E2025)
              : AppColors.backgroundLight,
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? const Color(0xFF3A3D44)
                : AppColors.border,
          ),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
      ),
    );
  }
}

// ─── Разделитель ─────────────────────────────────────────────────────────────

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label, required this.isDark});
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color =
        isDark ? const Color(0xFF3A3D44) : AppColors.divider;
    return Row(
      children: [
        Expanded(child: Divider(color: color)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}