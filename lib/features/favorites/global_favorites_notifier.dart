import 'package:flutter/foundation.dart';

import '../../core/services/firebase_service.dart';
import '../../data/favorites/favorites_repository.dart';
import '../../data/favorites/favorites_repository_impl.dart';

/// Тонкая прослойка над [FavoritesRepository] с реактивным API.
/// Используется кросс-экранно через `ValueListenableBuilder`.
/// Все обращения к Firebase идут только через [FirebaseService].
class GlobalFavoritesNotifier extends ValueNotifier<Set<String>> {
  GlobalFavoritesNotifier._(this._repository) : super(<String>{});

  static final GlobalFavoritesNotifier instance =
      GlobalFavoritesNotifier._(FavoritesRepositoryImpl(FirebaseService.instance));

  final FavoritesRepository _repository;

  bool get isLoggedIn => FirebaseService.instance.isAuthenticated;

  Future<void> load() async {
    if (!isLoggedIn) return;
    value = await _repository.load();
  }

  bool isFavorite(String id) => value.contains(id);

  /// Возвращает `true`, если id был добавлен, и `false` — если удалён.
  /// Бросает [NotAuthenticatedException] для незалогиненных.
  Future<bool> toggle(String universityId) async {
    if (!isLoggedIn) throw const NotAuthenticatedException();
    final wasFavorite = value.contains(universityId);
    value = await _repository.toggle(universityId);
    return !wasFavorite;
  }

  void clear() {
    value = <String>{};
  }
}
