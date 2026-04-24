import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FavoritesNotifier extends ValueNotifier<Set<String>> {
  static final FavoritesNotifier instance = FavoritesNotifier._();
  FavoritesNotifier._() : super({});

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  // ── Загрузить избранное из Firestore ──────────────────────
  Future<void> load() async {
    if (!isLoggedIn || _uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .get();
      if (doc.exists) {
        final List favs = doc.data()?['favorites'] ?? [];
        value = Set<String>.from(favs.map((e) => e.toString()));
      }
    } catch (_) {}
  }

  bool isFavorite(String id) => value.contains(id);

  // ── Переключить лайк ──────────────────────────────────────
  // Возвращает true если добавлено, false если удалено
  // Выбрасывает NeedsAuthException если не авторизован
  Future<bool> toggle(String universityId) async {
    if (!isLoggedIn || _uid == null) {
      throw NeedsAuthException();
    }

    final updated = Set<String>.from(value);
    final bool added;

    if (updated.contains(universityId)) {
      updated.remove(universityId);
      added = false;
    } else {
      updated.add(universityId);
      added = true;
    }

    value = updated;

    // Сохраняем в Firestore
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .update({'favorites': updated.toList()});
    } catch (_) {
      // Откатываем если ошибка
      value = Set<String>.from(value)
        ..remove(universityId);
    }

    return added;
  }

  // ── Сбросить при выходе ───────────────────────────────────
  void clear() {
    value = {};
  }
}

class NeedsAuthException implements Exception {}