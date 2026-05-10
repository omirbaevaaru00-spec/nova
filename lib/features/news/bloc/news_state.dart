import 'package:equatable/equatable.dart';

enum NewsStatus { initial, loading, ready, failure }

class NewsItem extends Equatable {
  const NewsItem({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  List<Object?> get props => [title, subtitle];
}

class NewsState extends Equatable {
  const NewsState({this.status = NewsStatus.initial, this.items = const []});

  final NewsStatus status;
  final List<NewsItem> items;

  NewsState copyWith({NewsStatus? status, List<NewsItem>? items}) {
    return NewsState(
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [status, items];
}
