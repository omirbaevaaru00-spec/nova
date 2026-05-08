import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_failure.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/onboarding/onboarding_repository.dart';
import '../../../data/profile/profile_repository.dart';
import 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  ProfileSetupCubit({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    required OnboardingRepository onboardingRepository,
    String? email,
    String? phone,
  })  : _auth = authRepository,
        _profile = profileRepository,
        _onboarding = onboardingRepository,
        super(ProfileSetupState(email: email, phone: phone));

  final AuthRepository _auth;
  final ProfileRepository _profile;
  final OnboardingRepository _onboarding;

  void nameChanged(String value) =>
      emit(state.copyWith(name: value, clearFailure: true));
  void cityChanged(String value) =>
      emit(state.copyWith(city: value, clearFailure: true));
  void passwordChanged(String value) =>
      emit(state.copyWith(password: value, clearFailure: true));

  Future<void> submit() async {
    if (!state.canContinue) return;
    emit(state.copyWith(status: ProfileSetupStatus.loading, clearFailure: true));
    try {
      if (state.isEmailFlow) {
        await _auth.signUpWithEmail(
          email: state.email!,
          password: state.password,
        );
      }

      final uid = _auth.currentUid;
      if (uid == null) {
        emit(
          state.copyWith(
            status: ProfileSetupStatus.failure,
            failure: AuthFailure.unknown,
          ),
        );
        return;
      }

      await _auth.updateDisplayName(state.name.trim());
      await _profile.createInitial(
        uid: uid,
        name: state.name.trim(),
        city: state.city.trim(),
        email: _auth.currentEmail ?? state.email ?? '',
        phone: state.phone ?? '',
        photoUrl: _auth.currentPhotoUrl ?? '',
      );
      await _onboarding.completeOnboarding();
      emit(state.copyWith(status: ProfileSetupStatus.success));
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          status: ProfileSetupStatus.failure,
          failure: e.failure,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileSetupStatus.failure,
          failure: AuthFailure.unknown,
        ),
      );
    }
  }
}
