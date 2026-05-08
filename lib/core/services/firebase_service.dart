import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../firebase_options.dart';

/// Единая точка доступа к Firebase.
///
/// Весь остальной код приложения работает только через этот сервис —
/// никто больше не импортирует `firebase_auth`, `cloud_firestore`,
/// `firebase_storage` или `google_sign_in` напрямую.
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> init() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }

  // ── Auth shortcuts ───────────────────────────────────────────
  User? get currentUser => auth.currentUser;
  String? get currentUid => auth.currentUser?.uid;
  bool get isAuthenticated => auth.currentUser != null;

  Stream<User?> authStateChanges() => auth.authStateChanges();

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) {
    return auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> sendPasswordReset(String email) {
    return auth.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> signInWithGoogle() async {
    final account = await googleSignIn.signIn();
    if (account == null) {
      throw FirebaseAuthException(
        code: 'sign-in-cancelled',
        message: 'Google sign-in was cancelled by the user',
      );
    }
    final googleAuth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await Future.wait([
      auth.signOut(),
      googleSignIn.signOut(),
    ]);
  }

  // ── Firestore shortcuts ──────────────────────────────────────
  DocumentReference<Map<String, dynamic>> userDoc(String uid) {
    return firestore.collection('users').doc(uid);
  }

  Future<void> setUserField(String uid, String field, dynamic value) {
    return userDoc(uid).set({field: value}, SetOptions(merge: true));
  }

  Future<void> mergeUserDoc(String uid, Map<String, dynamic> data) {
    return userDoc(uid).set(data, SetOptions(merge: true));
  }

  /// Метка серверного времени Firestore — без утечки `FieldValue`.
  Object get serverTimestamp => FieldValue.serverTimestamp();

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final snap = await userDoc(uid).get();
    return snap.data();
  }

  // ── Phone OTP ────────────────────────────────────────────────
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential credential) verificationCompleted,
    required void Function(FirebaseAuthException error) verificationFailed,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
  }) {
    return auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithPhoneCredential(
    PhoneAuthCredential credential,
  ) {
    return auth.signInWithCredential(credential);
  }

  Future<void> updateDisplayName(String name) async {
    await currentUser?.updateDisplayName(name);
  }

  Future<void> updatePhotoUrl(String url) async {
    await currentUser?.updatePhotoURL(url);
  }

  /// Загружает аватар в Storage и возвращает download URL.
  Future<String> uploadAvatar(File file) async {
    final uid = currentUid;
    if (uid == null) {
      throw StateError('Cannot upload avatar without authenticated user');
    }
    final ref = storage.ref().child('avatars/$uid.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}
