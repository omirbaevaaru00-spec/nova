/// Доменные ошибки аутентификации. Не утекают типы Firebase в UI.
enum AuthFailure {
  userNotFound,
  emailNotFound,
  wrongPassword,
  invalidEmail,
  userDisabled,
  tooManyRequests,
  invalidCredential,
  weakPassword,
  emailInUse,
  networkError,
  invalidPhone,
  quotaExceeded,
  sessionExpired,
  invalidVerificationCode,
  googleCancelled,
  unknown,
}

class AuthException implements Exception {
  const AuthException(this.failure);
  final AuthFailure failure;
  @override
  String toString() => 'AuthException($failure)';
}

/// Преобразует код ошибки FirebaseAuth в [AuthFailure]. Изолировано от UI.
AuthFailure authFailureFromCode(String code) {
  return switch (code) {
    'user-not-found' => AuthFailure.userNotFound,
    'wrong-password' => AuthFailure.wrongPassword,
    'invalid-email' => AuthFailure.invalidEmail,
    'user-disabled' => AuthFailure.userDisabled,
    'too-many-requests' => AuthFailure.tooManyRequests,
    'invalid-credential' || 'INVALID_LOGIN_CREDENTIALS' =>
      AuthFailure.invalidCredential,
    'weak-password' => AuthFailure.weakPassword,
    'email-already-in-use' => AuthFailure.emailInUse,
    'network-request-failed' => AuthFailure.networkError,
    'invalid-phone-number' => AuthFailure.invalidPhone,
    'quota-exceeded' => AuthFailure.quotaExceeded,
    'session-expired' => AuthFailure.sessionExpired,
    'invalid-verification-code' => AuthFailure.invalidVerificationCode,
    'sign-in-cancelled' => AuthFailure.googleCancelled,
    _ => AuthFailure.unknown,
  };
}
