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
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _handleStateChange(BuildContext context, RegisterState state) {
    switch (state.status) {
      case RegisterStatus.smsSent:
        if (state.verificationId == null) return;
        context.push(
          RouteNames.phoneOtp,
          extra: {
            'phone': state.fullPhone,
            'verificationId': state.verificationId,
          },
        );
      case RegisterStatus.needsProfileSetup:
        context.go(
          RouteNames.profileSetup,
          extra: state.mode == RegisterMode.email
              ? {'email': state.currentInput}
              : null,
        );
      case RegisterStatus.needsLogin:
        context.push(
          RouteNames.login,
          extra: {'email': state.currentInput},
        );
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.surfaceMuted,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listenWhen: (a, b) => a.status != b.status,
              listener: _handleStateChange,
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _BackButton(),
                      const SizedBox(height: 20),
                      Image.asset('assets/images/nova_logo.png', height: 48),
                      const SizedBox(height: 28),
                      Text(
                        l10n.registerTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.authPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _ModeToggle(
                        mode: state.mode,
                        onChanged: (m) {
                          HapticFeedback.selectionClick();
                          context.read<RegisterCubit>().setMode(m);
                          (m == RegisterMode.phone
                                  ? _phoneFocus
                                  : _emailFocus)
                              .requestFocus();
                        },
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: state.mode == RegisterMode.phone
                            ? _PhoneField(
                                key: const ValueKey('phone'),
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                onChanged: context
                                    .read<RegisterCubit>()
                                    .phoneChanged,
                                onSubmitted: (_) =>
                                    context.read<RegisterCubit>().proceed(),
                              )
                            : _EmailField(
                                key: const ValueKey('email'),
                                controller: _emailController,
                                focusNode: _emailFocus,
                                onChanged: context
                                    .read<RegisterCubit>()
                                    .emailChanged,
                                onSubmitted: (_) =>
                                    context.read<RegisterCubit>().proceed(),
                              ),
                      ),
                      if (state.failure != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          localizeAuthFailure(state.failure!, l10n),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      Text(
                        l10n.registerPolicy,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.authPrimaryLight,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.authPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 28),
                      PrimaryButton(
                        label: l10n.registerProceed,
                        loading: state.status == RegisterStatus.loading,
                        enabled: state.canProceed,
                        onTap: () =>
                            context.read<RegisterCubit>().proceed(),
                      ),
                      const SizedBox(height: 16),
                      _OrDivider(label: l10n.orDivider),
                      const SizedBox(height: 16),
                      GoogleSignInButton(
                        label: l10n.googleContinue,
                        loading: state.status == RegisterStatus.loading,
                        onTap: () async {
                          await context
                              .read<RegisterCubit>()
                              .signInWithGoogle();
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.registerHasAccountPrefix,
                            style: TextStyle(
                              color: AppColors.textPrimary
                                  .withValues(alpha: 0.45),
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go(RouteNames.login),
                            child: Text(
                              l10n.registerLoginAction,
                              style: const TextStyle(
                                color: AppColors.authPrimaryLight,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.canPop()
              ? context.pop()
              : context.go(RouteNames.welcome),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.authPrimaryLight,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});

  final RegisterMode mode;
  final ValueChanged<RegisterMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _ToggleTab(
            label: l10n.registerModePhone,
            selected: mode == RegisterMode.phone,
            onTap: () => onChanged(RegisterMode.phone),
          ),
          _ToggleTab(
            label: l10n.registerModeEmail,
            selected: mode == RegisterMode.email,
            onTap: () => onChanged(RegisterMode.email),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  const _ToggleTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected ? AppColors.backgroundLight : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : const [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected
                    ? AppColors.authPrimary
                    : AppColors.authHint,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.registerPhoneLabel,
          style: const TextStyle(
            color: AppColors.authPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppColors.border),
                  ),
                ),
                child: Text(
                  l10n.registerPhoneCountryCode,
                  style: const TextStyle(
                    color: AppColors.authPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.registerPhoneHint,
                    hintStyle: const TextStyle(
                      color: AppColors.authHint,
                      fontSize: 15,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.registerEmailLabel,
          style: const TextStyle(
            color: AppColors.authPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.divider,
            borderRadius: BorderRadius.circular(14),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: l10n.registerEmailHint,
              hintStyle: const TextStyle(
                color: AppColors.authHint,
                fontSize: 15,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.authHint,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider)),
      ],
    );
  }
}
