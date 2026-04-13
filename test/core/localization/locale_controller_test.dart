import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stiky/core/localization/locale_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    LocaleController.resetForTest();
    SharedPreferences.setMockInitialValues({});
  });

  group('LocaleController — init()', () {
    test('нет сохранённого языка → русский по умолчанию', () async {
      SharedPreferences.setMockInitialValues({});
      await LocaleController.instance.init();
      expect(LocaleController.instance.locale, const Locale('ru'));
    });

    test('сохранён kk → восстанавливает казахский', () async {
      SharedPreferences.setMockInitialValues({'app_language': 'kk'});
      await LocaleController.instance.init();
      expect(LocaleController.instance.locale, const Locale('kk'));
    });

    test('сохранён неподдерживаемый fr → русский по умолчанию', () async {
      SharedPreferences.setMockInitialValues({'app_language': 'fr'});
      await LocaleController.instance.init();
      expect(LocaleController.instance.locale, const Locale('ru'));
    });
  });

  group('LocaleController — setLocale()', () {
    test('смена на kk → locale обновляется', () async {
      SharedPreferences.setMockInitialValues({'app_language': 'ru'});
      await LocaleController.instance.init();
      await LocaleController.instance.setLocale(const Locale('kk'));
      expect(LocaleController.instance.locale, const Locale('kk'));
    });

    test('смена сохраняется в SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({'app_language': 'ru'});
      await LocaleController.instance.init();
      await LocaleController.instance.setLocale(const Locale('kk'));
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_language'), 'kk');
    });

    test('повторная установка того же языка → notifyListeners не вызывается', () async {
      SharedPreferences.setMockInitialValues({'app_language': 'ru'});
      await LocaleController.instance.init();
      int notifyCount = 0;
      LocaleController.instance.addListener(() => notifyCount++);
      await LocaleController.instance.setLocale(const Locale('ru'));
      expect(notifyCount, 0);
    });
  });
}