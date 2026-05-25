// import 'dart:io';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';

// import '../../../core/services/firebase_service.dart';
// import '../../../data/auth/auth_repository.dart';
// import '../../../data/onboarding/onboarding_repository.dart';
// import '../../../data/profile/profile_repository.dart';
// import 'profile_settings_state.dart';

// class ProfileSettingsCubit extends Cubit<ProfileSettingsState> {
//   ProfileSettingsCubit({
//     required AuthRepository authRepository,
//     required ProfileRepository profileRepository,
//     required OnboardingRepository onboardingRepository,
//     required FirebaseService firebaseService,
//   })  : _auth = authRepository,
//         _profile = profileRepository,
//         _onboarding = onboardingRepository,
//         _firebase = firebaseService,
//         super(const ProfileSettingsState());

//   final AuthRepository _auth;
//   final ProfileRepository _profile;
//   final OnboardingRepository _onboarding;
//   final FirebaseService _firebase;
//   final _log = Logger();

//   bool get isAuthenticated => _auth.isAuthenticated;

//   Future<void> load() async {
//     emit(state.copyWith(status: ProfileSettingsStatus.loading));
//     final raw = await _profile.rawData() ?? const {};
//     final interests = await _onboarding.getSavedInterests();
//     emit(
//       state.copyWith(
//         status: ProfileSettingsStatus.ready,
//         name: (raw['name'] as String?) ?? '',
//         city: (raw['city'] as String?) ?? '',
//         gpa: raw['gpa']?.toString() ?? '',
//         ielts: raw['ielts']?.toString() ?? '',
//         ent: raw['ent']?.toString() ?? '',
//         interests: interests,
//       ),
//     );
//   }

//   Future<void> updateProfile({
//     required String name,
//     required String city,
//   }) async {
//     emit(state.copyWith(status: ProfileSettingsStatus.saving));
//     try {
//       if (name.isNotEmpty) await _auth.updateDisplayName(name);
//       await _profile.updateProfile(name: name, city: city);
//       emit(state.copyWith(
//         status: ProfileSettingsStatus.saved,
//         name: name.isNotEmpty ? name : null,
//         city: city.isNotEmpty ? city : null,
//       ));
//     } catch (e) {
//       _log.e('updateProfile', error: e);
//       emit(state.copyWith(status: ProfileSettingsStatus.saveError));
//     }
//   }

//   Future<void> updateScores({
//     required String gpa,
//     required String ielts,
//     required String ent,
//   }) async {
//     emit(state.copyWith(status: ProfileSettingsStatus.saving));
//     try {
//       await _profile.saveScores(
//         gpa: gpa.isNotEmpty ? double.tryParse(gpa) : null,
//         ielts: ielts.isNotEmpty ? double.tryParse(ielts) : null,
//         ent: ent.isNotEmpty ? int.tryParse(ent) : null,
//       );
//       emit(state.copyWith(
//         status: ProfileSettingsStatus.saved,
//         gpa: gpa,
//         ielts: ielts,
//         ent: ent,
//       ));
//     } catch (e) {
//       _log.e('updateScores', error: e);
//       emit(state.copyWith(status: ProfileSettingsStatus.saveError));
//     }
//   }

//   Future<void> uploadAvatar(String filePath) async {
//     if (!isAuthenticated) return;
//     emit(state.copyWith(status: ProfileSettingsStatus.uploadingPhoto));
//     try {
//       final url = await _firebase.uploadAvatar(File(filePath));
//       await _auth.updatePhotoUrl(url);
//       await _profile.updateProfile(photoUrl: url);
//       emit(state.copyWith(status: ProfileSettingsStatus.saved));
//     } catch (e) {
//       _log.e('uploadAvatar', error: e);
//       emit(state.copyWith(status: ProfileSettingsStatus.photoError));
//     }
//   }

//   Future<void> reloadInterests() async {
//     final interests = await _onboarding.getSavedInterests();
//     emit(state.copyWith(interests: interests));
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//     emit(state.copyWith(status: ProfileSettingsStatus.signedOut));
//   }

//   /// Полное удаление аккаунта:
//   /// 1. Удаляем данные профиля из Firestore
//   /// 2. Удаляем избранные из Firestore
//   /// 3. Удаляем отзывы пользователя (помечаем как анонимные)
//   /// 4. Удаляем аккаунт из Firebase Auth
//   /// 5. Очищаем локальные данные (SharedPreferences)
//   Future<void> deleteAccount() async {
//     emit(state.copyWith(status: ProfileSettingsStatus.saving));
//     try {
//       final user = _firebase.auth.currentUser;
//       if (user == null) {
//         emit(state.copyWith(status: ProfileSettingsStatus.saveError));
//         return;
//       }
//       final uid = user.uid;

//       // 1. Удаляем документ профиля из Firestore
//       await _firebase.firestore.collection('users').doc(uid).delete();
//       _log.i('deleteAccount: профиль удалён ($uid)');

//       // 2. Удаляем избранные пользователя
//       try {
//         await _firebase.firestore
//             .collection('favorites')
//             .doc(uid)
//             .delete();
//         _log.i('deleteAccount: избранные удалены ($uid)');
//       } catch (e) {
//         _log.w('deleteAccount: ошибка удаления избранных', error: e);
//       }

