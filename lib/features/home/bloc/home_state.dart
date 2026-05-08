import 'package:equatable/equatable.dart';

import '../../../data/university/university_model.dart';

enum HomeStatus { initial, loading, ready, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.feed = const [],
    this.error,
  });

  final HomeStatus status;
  final List<University> feed;
  final String? error;

  HomeState copyWith({
    HomeStatus? status,
    List<University>? feed,
    String? error,
  }) {
    return HomeState(
      status: status ?? this.status,
      feed: feed ?? this.feed,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, feed, error];
}
