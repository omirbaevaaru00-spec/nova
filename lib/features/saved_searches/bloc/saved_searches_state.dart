import 'package:equatable/equatable.dart';

enum SavedSearchesStatus { initial, loading, ready, failure }

class SavedSearchesState extends Equatable {
  const SavedSearchesState({
    this.status = SavedSearchesStatus.initial,
    this.items = const [],
  });

  final SavedSearchesStatus status;
  final List<String> items;

  SavedSearchesState copyWith({
    SavedSearchesStatus? status,
    List<String>? items,
  }) {
    return SavedSearchesState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [status, items];
}
