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
    if (!isLoggedIn || _uid == null) {
      clear(); // Если не залогинен — чистим на всякий случай
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .get();
      if (doc.exists) {
        final List favs = doc.data()?['favorites'] ?? [];
        value = Set<String>.from(favs.map((e) => e.toString()));
      } else {
        value = {};
      }
    } catch (_) {}
  }

  bool isFavorite(String id) => value.contains(id);

  // ── Переключить лайк ──────────────────────────────────────
  Future<bool> toggle(String universityId) async {
    if (!isLoggedIn || _uid == null) {
      throw NeedsAuthException();
    }

    // ✅ Сохраняем снапшот ДО изменения для правильного отката
    final previous = Set<String>.from(value);
    final updated = Set<String>.from(value);
    final bool added;

    if (updated.contains(universityId)) {
      updated.remove(universityId);
      added = false;
    } else {
      updated.add(universityId);
      added = true;
    }

    // Оптимистичное обновление UI
    value = updated;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid)
          .update({'favorites': updated.toList()});
    } catch (_) {
      // ✅ Откатываем к реальному предыдущему состоянию
      value = previous;
      rethrow;
    }

    return added;
  }

  // ── Сбросить при выходе ───────────────────────────────────
  void clear() {
    value = {};
  }
}

class NeedsAuthException implements Exception {}