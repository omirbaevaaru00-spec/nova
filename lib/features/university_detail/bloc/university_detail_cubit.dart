import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../data/news/university_news_repository.dart';
import '../../../data/programs/university_program_repository.dart';
import '../../../data/university/university_repository.dart';
import 'university_detail_state.dart';

class UniversityDetailCubit extends Cubit<UniversityDetailState> {
  UniversityDetailCubit({
    required UniversityRepository universityRepository,
    required UniversityProgramRepository programRepository,
    required UniversityNewsRepository newsRepository,
  })  : _university = universityRepository,
        _programs = programRepository,
        _news = newsRepository,
        super(const UniversityDetailState());

  final UniversityRepository _university;
  final UniversityProgramRepository _programs;
  final UniversityNewsRepository _news;
  final _log = Logger();

  /// Загружает основные данные университета.
  Future<void> load(String id) async {
    emit(state.copyWith(status: UniversityDetailStatus.loading));
    try {
      final uni = await _university.getById(id);
      if (uni == null) {
        emit(state.copyWith(status: UniversityDetailStatus.notFound));
        return;
      }
      emit(state.copyWith(
        status: UniversityDetailStatus.ready,
        university: uni,
      ));
    } catch (e, st) {
      _log.e('load($id) failed', error: e, stackTrace: st);
      emit(state.copyWith(
        status: UniversityDetailStatus.notFound,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Переключает вкладку и при первом открытии загружает данные.
  Future<void> selectTab(UniversityDetailTab tab) async {
    emit(state.copyWith(tab: tab));
    final id = state.university?.id;
    if (id == null) return;

    if (tab == UniversityDetailTab.programs && state.programs.isEmpty) {
      await _loadPrograms(id);
    }
    if (tab == UniversityDetailTab.news && state.news.isEmpty) {
      await _loadNews(id);
    }
  }

  Future<void> _loadPrograms(String universityId) async {
    emit(state.copyWith(programsLoading: true));
    try {
      final list = await _programs.getPrograms(universityId);
      emit(state.copyWith(programs: list, programsLoading: false));
    } catch (e, st) {
      _log.e('_loadPrograms($universityId) failed', error: e, stackTrace: st);
      emit(state.copyWith(
        programsLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _loadNews(String universityId) async {
    emit(state.copyWith(newsLoading: true));
    try {
      final list = await _news.getNews(universityId);
      emit(state.copyWith(news: list, newsLoading: false));
    } catch (e, st) {
      _log.e('_loadNews($universityId) failed', error: e, stackTrace: st);
      emit(state.copyWith(
        newsLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }
}