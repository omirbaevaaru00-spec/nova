import 'package:flutter_bloc/flutter_bloc.dart';

import 'saved_searches_state.dart';

class SavedSearchesCubit extends Cubit<SavedSearchesState> {
  SavedSearchesCubit() : super(const SavedSearchesState());

  Future<void> load() async {
    emit(state.copyWith(status: SavedSearchesStatus.loading));
    // TODO: подключить SavedSearchesRepository (Firestore).
    emit(
      state.copyWith(
        status: SavedSearchesStatus.ready,
        items: const [
          'Алматы • IT • English',
          'Астана • Business • Scholarship',
          'Online • Design',
        ],
      ),
    );
  }
}
