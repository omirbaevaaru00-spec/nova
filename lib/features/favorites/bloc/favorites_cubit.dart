import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/favorites/favorites_repository.dart';
import '../../../data/university/university_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required FavoritesRepository favoritesRepository,
    required UniversityRepository universityRepository,
  })  : _favorites = favoritesRepository,
        _universities = universityRepository,
        super(const FavoritesState());

  final FavoritesRepository _favorites;
  final UniversityRepository _universities;

  Future<void> load() async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    try {
      final ids = await _favorites.load();
      final all = await _universities.getAll();
      emit(
        state.copyWith(
          status: FavoritesStatus.ready,
          items: all.where((u) => ids.contains(u.id)).toList(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: FavoritesStatus.failure, error: e.toString()),
      );
    }
  }
}
