import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Экран выбора языка (онбординг).
///
/// Позволяет пользователю выбрать язык интерфейса.
/// Выбор сохраняется через [LocaleController].
class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.chooseLanguage)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              l10n.chooseLanguage,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _LanguageTile(
              title: 'Қазақша',
              subtitle: 'Интерфейс қазақ тілінде',
              locale: const Locale('kk'),
              onSelected: () => context.go('/quiz'),
            ),
            const SizedBox(height: 16),
            _LanguageTile(
              title: 'Русский',
              subtitle: 'Интерфейс на русском языке',
              locale: const Locale('ru'),
              onSelected: () => context.go('/quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.subtitle,
    required this.locale,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final Locale locale;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: LocaleController.instance,
      builder: (context, _) {
        final isActive = LocaleController.instance.locale == locale;
        return InkWell(
          onTap: () async {
            await LocaleController.instance.setLocale(locale);
            onSelected();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                width: isActive ? 2 : 1,
              ),
              color: isActive
                  ? theme.colorScheme.primary.withOpacity(0.07)
                  : Colors.transparent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(subtitle, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        );
      },
    );
  }
}