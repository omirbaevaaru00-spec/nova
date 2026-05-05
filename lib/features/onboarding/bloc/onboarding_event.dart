import 'package:equatable/equatable.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

/// Загрузить ранее сохранённые интересы (если есть).
class OnboardingStarted extends OnboardingEvent {
  const OnboardingStarted();
}

/// Тап по чипу интереса.
class OnboardingInterestToggled extends OnboardingEvent {
  final int index;

  const OnboardingInterestToggled(this.index);

  @override
  List<Object?> get props => [index];
}

/// Нажатие "Далее" — сохранить интересы и пометить онбоардинг как пройденный.
class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}

/// Нажатие "Пропустить" — пометить онбоардинг как пройденный без сохранения интересов.
class OnboardingSkipped extends OnboardingEvent {
  const OnboardingSkipped();
}