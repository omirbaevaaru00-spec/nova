import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Экран политики конфиденциальности.
/// Открывается из экрана регистрации.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor =
        isDark ? AppColors.textInverse : AppColors.textPrimary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: textColor,
            ),
          ),
          title: Text(
            'Политика конфиденциальности',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
          children: [
            _buildHeader('Sticky — Политика конфиденциальности', textColor),
            _buildDate('Последнее обновление: январь 2025', isDark),
            _buildSection(
              '1. Общие положения',
              'Настоящая Политика конфиденциальности описывает, как приложение Sticky («Приложение», «мы», «нас») собирает, использует и защищает персональные данные пользователей («вы», «пользователь») на территории Республики Казахстан.\n\nИспользуя Приложение, вы соглашаетесь с условиями настоящей Политики. Если вы не согласны — пожалуйста, прекратите использование Приложения.',
              textColor,
              isDark,
            ),
            _buildSection(
              '2. Какие данные мы собираем',
              '2.1. Данные, которые вы предоставляете:\n• Адрес электронной почты (при регистрации)\n• Имя и город (при заполнении профиля)\n• Академические баллы: GPA, IELTS, ЕНТ\n• Интересы и предпочтения (квиз)\n• Отзывы об университетах\n• Фотография профиля (опционально)\n\n2.2. Данные, собираемые автоматически:\n• Токен push-уведомлений (Firebase FCM)\n• Данные об устройстве и ОС (для диагностики)\n• Анонимная статистика использования',
              textColor,
              isDark,
            ),
            _buildSection(
              '3. Как мы используем данные',
              '• Персонализация подборки университетов\n• Отображение вашего профиля\n• Отправка push-уведомлений о новостях\n• Улучшение качества Приложения\n• Поддержка пользователей\n\nМы не продаём и не передаём ваши данные третьим лицам в коммерческих целях.',
              textColor,
              isDark,
            ),
            _buildSection(
              '4. Хранение данных',
              'Данные хранятся в Firebase (Google LLC) на серверах с соблюдением стандартов безопасности ISO 27001. Данные хранятся на протяжении всего времени использования Приложения.\n\nПри удалении аккаунта все ваши персональные данные удаляются в течение 30 дней.',
              textColor,
              isDark,
            ),
            _buildSection(
              '5. Ваши права',
              '• Доступ к вашим данным в любое время\n• Исправление неточных данных\n• Удаление аккаунта и всех данных\n• Отказ от push-уведомлений в настройках устройства\n\nДля реализации прав обратитесь через Telegram-бот поддержки.',
              textColor,
              isDark,
            ),
            _buildSection(
              '6. Cookies и аналитика',
              'Приложение использует Firebase Analytics для анонимной статистики. Данные аналитики не содержат персональной информации и используются только для улучшения Приложения.',
              textColor,
              isDark,
            ),
            _buildSection(
              '7. Безопасность',
              'Мы применяем технические и организационные меры для защиты данных:\n• Шифрование передачи данных (HTTPS/TLS)\n• Правила безопасности Firebase (Firestore Security Rules)\n• Ограниченный доступ сотрудников к данным',
              textColor,
              isDark,
            ),
            _buildSection(
              '8. Несовершеннолетние',
              'Приложение предназначено для пользователей от 14 лет. Мы не собираем намеренно данные детей младше 14 лет. Если вам стало известно о таком случае — сообщите нам.',
              textColor,
              isDark,
            ),
            _buildSection(
              '9. Изменения политики',
              'Мы можем обновлять Политику. Об изменениях уведомляем через push-уведомление или при следующем входе в Приложение. Дата последнего обновления указана вверху документа.',
              textColor,
              isDark,
            ),
            _buildSection(
              '10. Контакты',
              'По вопросам конфиденциальности:\nTelegram: @sticky_support_bot\n\nОтвечаем в течение 2–4 рабочих часов.',
              textColor,
              isDark,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.brandAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.brandAccent.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                '⚠️ Дисклеймер\n\nПриложение Sticky предоставляет информацию об университетах Казахстана в образовательных целях. Данные о вузах носят справочный характер. Актуальные условия поступления уточняйте непосредственно в приёмной комиссии. Sticky не несёт ответственности за решения, принятые на основе данных Приложения.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark
                      ? AppColors.textInverse.withValues(alpha: 0.8)
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: color,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildDate(String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildSection(String title, String body, Color textColor, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDark
                  ? AppColors.textInverse.withValues(alpha: 0.8)
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}