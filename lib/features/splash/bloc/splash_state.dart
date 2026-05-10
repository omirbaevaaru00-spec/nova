import 'package:equatable/equatable.dart';

enum SplashStatus { initial, shouldOnboard, shouldLogin, authenticated, failure }

class SplashState extends Equatable {
  const SplashState({this.status = SplashStatus.initial, this.error});

  final SplashStatus status;
  final String? error;

  SplashState copyWith({SplashStatus? status, String? error}) {
    return SplashState(
      status: status ?? this.status,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}
