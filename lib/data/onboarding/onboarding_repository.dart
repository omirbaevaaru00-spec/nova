abstract class OnboardingRepository {
  /// Возвращает true, если пользователь уже прошёл онбоардинг.
  Future<bool> isOnboardingCompleted();

  /// Помечает онбоардинг как пройденный.
  Future<void> completeOnboarding();

  /// Возвращает сохранённые ключи интересов.
  Future<List<String>> getSavedInterests();

  /// Сохраняет ключи интересов.
  Future<void> saveInterests(List<String> interestKeys);
}