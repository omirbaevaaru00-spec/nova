abstract class OnboardnigRepository {
  /// Проверяет, авторизован ли пользователь.
  Future<bool> alreadyOnboarded();

  Future<void> onboarded();
}