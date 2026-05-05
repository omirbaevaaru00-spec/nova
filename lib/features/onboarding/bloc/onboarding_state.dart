import 'package:equatable/equatable.dart';

enum OnboardingStatus {
  initial,
  loading,
  ready,
  saving,
  finished,
  failure,
}

class OnboardingState extends Equatable {
  final OnboardingStatus status;
  final Set<int> selectedIndexes;
  final String? errorMessage;

  const OnboardingState({
    this.status = OnboardingStatus.initial,
    this.selectedIndexes = const {},
    this.errorMessage,
  });

  OnboardingState copyWith({
    OnboardingStatus? status,
    Set<int>? selectedIndexes,
    String? errorMessage,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      selectedIndexes: selectedIndexes ?? this.selectedIndexes,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, selectedIndexes, errorMessage];
}