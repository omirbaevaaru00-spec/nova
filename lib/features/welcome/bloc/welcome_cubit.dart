import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/localization/locale_controller.dart';
import 'welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit()
      : super(WelcomeState(locale: LocaleController.instance.locale));

  /// Циклическое переключение языка: ru → kk → en → ru → ...
  void toggleLocale() {
    final next = switch (state.locale.languageCode) {
      'ru' => const Locale('kk'),
      'kk' => const Locale('en'),
      _ => const Locale('ru'),
    };
    LocaleController.instance.setLocale(next);
    emit(state.copyWith(locale: next));
  }
}
