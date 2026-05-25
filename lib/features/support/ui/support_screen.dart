import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Экран поддержки пользователей.
/// Открывается из настроек при нажатии «Поддержка».
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static const _telegramBotUrl = 'https://t.me/sticky_university_faq_bot';

  // Future<void> _openTelegram(BuildContext context) async {
  //   final uri = Uri.parse(_telegramBotUrl);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     if (!context.mounted) return;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: const Text('Не удалось открыть Telegram'),
  //         backgroundColor: AppColors.danger,
  //         behavior: SnackBarBehavior.floating,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         margin: const EdgeInsets.all(16),
  //       ),
  //     );
  //   }
  // }
Future<void> _openTelegram(BuildContext context) async {
  final telegramApp = Uri.parse("tg://resolve?domain=sticky_university_bot");
  final telegramWeb = Uri.parse("https://t.me/sticky_university_bot");

  try {
    // Сначала пытаемся открыть Telegram app
    if (await canLaunchUrl(telegramApp)) {
      await launchUrl(
        telegramApp,
        mode: LaunchMode.externalApplication,
      );
      return;
    }

    // Если Telegram app нет — открываем web
    await launchUrl(
      telegramWeb,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Не удалось открыть Telegram'),
        backgroundColor: AppColors.danger,
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.surfaceMuted;

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
              color:
                  isDark ? AppColors.textInverse : AppColors.textPrimary,
            ),
          ),
          title: Text(
            l10n.supportTitle,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color:
                  isDark ? AppColors.textInverse : AppColors.textPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Иллюстрация ────────────────────────────────────────
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.brandAccent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      size: 44,
                      color: AppColors.brandAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Заголовок ───────────────────────────────────────────
                Center(
                  child: Text(
                    l10n.supportTitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.textInverse
                          : AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    l10n.supportDescription,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.55,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Блок с FAQ ──────────────────────────────────────────
                _SectionCard(
                  isDark: isDark,
                  children: [
                    _FaqItem(
                      isDark: isDark,
                      icon: Icons.school_outlined,
                      question: l10n.supportFaq1Question,
                      answer: l10n.supportFaq1Answer,
                    ),
                    _Divider(isDark: isDark),
                    _FaqItem(
                      isDark: isDark,
                      icon: Icons.favorite_border_rounded,
                      question: l10n.supportFaq2Question,
                      answer: l10n.supportFaq2Answer,
                    ),
                    _Divider(isDark: isDark),
                    _FaqItem(
                      isDark: isDark,
                      icon: Icons.translate_rounded,
                      question: l10n.supportFaq3Question,
                      answer: l10n.supportFaq3Answer,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Кнопка Telegram ─────────────────────────────────────
                _TelegramButton(onTap: () => _openTelegram(context)),
                const SizedBox(height: 16),

                // ── Подпись ─────────────────────────────────────────────
                Center(
                  child: Text(
                    l10n.supportResponseTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Карточка-секция ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.isDark, required this.children});

  final bool isDark;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.surfaceMutedDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
        ),
      ),
      child: Column(children: children),
    );
  }
}

// ─── FAQ пункт ────────────────────────────────────────────────────────────────

class _FaqItem extends StatefulWidget {
  const _FaqItem({
    required this.isDark,
    required this.icon,
    required this.question,
    required this.answer,
  });

  final bool isDark;
  final IconData icon;
  final String question;
  final String answer;

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.icon,
                  size: 18,
                  color: AppColors.brandAccent,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.question,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: widget.isDark
                          ? AppColors.textInverse
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizeTransition(
              sizeFactor: _expandAnim,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, left: 28),
                child: Text(
                  widget.answer,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.isDark});
  final bool isDark;
  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: isDark ? const Color(0xFF2C2F36) : AppColors.border,
      );
}

// ─── Кнопка Telegram ──────────────────────────────────────────────────────────

class _TelegramButton extends StatefulWidget {
  const _TelegramButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_TelegramButton> createState() => _TelegramButtonState();
}

class _TelegramButtonState extends State<_TelegramButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            // Официальный цвет Telegram
            color: const Color(0xFF2AABEE),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2AABEE).withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                l10n.supportTelegramButton,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}