import 'package:equatable/equatable.dart';

import '../../../data/university/university_model.dart';

enum UniversityDetailStatus { initial, loading, ready, notFound }

enum UniversityDetailTab { description, programs, news }

class UniversityDetailState extends Equatable {
  const UniversityDetailState({
    this.status = UniversityDetailStatus.initial,
    this.university,
    this.tab = UniversityDetailTab.description,
  });

  final UniversityDetailStatus status;
  final University? university;
  final UniversityDetailTab tab;

  UniversityDetailState copyWith({
    UniversityDetailStatus? status,
    University? university,
    UniversityDetailTab? tab,
  }) {
    return UniversityDetailState(
      status: status ?? this.status,
      university: university ?? this.university,
      tab: tab ?? this.tab,
    );
  }

  @override
  List<Object?> get props => [status, university, tab];
}
