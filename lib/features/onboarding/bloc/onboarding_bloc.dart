import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stiky/data/onboarding/onboarding_repository.dart';
import 'package:stiky/features/onboarding/bloc/onboarding_event.dart';

import 'onboarding_state.dart';

/// Ключи интересов — устойчивы к смене языка, сохраняются в SharedPreferences.
const List<String> kInterestKeys = [
  'it',
  'medicine',
  'business',
  'grants',
  'design',
  'law',
  'pedagogy',
  'engineering',
  'bachelor',
  'college',
  'master',
];

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final OnboardingRepository _repository;

  OnboardingBloc(this._repository) : super(const OnboardingState()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingInterestToggled>(_onInterestToggled);
    on<OnboardingCompleted>(_onCompleted);
    on<OnboardingSkipped>(_onSkipped);
  }

  Future<void> _onStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.loading));
    try {
      final saved = await _repository.getSavedInterests();
      final selected = <int>{
        for (int i = 0; i < kInterestKeys.length; i++)
          if (saved.contains(kInterestKeys[i])) i,
      };
      emit(
        state.copyWith(
          status: OnboardingStatus.ready,
          selectedIndexes: selected,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: OnboardingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onInterestToggled(
    OnboardingInterestToggled event,
    Emitter<OnboardingState> emit,
  ) {
    final updated = Set<int>.from(state.selectedIndexes);
    if (updated.contains(event.index)) {
      updated.remove(event.index);
    } else {
      updated.add(event.index);
    }
    emit(state.copyWith(selectedIndexes: updated));
  }

  Future<void> _onCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.saving));
    try {
      final keys = state.selectedIndexes.map((i) => kInterestKeys[i]).toList();
      await _repository.saveInterests(keys);
      await _repository.completeOnboarding();
      emit(state.copyWith(status: OnboardingStatus.finished));
    } catch (e) {
      emit(
        state.copyWith(
          status: OnboardingStatus.ready,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onSkipped(
    OnboardingSkipped event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.saving));
    try {
      await _repository.completeOnboarding();
      emit(state.copyWith(status: OnboardingStatus.finished));
    } catch (e) {
      emit(
        state.copyWith(
          status: OnboardingStatus.ready,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
