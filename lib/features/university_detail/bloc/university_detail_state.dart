import 'package:equatable/equatable.dart';

import '../../../data/news/university_news_model.dart';
import '../../../data/programs/university_program_model.dart';
import '../../../data/university/university_model.dart';

enum UniversityDetailStatus { initial, loading, ready, notFound }

enum UniversityDetailTab { description, programs, news }

class UniversityDetailState extends Equatable {
  const UniversityDetailState({
    this.status = UniversityDetailStatus.initial,
    this.university,
    this.tab = UniversityDetailTab.description,
    this.programs = const [],
    this.programsLoading = false,
    this.news = const [],
    this.newsLoading = false,
    this.errorMessage,
  });

  final UniversityDetailStatus status;
  final University? university;
  final UniversityDetailTab tab;

  final List<UniversityProgram> programs;
  final bool programsLoading;

  final List<UniversityNews> news;
  final bool newsLoading;

  final String? errorMessage;

  UniversityDetailState copyWith({
    UniversityDetailStatus? status,
    University? university,
    UniversityDetailTab? tab,
    List<UniversityProgram>? programs,
    bool? programsLoading,
    List<UniversityNews>? news,
    bool? newsLoading,
    String? errorMessage,
  }) {
    return UniversityDetailState(
      status: status ?? this.status,
      university: university ?? this.university,
      tab: tab ?? this.tab,
      programs: programs ?? this.programs,
      programsLoading: programsLoading ?? this.programsLoading,
      news: news ?? this.news,
      newsLoading: newsLoading ?? this.newsLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        university,
        tab,
        programs,
        programsLoading,
        news,
        newsLoading,
        errorMessage,
      ];
}