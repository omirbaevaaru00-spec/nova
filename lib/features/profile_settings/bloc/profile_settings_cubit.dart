import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/onboarding/onboarding_repository.dart';
import '../../../data/profile/profile_repository.dart';
import 'profile_settings_state.dart';

class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
  ProfileSettingsCubit({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    required OnboardingRepository onboardingRepository,
    required FirebaseService firebaseService,
  })  : _auth = authRepository,
        _profile = profileRepository,
        _onboarding = onboardingRepository,
        _firebase = firebaseService,
        super(const ProfileSettingsState());

  final AuthRepository _auth;
  final ProfileRepository _profile;
  final OnboardingRepository _onboarding;
  final FirebaseService _firebase;

  bool get isAuthenticated => _auth.isAuthenticated;

  Future<void> load() async {
    emit(state.copyWith(status: ProfileSettingsStatus.loading));
    final raw = await _profile.rawData() ?? const {};
    final interests = await _onboarding.getSavedInterests();
    emit(
      state.copyWith(
        status: ProfileSettingsStatus.ready,
        name: (raw['name'] as String?) ?? '',
        city: (raw['city'] as String?) ?? '',
        gpa: raw['gpa']?.toString() ?? '',
        ielts: raw['ielts']?.toString() ?? '',
        ent: raw['ent']?.toString() ?? '',
        interests: interests,
      ),
    );
  }

  Future<void> updateProfile({required String name, required String city}) async {
    emit(state.copyWith(status: ProfileSettingsStatus.saving));
    try {
      if (name.isNotEmpty) await _auth.updateDisplayName(name);
      await _profile.updateProfile(name: name, city: city);
      emit(
        state.copyWith(
          status: ProfileSettingsStatus.saved,
          name: name.isNotEmpty ? name : null,
          city: city.isNotEmpty ? city : null,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ProfileSettingsStatus.saveError));
    }
  }

  Future<void> updateScores({
    required String gpa,
    required String ielts,
    required String ent,
  }) async {
    emit(state.copyWith(status: ProfileSettingsStatus.saving));
    try {
      await _profile.saveScores(
        gpa: gpa.isNotEmpty ? double.tryParse(gpa) : null,
        ielts: ielts.isNotEmpty ? double.tryParse(ielts) : null,
        ent: ent.isNotEmpty ? int.tryParse(ent) : null,
      );
      emit(
        state.copyWith(
          status: ProfileSettingsStatus.saved,
          gpa: gpa,
          ielts: ielts,
          ent: ent,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ProfileSettingsStatus.saveError));
    }
  }

  Future<void> uploadAvatar(String filePath) async {
    if (!isAuthenticated) return;
    emit(state.copyWith(status: ProfileSettingsStatus.uploadingPhoto));
    try {
      final url = await _firebase.uploadAvatar(File(filePath));
      await _auth.updatePhotoUrl(url);
      await _profile.updateProfile(photoUrl: url);
      emit(state.copyWith(status: ProfileSettingsStatus.saved));
    } catch (_) {
      emit(state.copyWith(status: ProfileSettingsStatus.photoError));
    }
  }

  Future<void> reloadInterests() async {
    final interests = await _onboarding.getSavedInterests();
    emit(state.copyWith(interests: interests));
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(state.copyWith(status: ProfileSettingsStatus.signedOut));
  }

  Future<void> deleteAccount() async {}
}
