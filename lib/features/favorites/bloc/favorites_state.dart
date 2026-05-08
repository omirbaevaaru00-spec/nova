import 'package:equatable/equatable.dart';

import '../../../data/university/university_model.dart';

enum FavoritesStatus { initial, loading, ready, failure }

class FavoritesState extends Equatable {
  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.items = const [],
    this.error,
  });

  final FavoritesStatus status;
  final List<University> items;
  final String? error;

  FavoritesState copyWith({
    FavoritesStatus? status,
    List<University>? items,
    String? error,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, items, error];
}
