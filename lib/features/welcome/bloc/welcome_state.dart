import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class WelcomeState extends Equatable {
  const WelcomeState({required this.locale});

  final Locale locale;

  WelcomeState copyWith({Locale? locale}) =>
      WelcomeState(locale: locale ?? this.locale);

  @override
  List<Object?> get props => [locale];
}
