import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/phone_otp_cubit.dart';
import '../bloc/phone_otp_state.dart';

class PhoneOtpScreen extends StatelessWidget {
  const PhoneOtpScreen({super.key, required this.phone, required this.verificationId});

  final String phone;
  final String verificationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhoneOtpCubit(
        authRepository: context.read<AuthRepository>(),
        phone: phone,
        verificationId: verificationId,
      ),
      child: const _PhoneOtpView(),
    );
  }
}

class _PhoneOtpView extends StatefulWidget {
  const _PhoneOtpView();

  @override
  State<_PhoneOtpView> createState() => _PhoneOtpViewState();
}

class _PhoneOtpViewState extends State<_PhoneOtpView> {
  static const _length = 6;
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_length, (_) => TextEditingController());
    _focusNodes = List.generate(_length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onDigit(BuildContext context, int index, String value) {
    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    final code = _controllers.map((c) => c.text).join();
    context.read<PhoneOtpCubit>().codeChanged(code);
    if (code.length == _length) {
      context.read<PhoneOtpCubit>().verify();
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
            child: BlocConsumer<PhoneOtpCubit, PhoneOtpState>(
              listenWhen: (a, b) => a.status != b.status,
              listener: (context, state) {
                if (state.status == PhoneOtpStatus.success) {
                  context.go(
                    RouteNames.profileSetup,
                    extra: {'phone': state.phone},
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                context.canPop() ? context.pop() : null,
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.authPrimaryLight,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: AppColors.divider,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.sms_rounded,
                          color: AppColors.authPrimaryLight,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.phoneOtpTitle,
                        style: const TextStyle(
                          color: AppColors.authPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.phoneOtpSubtitle(state.phone),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary.withValues(alpha: 0.45),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_length, (i) {
                          return _OtpCell(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            isLast: i == _length - 1,
                            onChanged: (val) => _onDigit(context, i, val),
                          );
                        }),
                      ),
                      if (state.failure != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          l10n.phoneOtpInvalidCode,
                          style: const TextStyle(
                            color: AppColors.danger,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      PrimaryButton(
                        label: l10n.phoneOtpVerify,
                        loading: state.status == PhoneOtpStatus.verifying ||
                            state.status == PhoneOtpStatus.resending,
                        enabled: state.canVerify,
                        onTap: () => context.read<PhoneOtpCubit>().verify(),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: state.canResend
                            ? () => context.read<PhoneOtpCubit>().resend()
                            : null,
                        child: Text(
                          state.resendSeconds > 0
                              ? l10n.phoneOtpResendIn(state.resendSeconds)
                              : l10n.phoneOtpResend,
                          style: TextStyle(
                            color: state.canResend
                                ? AppColors.authPrimaryLight
                                : AppColors.textPrimary
                                    .withValues(alpha: 0.4),
                            fontSize: 14,
                            fontWeight: state.canResend
                                ? FontWeight.w600
                                : FontWeight.w400,
                            decoration: state.canResend
                                ? TextDecoration.underline
                                : null,
                          ),
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

class _OtpCell extends StatelessWidget {
  const _OtpCell({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.isLast,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 56,
      margin: EdgeInsets.only(right: isLast ? 0 : 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: focusNode.hasFocus
              ? AppColors.authPrimary
              : AppColors.divider,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.authPrimary,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
          contentPadding: EdgeInsets.zero,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: onChanged,
      ),
    );
  }
}
