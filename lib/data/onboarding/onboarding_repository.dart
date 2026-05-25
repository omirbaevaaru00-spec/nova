// abstract class OnboardingRepository {
//   /// Возвращает true, если пользователь уже прошёл онбоардинг.
//   Future<bool> isOnboardingCompleted();

//   /// Помечает онбоардинг как пройденный.
//   Future<void> completeOnboarding();

//   /// Возвращает сохранённые ключи интересов.
//   Future<List<String>> getSavedInterests();

//   /// Сохраняет ключи интересов.
//   Future<void> saveInterests(List<String> interestKeys);
// }

/// Репозиторий онбординга.
/// Хранит состояние прохождения квиза и выбранные интересы.
abstract class OnboardingRepository {
  /// Возвращает true, если пользователь уже прошёл онбординг.
  Future<bool> isOnboardingCompleted();

  /// Помечает онбординг как пройденный.
  Future<void> completeOnboarding();

  /// Возвращает сохранённые ключи интересов.
  Future<List<String>> getSavedInterests();

  /// Сохраняет ключи интересов.
  Future<void> saveInterests(List<String> interestKeys);

  /// Полностью очищает все локальные данные онбординга.
  /// Вызывается при удалении аккаунта.
  Future<void> clearAll();
}