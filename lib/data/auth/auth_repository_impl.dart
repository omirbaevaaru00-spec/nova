import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../core/services/firebase_service.dart';
import 'auth_failure.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._firebase);

  final FirebaseService _firebase;

  Future<T> _wrap<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(authFailureFromCode(e.code));
    } on AuthException {
      rethrow;
    } catch (_) {
      throw const AuthException(AuthFailure.unknown);
    }
  }

  @override
  bool get isAuthenticated => _firebase.isAuthenticated;

  @override
  String? get currentUid => _firebase.currentUid;

  @override
  String? get currentEmail => _firebase.currentUser?.email;

  @override
  String? get currentPhotoUrl => _firebase.currentUser?.photoURL;

  @override
  Stream<bool> authStateChanges() =>
      _firebase.authStateChanges().map((user) => user != null);

  @override
  Future<void> updateDisplayName(String name) =>
      _firebase.updateDisplayName(name);

  @override
  Future<void> updatePhotoUrl(String url) =>
      _firebase.updatePhotoUrl(url);

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _wrap(
      () => _firebase.signInWithEmail(email: email, password: password),
    );
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return _wrap(
      () => _firebase.signUpWithEmail(email: email, password: password),
    );
  }

  @override
  Future<GoogleSignInResult> signInWithGoogle() async {
    await _wrap(_firebase.signInWithGoogle);
    final uid = _firebase.currentUid;
    if (uid == null) return GoogleSignInResult.needsProfileSetup;
    final data = await _firebase.getUserData(uid);
    return data == null
        ? GoogleSignInResult.needsProfileSetup
        : GoogleSignInResult.existing;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _firebase.sendPasswordReset(email);
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(
        e.code == 'user-not-found'
            ? AuthFailure.emailNotFound
            : authFailureFromCode(e.code),
      );
    } catch (_) {
      throw const AuthException(AuthFailure.unknown);
    }
  }

  @override
  Future<void> signOut() => _firebase.signOut();

  @override
  Future<EmailExistence> probeEmail(String email) async {
    try {
      await _firebase.signInWithEmail(
        email: email,
        password: '________probe________',
      );
      return EmailExistence.exists;
    } on fb.FirebaseAuthException catch (e) {
      return switch (e.code) {
        'user-not-found' || 'invalid-credential' => EmailExistence.notFound,
        'wrong-password' ||
        'INVALID_LOGIN_CREDENTIALS' =>
          EmailExistence.existsWrongPassword,
        _ => EmailExistence.notFound,
      };
    }
  }

  @override
  Future<void> verifyPhone({
    required String phoneNumber,
    required void Function(PhoneVerification event) onEvent,
  }) async {
    await _firebase.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {
        await _firebase.signInWithPhoneCredential(credential);
        onEvent(const PhoneAutoCompleted());
      },
      verificationFailed: (e) => onEvent(
        PhoneVerificationError(authFailureFromCode(e.code)),
      ),
      codeSent: (id, _) => onEvent(SmsCodeSent(id)),
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  @override
  Future<void> confirmSmsCode({
    required String verificationId,
    required String smsCode,
  }) {
    return _wrap(() async {
      final credential = fb.PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _firebase.signInWithPhoneCredential(credential);
    });
  }
}
