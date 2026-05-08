import '../../data/auth/auth_failure.dart';
import '../../l10n/generated/app_localizations.dart';

/// Локализует [AuthFailure] для UI.
String localizeAuthFailure(AuthFailure failure, AppLocalizations l10n) {
  return switch (failure) {
    AuthFailure.userNotFound => l10n.errorUserNotFound,
    AuthFailure.emailNotFound => l10n.errorEmailNotFound,
    AuthFailure.wrongPassword => l10n.errorWrongPassword,
    AuthFailure.invalidEmail => l10n.errorInvalidEmail,
    AuthFailure.userDisabled => l10n.errorUserDisabled,
    AuthFailure.tooManyRequests => l10n.errorTooManyRequests,
    AuthFailure.invalidCredential => l10n.errorInvalidCredential,
    AuthFailure.weakPassword => l10n.errorWeakPassword,
    AuthFailure.emailInUse => l10n.errorEmailInUse,
    AuthFailure.networkError => l10n.errorNetwork,
    AuthFailure.invalidPhone => l10n.errorInvalidPhone,
    AuthFailure.quotaExceeded => l10n.errorQuotaExceeded,
    AuthFailure.sessionExpired => l10n.errorTooManyRequests,
    AuthFailure.invalidVerificationCode => l10n.phoneOtpInvalidCode,
    AuthFailure.googleCancelled => l10n.googleError,
    AuthFailure.unknown => l10n.errorGeneric,
  };
}
