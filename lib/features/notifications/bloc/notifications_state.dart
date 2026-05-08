import 'package:equatable/equatable.dart';

enum NotificationsStatus { initial, loading, ready, failure }

class NotificationsState extends Equatable {
  const NotificationsState({
    this.status = NotificationsStatus.initial,
    this.items = const [],
  });

  final NotificationsStatus status;
  final List<String> items;

  NotificationsState copyWith({
    NotificationsStatus? status,
    List<String>? items,
  }) {
    return NotificationsState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [status, items];
}
