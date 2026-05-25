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
import '../../../core/widgets/auth_input_field.dart';
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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;
    final cardColor =
        isDark ? AppColors.surfaceMutedDark : AppColors.backgroundLight;
    final labelColor =
        isDark ? AppColors.textInverse : AppColors.textPrimary;
    final borderColor =
        isDark ? const Color(0xFF2C2F36) : AppColors.border;
    final titleColor =
        isDark ? AppColors.brandAccent : AppColors.brandPrimary;
    final dividerColor =
        isDark ? const Color(0xFF2C2F36) : AppColors.divider;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
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

                      // ── Кнопка назад — всегда работает ───────────────
                      GestureDetector(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(RouteNames.welcome);
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: borderColor),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: labelColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Логотип ───────────────────────────────────────
                      Center(
                        child: Image.asset(
                          'assets/images/sticky_logo.png',
                          height: 48,
                          color: isDark ? AppColors.brandAccent : null,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Заголовок ─────────────────────────────────────
                      Center(
                        child: Text(
                          l10n.loginTitle,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          l10n.loginSubtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // ── Email поле ─────────────────────────────────────
                      // AuthInputField уже поддерживает hasError — используем его
                      AuthInputField(
                        controller: _idController,
                        focusNode: _idFocus,
                        hint: l10n.loginIdHint,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: context.read<LoginCubit>().identifierChanged,
                        onSubmitted: (_) => _passwordFocus.requestFocus(),
                      ),
                      const SizedBox(height: 12),

                      // ── Пароль ────────────────────────────────────────
                      AuthInputField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        hint: l10n.passwordHint,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onChanged: context.read<LoginCubit>().passwordChanged,
                        onSubmitted: (_) {
                          HapticFeedback.lightImpact();
                          context.read<LoginCubit>().submit();
                        },
                        suffix: GestureDetector(
                          onTap: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),

                      // ── Ошибка от сервера ─────────────────────────────
                      if (state.failure != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.danger.withValues(alpha: 0.2),
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

                      // ── Забыл пароль ──────────────────────────────────
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () =>
                              context.push(RouteNames.forgotPassword),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
                      const SizedBox(height: 8),

                      // ── Кнопка войти ──────────────────────────────────
                      PrimaryButton(
                        label: l10n.loginAction,
                        loading: state.status == LoginStatus.loading,
                        enabled: state.canSubmit,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.read<LoginCubit>().submit();
                        },
                      ),
                      const SizedBox(height: 24),

                      // ── Разделитель ───────────────────────────────────
                      Row(
                        children: [
                          Expanded(child: Divider(color: dividerColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              l10n.orDivider,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: dividerColor)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // ── Google ────────────────────────────────────────
                      GoogleSignInButton(
                        label: l10n.googleSignIn,
                        loading: state.status == LoginStatus.loading,
                        onTap: () async {
                          await context.read<LoginCubit>().signInWithGoogle();
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
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go(RouteNames.register),
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
