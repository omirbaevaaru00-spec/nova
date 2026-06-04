// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../../../core/router/route_names.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/widgets/auth_error_mapper.dart';
// import '../../../core/widgets/auth_input_field.dart';
// import '../../../core/widgets/google_sign_in_button.dart';
// import '../../../core/widgets/primary_button.dart';
// import '../../../data/auth/auth_repository.dart';
// import '../../../l10n/generated/app_localizations.dart';
// import '../bloc/login_cubit.dart';
// import '../bloc/login_state.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           LoginCubit(authRepository: context.read<AuthRepository>()),
//       child: const _LoginView(),
//     );
//   }
// }

// class _LoginView extends StatefulWidget {
//   const _LoginView();

//   @override
//   State<_LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<_LoginView> {
//   final _idController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _idFocus = FocusNode();
//   final _passwordFocus = FocusNode();
//   bool _obscurePassword = true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       final extra = GoRouterState.of(context).extra;
//       if (extra is Map && extra['email'] is String) {
//         final email = extra['email'] as String;
//         _idController.text = email;
//         context.read<LoginCubit>().prefillEmail(email);
//         _passwordFocus.requestFocus();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _idController.dispose();
//     _passwordController.dispose();
//     _idFocus.dispose();
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
//             child: BlocConsumer<LoginCubit, LoginState>(
//               listenWhen: (a, b) => a.status != b.status,
//               listener: (context, state) {
//                 switch (state.status) {
//                   case LoginStatus.success:
//                     context.go(RouteNames.home);
//                   case LoginStatus.phoneSoon:
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text(l10n.loginPhoneSoon)),
//                     );
//                   case LoginStatus.idle:
//                   case LoginStatus.loading:
//                   case LoginStatus.failure:
//                     break;
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
//                       const SizedBox(height: 20),
//                       Image.asset('assets/images/sticky_logo.png', height: 48),
//                       const SizedBox(height: 24),
//                       Text(
//                         l10n.loginTitle,
//                         style: const TextStyle(
//                           color: AppColors.authPrimary,
//                           fontSize: 26,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         l10n.loginSubtitle,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: AppColors.textPrimary.withValues(alpha: 0.45),
//                           fontSize: 15,
//                           height: 1.4,
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                       AuthInputField(
//                         controller: _idController,
//                         focusNode: _idFocus,
//                         hint: l10n.loginIdHint,
//                         keyboardType: TextInputType.emailAddress,
//                         textInputAction: TextInputAction.next,
//                         onChanged: context.read<LoginCubit>().identifierChanged,
//                         onSubmitted: (_) => _passwordFocus.requestFocus(),
//                       ),
//                       const SizedBox(height: 12),
//                       AuthInputField(
//                         controller: _passwordController,
//                         focusNode: _passwordFocus,
//                         hint: l10n.passwordHint,
//                         obscureText: _obscurePassword,
//                         textInputAction: TextInputAction.done,
//                         onChanged: context.read<LoginCubit>().passwordChanged,
//                         onSubmitted: (_) {
//                           HapticFeedback.lightImpact();
//                           context.read<LoginCubit>().submit();
//                         },
//                         suffix: GestureDetector(
//                           onTap: () => setState(
//                             () => _obscurePassword = !_obscurePassword,
//                           ),
//                           child: Icon(
//                             _obscurePassword
//                                 ? Icons.visibility_off_outlined
//                                 : Icons.visibility_outlined,
//                             color: AppColors.authHint,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                       if (state.failure != null) ...[
//                         const SizedBox(height: 10),
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
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: GestureDetector(
//                           onTap: () => context.push(RouteNames.forgotPassword),
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             child: Text(
//                               l10n.loginForgotPassword,
//                               style: const TextStyle(
//                                 color: AppColors.authPrimaryLight,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       PrimaryButton(
//                         label: l10n.loginAction,
//                         loading: state.status == LoginStatus.loading,
//                         enabled: state.canSubmit,
//                         onTap: () {
//                           HapticFeedback.lightImpact();
//                           context.read<LoginCubit>().submit();
//                         },
//                       ),
//                       const SizedBox(height: 20),
//                       _OrDivider(label: l10n.orDivider),
//                       const SizedBox(height: 16),
//                       GoogleSignInButton(
//                         label: l10n.googleSignIn,
//                         loading: state.status == LoginStatus.loading,
//                         onTap: () async {
//                           await context.read<LoginCubit>().signInWithGoogle();
//                         },
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             l10n.loginNoAccountPrefix,
//                             style: TextStyle(
//                               color:
//                                   AppColors.textPrimary.withValues(alpha: 0.45),
//                               fontSize: 14,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () => context.go(RouteNames.register),
//                             child: Text(
//                               l10n.actionRegister,
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
import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginCubit(authRepository: context.read<AuthRepository>()),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _emailFocused = false;
  bool _passwordFocused = false;

  @override
  void initState() {
    super.initState();
    _idFocus.addListener(
        () => setState(() => _emailFocused = _idFocus.hasFocus));
    _passwordFocus.addListener(
        () => setState(() => _passwordFocused = _passwordFocus.hasFocus));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final extra = GoRouterState.of(context).extra;
      if (extra is Map && extra['email'] is String) {
        final email = extra['email'] as String;
        _idController.text = email;
        context.read<LoginCubit>().prefillEmail(email);
        _passwordFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _idFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: BlocConsumer<LoginCubit, LoginState>(
              listenWhen: (a, b) => a.status != b.status,
              listener: (context, state) {
                switch (state.status) {
                  case LoginStatus.success:
                    context.go(RouteNames.home);
                  case LoginStatus.phoneSoon:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.loginPhoneSoon),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.all(16),
                      ),
                    );
                  case LoginStatus.idle:
                  case LoginStatus.loading:
                  case LoginStatus.failure:
                    break;
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ── Кнопка назад ─────────────────────────────────
                      GestureDetector(
                        onTap: () => _handleBack(context),
                        child: _CircleButton(isDark: isDark),
                      ),
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
                          l10n.loginTitle,
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
                          l10n.loginSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),

                      // ── Email ─────────────────────────────────────────
                      _FieldLabel(
                          text: 'Электронная почта', isDark: isDark),
                      const SizedBox(height: 8),
                      _AuthField(
                        controller: _idController,
                        focusNode: _idFocus,
                        isDark: isDark,
                        isFocused: _emailFocused,
                        hasError: state.failure != null,
                        hint: l10n.loginIdHint,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged:
                            context.read<LoginCubit>().identifierChanged,
                        onSubmitted: (_) =>
                            _passwordFocus.requestFocus(),
                      ),
                      const SizedBox(height: 16),

                      // ── Пароль ────────────────────────────────────────
                      _FieldLabel(text: 'Пароль', isDark: isDark),
                      const SizedBox(height: 8),
                      _AuthField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        isDark: isDark,
                        isFocused: _passwordFocused,
                        hasError: state.failure != null,
                        hint: l10n.passwordHint,
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onChanged:
                            context.read<LoginCubit>().passwordChanged,
                        onSubmitted: (_) {
                          HapticFeedback.lightImpact();
                          context.read<LoginCubit>().submit();
                        },
                        suffix: GestureDetector(
                          onTap: () => setState(
                            () =>
                                _obscurePassword = !_obscurePassword,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 16),
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

                      // ── Ошибка ────────────────────────────────────────
                      if (state.failure != null) ...[
                        const SizedBox(height: 10),
                        _ErrorContainer(
                          message:
                              localizeAuthFailure(state.failure!, l10n),
                          isDark: isDark,
                        ),
                      ],

                      // ── Забыл пароль ──────────────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => context
                              .push(RouteNames.forgotPassword),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              l10n.loginForgotPassword,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.brandAccent
                                    : AppColors.brandPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ── Кнопка войти ──────────────────────────────────
                      PrimaryButton(
                        label: l10n.loginAction,
                        loading:
                            state.status == LoginStatus.loading,
                        enabled: state.canSubmit,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.read<LoginCubit>().submit();
                        },
                      ),
                      const SizedBox(height: 24),

                      // ── Разделитель ───────────────────────────────────
                      _OrDivider(
                          label: l10n.orDivider, isDark: isDark),
                      const SizedBox(height: 16),

                      // ── Google ────────────────────────────────────────
                      GoogleSignInButton(
                        label: l10n.googleSignIn,
                        loading:
                            state.status == LoginStatus.loading,
                        onTap: () async {
                          await context
                              .read<LoginCubit>()
                              .signInWithGoogle();
                        },
                      ),
                      const SizedBox(height: 28),

                      // ── Нет аккаунта ──────────────────────────────────
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.loginNoAccountPrefix,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  context.go(RouteNames.register),
                              child: Text(
                                l10n.actionRegister,
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
}

// ─── Переиспользуемые виджеты ─────────────────────────────────────────────────

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

class _AuthField extends StatelessWidget {
  const _AuthField({
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
    this.keyboardType = TextInputType.text,
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
  final TextInputType keyboardType;
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
        // Явно тёмный фон для тёмной темы
        color: isDark
            ? const Color(0xFF1E2025)
            : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _borderColor,
          width: isFocused || hasError ? 2 : 1.5,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color:
                      (hasError ? AppColors.danger : AppColors.brandAccent)
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
                  : (isDark
                      ? const Color(0xFF6B7280)
                      : AppColors.textMuted),
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              // Ключевое — явный белый цвет в тёмной теме
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

class _ErrorContainer extends StatelessWidget {
  const _ErrorContainer(
      {required this.message, required this.isDark});
  final String message;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.danger.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 16, color: AppColors.danger),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.danger,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

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