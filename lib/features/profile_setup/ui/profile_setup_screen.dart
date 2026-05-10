import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/route_names.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/auth_error_mapper.dart';
import '../../../core/widgets/auth_input_field.dart';
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
                      const SizedBox(height: 32),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: AppColors.divider,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.authPrimaryLight,
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        l10n.profileSetupTitle,
                        style: const TextStyle(
                          color: AppColors.authPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.profileSetupSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary.withValues(alpha: 0.45),
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 40),
                      _Label(text: l10n.profileSetupNameLabel),
                      const SizedBox(height: 8),
                      AuthInputField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        hint: l10n.profileSetupNameHint,
                        onChanged: context.read<ProfileSetupCubit>().nameChanged,
                        onSubmitted: (_) => _cityFocus.requestFocus(),
                      ),
                      const SizedBox(height: 20),
                      _Label(text: l10n.profileSetupCityLabel),
                      const SizedBox(height: 8),
                      AuthInputField(
                        controller: _cityController,
                        focusNode: _cityFocus,
                        hint: l10n.profileSetupCityHint,
                        textInputAction: state.isEmailFlow
                            ? TextInputAction.next
                            : TextInputAction.done,
                        onChanged: context.read<ProfileSetupCubit>().cityChanged,
                        onSubmitted: (_) {
                          if (state.isEmailFlow) {
                            _passwordFocus.requestFocus();
                          } else {
                            context.read<ProfileSetupCubit>().submit();
                          }
                        },
                      ),
                      if (state.isEmailFlow) ...[
                        const SizedBox(height: 20),
                        _Label(text: l10n.profileSetupPasswordLabel),
                        const SizedBox(height: 8),
                        AuthInputField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          hint: l10n.profileSetupPasswordHint,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onChanged: context
                              .read<ProfileSetupCubit>()
                              .passwordChanged,
                          onSubmitted: (_) =>
                              context.read<ProfileSetupCubit>().submit(),
                          suffix: GestureDetector(
                            onTap: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.authHint,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            l10n.profileSetupPasswordHint,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary
                                  .withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                      ],
                      if (state.failure != null) ...[
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            localizeAuthFailure(state.failure!, l10n),
                            style: const TextStyle(
                              color: AppColors.danger,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                      PrimaryButton(
                        label: l10n.profileSetupContinue,
                        loading:
                            state.status == ProfileSetupStatus.loading,
                        enabled: state.canContinue,
                        onTap: () =>
                            context.read<ProfileSetupCubit>().submit(),
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

class _Label extends StatelessWidget {
  const _Label({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.authPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
