import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_repository.dart';
import '../../../data/favorites/favorites_repository.dart';
import '../../../data/profile/profile_repository.dart';
import '../../../data/university/university_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    required UniversityRepository universityRepository,
    required FavoritesRepository favoritesRepository,
  })  : _auth = authRepository,
        _profile = profileRepository,
        _universities = universityRepository,
        _favorites = favoritesRepository,
        super(const ProfileState());

  final AuthRepository _auth;
  final ProfileRepository _profile;
  final UniversityRepository _universities;
  final FavoritesRepository _favorites;

  Future<void> load() async {
    if (!_auth.isAuthenticated) {
      emit(state.copyWith(status: ProfileStatus.unauthenticated));
      return;
    }
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final raw = await _profile.rawData() ?? const {};
      final favoriteIds = await _favorites.load();
      final allUnis = await _universities.getAll();
      emit(
        state.copyWith(
          status: ProfileStatus.ready,
          name: (raw['name'] as String?) ?? '',
          city: (raw['city'] as String?) ?? '',
          photoUrl: _auth.currentPhotoUrl,
          gpa: raw['gpa'] is num ? raw['gpa'] as num : null,
          ielts: raw['ielts'] is num ? raw['ielts'] as num : null,
          ent: raw['ent'] is num ? raw['ent'] as num : null,
          favorites:
              allUnis.where((u) => favoriteIds.contains(u.id)).toList(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    emit(state.copyWith(status: ProfileStatus.unauthenticated));
  }
}
