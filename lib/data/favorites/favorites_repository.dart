abstract class FavoritesRepository {
  Future<Set<String>> load();
  Future<Set<String>> toggle(String universityId);
}

/// Бросается, когда юзер не залогинен и пытается лайкнуть.
class NotAuthenticatedException implements Exception {
  const NotAuthenticatedException();
}
