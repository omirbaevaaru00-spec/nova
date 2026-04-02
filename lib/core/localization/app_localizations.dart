import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const supportedLocales = [
    Locale('ru'),
    Locale('kk'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'ru': {
      'welcomeTitle': 'WELCOME',
      'welcomeSubtitle':
          'Find universities, explore programs\nand choose your future.',
      'continue': 'Продолжить',
      'chooseLanguage': 'Выберите язык',
      'russian': 'Русский',
      'kazakh': 'Қазақша',
      'quizTitle': 'Что тебе интересно?',
      'quizSubtitle': 'Выбери несколько направлений',
    },
    'kk': {
      'welcomeTitle': 'ҚОШ КЕЛДІҢ',
      'welcomeSubtitle':
          'Университеттерді тап,\nбағдарламаларды зертте\nжәне болашағыңды таңда.',
      'continue': 'Жалғастыру',
      'chooseLanguage': 'Тілді таңдаңыз',
      'russian': 'Русский',
      'kazakh': 'Қазақша',
      'quizTitle': 'Саған не қызық?',
      'quizSubtitle': 'Бірнеше бағыт таңда',
    },
  };

  String get welcomeTitle =>
      _localizedValues[locale.languageCode]!['welcomeTitle']!;
  String get welcomeSubtitle =>
      _localizedValues[locale.languageCode]!['welcomeSubtitle']!;
  String get continueText =>
      _localizedValues[locale.languageCode]!['continue']!;
  String get chooseLanguage =>
      _localizedValues[locale.languageCode]!['chooseLanguage']!;
  String get russian => _localizedValues[locale.languageCode]!['russian']!;
  String get kazakh => _localizedValues[locale.languageCode]!['kazakh']!;
  String get quizTitle => _localizedValues[locale.languageCode]!['quizTitle']!;
  String get quizSubtitle =>
      _localizedValues[locale.languageCode]!['quizSubtitle']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ru', 'kk'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}