//       // 3. Очищаем локальные сохранённые интересы и онбординг
//       await _onboarding.clearAll();
//       _log.i('deleteAccount: локальные данные очищены');

//       // 4. Удаляем аккаунт из Firebase Auth.
//       // Если прошло много времени с последнего входа — Firebase потребует
//       // re-authentication. В этом случае выходим из аккаунта.
//       await user.delete();
//       _log.i('deleteAccount: Auth аккаунт удалён ($uid)');

//       emit(state.copyWith(status: ProfileSettingsStatus.signedOut));
//     } catch (e) {
//       _log.e('deleteAccount: ошибка', error: e);
//       // Если Firebase требует повторной авторизации (requires-recent-login),
//       // просто выходим из аккаунта — данные в Firestore уже удалены.
//       try {
//         await _auth.signOut();
//       } catch (_) {}
//       emit(state.copyWith(status: ProfileSettingsStatus.signedOut));
//     }
//   }
// }

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../core/services/firebase_service.dart';
import '../../../data/auth/auth_repository.dart';
import '../../../data/onboarding/onboarding_repository.dart';
import '../../../data/profile/profile_repository.dart';
import '../../favorites/global_favorites_notifier.dart';
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
  final _log = Logger();

  bool get isAuthenticated => _auth.isAuthenticated;

  Future<void> load() async {
    emit(state.copyWith(status: ProfileSettingsStatus.loading));
    final raw = await _profile.rawData() ?? const {};
    final interests = await _onboarding.getSavedInterests();
    emit(state.copyWith(
      status: ProfileSettingsStatus.ready,
      name: (raw['name'] as String?) ?? '',
      city: (raw['city'] as String?) ?? '',
      gpa: raw['gpa']?.toString() ?? '',
      ielts: raw['ielts']?.toString() ?? '',
      ent: raw['ent']?.toString() ?? '',
      interests: interests,
    ));
  }

  Future<void> updateProfile({
    required String name,
    required String city,
  }) async {
    emit(state.copyWith(status: ProfileSettingsStatus.saving));
    try {
      if (name.isNotEmpty) await _auth.updateDisplayName(name);
      await _profile.updateProfile(name: name, city: city);
      emit(state.copyWith(
        status: ProfileSettingsStatus.saved,
        name: name.isNotEmpty ? name : null,
        city: city.isNotEmpty ? city : null,
      ));
    } catch (e) {
      _log.e('updateProfile', error: e);
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
      emit(state.copyWith(
        status: ProfileSettingsStatus.saved,
        gpa: gpa,
        ielts: ielts,
        ent: ent,
      ));
    } catch (e) {
      _log.e('updateScores', error: e);
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
    } catch (e) {
      _log.e('uploadAvatar', error: e);
      emit(state.copyWith(status: ProfileSettingsStatus.photoError));
    }
  }

  Future<void> reloadInterests() async {
    final interests = await _onboarding.getSavedInterests();
    emit(state.copyWith(interests: interests));
  }

  /// Выход из аккаунта.
  /// Порядок важен: сначала очищаем локальное, потом идём в сеть.
  Future<void> signOut() async {
    try {
      final uid = _firebase.currentUid;

      // Сразу убираем лайки из UI
      GlobalFavoritesNotifier.instance.clear();

      // Удаляем FCM токен из Firestore
      if (uid != null) {
        await _firebase.removeFcmToken(uid);
      }

      await _auth.signOut();
      emit(state.copyWith(status: ProfileSettingsStatus.signedOut));
    } catch (e) {
      _log.e('signOut', error: e);
      // При ошибке всё равно выходим
      try {
        await _auth.signOut();
      } catch (_) {}
      emit(state.copyWith(status: ProfileSettingsStatus.signedOut));
    }
  }

  /// Полное удаление аккаунта.
  Future<void> deleteAccount() async {
    emit(state.copyWith(status: ProfileSettingsStatus.saving));
    try {
      final user = _firebase.auth.currentUser;
      if (user == null) {
        emit(state.copyWith(status: ProfileSettingsStatus.saveError));
        return;
      }
      final uid = user.uid;

      // 1. Лайки — сразу
      GlobalFavoritesNotifier.instance.clear();

      // 2. Firestore: профиль + избранные + FCM токен
      await _firebase.deleteUserData(uid);
      _log.i('deleteAccount: Firestore очищен ($uid)');

      // 3. SharedPreferences
      await _onboarding.clearAll();
      _log.i('deleteAccount: локальные данные очищены');

      // 4. Firebase Auth
      await user.delete();
      _log.i('deleteAccount: Auth аккаунт удалён ($uid)');

      emit(state.copyWith(status: ProfileSettingsStatus.signedOut));
    } catch (e) {
      _log.e('deleteAccount', error: e);
      // requires-recent-login или любая другая ошибка — всё равно выходим
      GlobalFavoritesNotifier.instance.clear();
      try {
        await _auth.signOut();
      } catch (_) {}
      emit(state.copyWith(status: ProfileSettingsStatus.signedOut));
    }
  }
}