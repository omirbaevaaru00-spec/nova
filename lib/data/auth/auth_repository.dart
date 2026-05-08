import 'auth_failure.dart';

/// Что произошло при верификации номера телефона.
sealed class PhoneVerification {
  const PhoneVerification();
}

class SmsCodeSent extends PhoneVerification {
  const SmsCodeSent(this.verificationId);
  final String verificationId;
}

class PhoneAutoCompleted extends PhoneVerification {
  const PhoneAutoCompleted();
}

class PhoneVerificationError extends PhoneVerification {
  const PhoneVerificationError(this.failure);
  final AuthFailure failure;
}

/// Что произошло при попытке входа по email с заведомо неверным паролем —
/// «зонд», чтобы отличить «нет такого юзера» от «есть, но пароль другой».
enum EmailExistence { notFound, existsWrongPassword, exists }

/// Результат Google sign-in: новый юзер (нужен setup) или старый.
enum GoogleSignInResult { needsProfileSetup, existing }

/// Репозиторий аутентификации поверх FirebaseService.
/// Все ошибки UI получает в виде [AuthException] с типизированным [AuthFailure].
abstract class AuthRepository {
  bool get isAuthenticated;
  String? get currentUid;
  String? get currentEmail;
  String? get currentPhotoUrl;

  /// Стрим логин/логаут изменений: `true` если есть активная сессия.
  Stream<bool> authStateChanges();

  Future<void> signInWithEmail({required String email, required String password});
  Future<void> signUpWithEmail({required String email, required String password});
  Future<GoogleSignInResult> signInWithGoogle();
  Future<void> sendPasswordReset(String email);
  Future<void> signOut();
  Future<void> updateDisplayName(String name);
  Future<void> updatePhotoUrl(String url);

  Future<EmailExistence> probeEmail(String email);

  Future<void> verifyPhone({
    required String phoneNumber,
    required void Function(PhoneVerification event) onEvent,
  });

  Future<void> confirmSmsCode({
    required String verificationId,
    required String smsCode,
  });
}
