import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/onboarding/onboarding_repository.dart';
import '../../../data/profile/profile_model.dart';
import '../../../data/profile/profile_repository.dart';
import '../../../data/university/university_model.dart';
import '../../../data/university/university_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required UniversityRepository universityRepository,
    required OnboardingRepository onboardingRepository,
    required ProfileRepository profileRepository,
  })  : _universities = universityRepository,
        _onboarding = onboardingRepository,
        _profile = profileRepository,
        super(const HomeState());

  final UniversityRepository _universities;
  final OnboardingRepository _onboarding;
  final ProfileRepository _profile;

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final all = await _universities.getAll();
      final interests = (await _onboarding.getSavedInterests()).toSet();
      final profile = await _profile.load();
      emit(
        state.copyWith(
          status: HomeStatus.ready,
          feed: _rankFeed(all, interests, profile),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, error: e.toString()));
    }
  }

  List<University> _rankFeed(
    List<University> all,
    Set<String> interests,
    UserProfile profile,
  ) {
    if (interests.isEmpty &&
        profile.gpa == null &&
        profile.ielts == null &&
        profile.ent == null) {
      return all;
    }
    final scored = all.map((u) => (u, _score(u, interests, profile))).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));
    return scored.map((e) => e.$1).toList();
  }

  int _score(University u, Set<String> interests, UserProfile profile) {
    var score = 0;
    if (interests.isNotEmpty && u.tags.isNotEmpty) {
      score += u.tags.where(interests.contains).length * 10;
    }
    if (profile.ent != null && u.minEnt != null && profile.ent! >= u.minEnt!) {
      score += 8;
    }
    if (profile.gpa != null && u.minGpa != null && profile.gpa! >= u.minGpa!) {
      score += 5;
    }
    if (profile.ielts != null &&
        u.minIelts != null &&
        profile.ielts! >= u.minIelts!) {
      score += 5;
    }
    return score;
  }
}
