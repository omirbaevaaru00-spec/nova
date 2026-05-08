import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/university/university_repository.dart';
import 'university_detail_state.dart';

class UniversityDetailCubit extends Cubit<UniversityDetailState> {
  UniversityDetailCubit({required UniversityRepository universityRepository})
      : _repository = universityRepository,
        super(const UniversityDetailState());

  final UniversityRepository _repository;

  Future<void> load(String id) async {
    emit(state.copyWith(status: UniversityDetailStatus.loading));
    final uni = await _repository.getById(id);
    emit(
      uni == null
          ? state.copyWith(status: UniversityDetailStatus.notFound)
          : state.copyWith(
              status: UniversityDetailStatus.ready,
              university: uni,
            ),
    );
  }

  void selectTab(UniversityDetailTab tab) =>
      emit(state.copyWith(tab: tab));
}
