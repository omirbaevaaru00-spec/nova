// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// import '../../../core/router/route_names.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/widgets/auth_error_mapper.dart';
// import '../../../core/widgets/auth_input_field.dart';
// import '../../../core/widgets/primary_button.dart';
// import '../../../data/auth/auth_repository.dart';
// import '../../../l10n/generated/app_localizations.dart';
// import '../bloc/forgot_password_cubit.dart';
// import '../bloc/forgot_password_state.dart';

// class ForgotPasswordScreen extends StatelessWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ForgotPasswordCubit(
//         authRepository: context.read<AuthRepository>(),
//       ),
//       child: const _ForgotPasswordView(),
//     );
//   }
// }

// class _ForgotPasswordView extends StatefulWidget {
//   const _ForgotPasswordView();

//   @override
//   State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
// }

// class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
//   final _emailController = TextEditingController();
//   final _emailFocus = FocusNode();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _emailFocus.dispose();
//     super.dispose();
//   }

//   Future<void> _submit(BuildContext context) async {
//     HapticFeedback.lightImpact();
//     await context.read<ForgotPasswordCubit>().sendReset();
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
//             child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
//               builder: (context, state) {
//                 final sent = state.status == ForgotPasswordStatus.sent;
//                 return SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 24),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () => context.pop(),
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
//                       const SizedBox(height: 32),
//                       _StateIcon(sent: sent),
//                       const SizedBox(height: 28),
//                       Text(
//                         sent ? l10n.forgotSentTitle : l10n.forgotTitle,
//                         textAlign: TextAlign.center,
//                         style: const TextStyle(
//                           color: AppColors.authPrimary,
//                           fontSize: 26,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: -0.3,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         sent
//                             ? l10n.forgotSentSubtitle(state.email.trim())
//                             : l10n.forgotSubtitle,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: AppColors.textPrimary.withValues(alpha: 0.45),
//                           fontSize: 15,
//                           height: 1.5,
//                         ),
//                       ),
//                       const SizedBox(height: 40),
//                       if (sent)
//                         Column(
//                           children: [
//                             PrimaryButton(
//                               label: l10n.forgotBackToLogin,
//                               onTap: () => context.go(RouteNames.login),
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               l10n.forgotCheckSpam,
//                               style: TextStyle(
//                                 color: AppColors.textPrimary
//                                     .withValues(alpha: 0.4),
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ],
//                         )
//                       else
//                         Column(
//                           children: [
//                             AuthInputField(
//                               controller: _emailController,
//                               focusNode: _emailFocus,
//                               hint: l10n.emailHint,
//                               prefixIcon: Icons.email_outlined,
//                               keyboardType: TextInputType.emailAddress,
//                               textInputAction: TextInputAction.done,
//                               hasError: state.failure != null,
//                               onChanged: context
//                                   .read<ForgotPasswordCubit>()
//                                   .emailChanged,
//                               onSubmitted: (_) => _submit(context),
//                             ),
//                             if (state.failure != null) ...[
//                               const SizedBox(height: 8),
//                               Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Text(
//                                   localizeAuthFailure(state.failure!, l10n),
//                                   style: const TextStyle(
//                                     color: AppColors.danger,
//                                     fontSize: 13,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                             const SizedBox(height: 24),
//                             PrimaryButton(
//                               label: l10n.forgotSendAction,
//                               loading: state.status ==
//                                   ForgotPasswordStatus.loading,
//                               enabled: state.canSubmit,
//                               onTap: () => _submit(context),
//                             ),
//                           ],
//                         ),
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

// class _StateIcon extends StatelessWidget {
//   const _StateIcon({required this.sent});

//   final bool sent;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       duration: const Duration(milliseconds: 400),
//       child: Container(
//         key: ValueKey(sent),
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           color: sent
//               ? AppColors.brandAccent.withValues(alpha: 0.12)
//               : AppColors.authPrimary.withValues(alpha: 0.08),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           sent ? Icons.mark_email_read_outlined : Icons.lock_reset_rounded,
//           color: sent ? AppColors.brandAccent : AppColors.authPrimary,
//           size: 38,
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
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/auth_error_mapper.dart';
import '../../../core/widgets/auth_input_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/forgot_password_cubit.dart';
import '../bloc/forgot_password_state.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(
        authRepository: context.read<AuthRepository>(),
      ),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.login);
    }
  }

  Future<void> _submit(BuildContext context) async {
    HapticFeedback.lightImpact();
    await context.read<ForgotPasswordCubit>().sendReset();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;
    final cardColor =
        isDark ? AppColors.surfaceMutedDark : AppColors.backgroundLight;
    final borderColor =
        isDark ? const Color(0xFF2C2F36) : AppColors.border;
    final labelColor =
        isDark ? AppColors.textInverse : AppColors.textPrimary;
    final titleColor =
        isDark ? AppColors.brandAccent : AppColors.authPrimary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
              builder: (context, state) {
                final sent = state.status == ForgotPasswordStatus.sent;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // ── Кнопка назад ─────────────────────────────────
                      GestureDetector(
                        onTap: () => _handleBack(context),
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
                      const SizedBox(height: 20),

                      // ── Логотип ───────────────────────────────────────
                      Center(
                        child: Image.asset(
                          'assets/images/sticky_logo.png',
                          height: 48,
                          color: isDark ? AppColors.brandAccent : null,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ── Иконка состояния ──────────────────────────────
                      Center(child: _StateIcon(sent: sent, isDark: isDark)),
                      const SizedBox(height: 28),

                      // ── Заголовок ─────────────────────────────────────
                      Center(
                        child: Text(
                          sent ? l10n.forgotSentTitle : l10n.forgotTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          sent
                              ? l10n.forgotSentSubtitle(state.email.trim())
                              : l10n.forgotSubtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),

                      if (sent)
                        Column(
                          children: [
                            PrimaryButton(
                              label: l10n.forgotBackToLogin,
                              onTap: () => context.go(RouteNames.login),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                l10n.forgotCheckSpam,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthInputField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              hint: l10n.emailHint,
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              hasError: state.failure != null,
                              onChanged: context
                                  .read<ForgotPasswordCubit>()
                                  .emailChanged,
                              onSubmitted: (_) => _submit(context),
                            ),
                            if (state.failure != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.danger
                                      .withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.danger
                                        .withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline_rounded,
                                        size: 16, color: AppColors.danger),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        localizeAuthFailure(
                                            state.failure!, l10n),
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
                            const SizedBox(height: 24),
                            PrimaryButton(
                              label: l10n.forgotSendAction,
                              loading: state.status ==
                                  ForgotPasswordStatus.loading,
                              enabled: state.canSubmit,
                              onTap: () => _submit(context),
                            ),
                          ],
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

class _StateIcon extends StatelessWidget {
  const _StateIcon({required this.sent, required this.isDark});

  final bool sent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: Container(
        key: ValueKey(sent),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: sent
              ? AppColors.brandAccent.withValues(alpha: 0.12)
              : (isDark
                  ? AppColors.surfaceMutedDark
                  : AppColors.authPrimary.withValues(alpha: 0.08)),
          shape: BoxShape.circle,
        ),
        child: Icon(
          sent ? Icons.mark_email_read_outlined : Icons.lock_reset_rounded,
          color: sent ? AppColors.brandAccent : AppColors.authPrimary,
          size: 38,
        ),
      ),
    );
  }
}