import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

// ─── Экран настроек ─────────────────────────────────────────
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  String _currentLang = 'Русский';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('dark_mode') ?? false;
      _currentLang = prefs.getString('language') ?? 'Русский';
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
    setState(() => _isDarkMode = value);
    // TODO: подключи к ThemeBloc или themeNotifier
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(CupertinoIcons.back, color: Color(0xFF1C1C1E), size: 20),
          ),
        ),
        title: const Text(
          'Настройки',
          style: TextStyle(
            color: Color(0xFF1C1C1E),
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: [
          // ── Профиль ──
          _SettingsItem(
            icon: CupertinoIcons.person,
            iconColor: const Color(0xFF6366F1),
            title: 'Редактировать',
            subtitle: 'Имя / Фамилия',
            onTap: () => _showEditNameDialog(context),
          ),
          const SizedBox(height: 10),

          // ── Язык ──
          _SettingsItem(
            icon: CupertinoIcons.globe,
            iconColor: const Color(0xFF34C759),
            title: 'Сменить язык',
            subtitle: _currentLang,
            onTap: () => _showLanguagePicker(context),
          ),
          const SizedBox(height: 10),

          // ── Тема ──
          _SettingsItemWithToggle(
            icon: CupertinoIcons.moon_fill,
            iconColor: const Color(0xFF8E44AD),
            title: 'Тёмная тема',
            value: _isDarkMode,
            onChanged: _toggleTheme,
          ),
          const SizedBox(height: 10),

          // ── Опрос по интересам ──
          _SettingsItem(
            icon: CupertinoIcons.doc_checkmark,
            iconColor: const Color(0xFFFF9500),
            title: 'Пройти опрос по интересам',
            onTap: () => context.push('/survey'),
          ),
          const SizedBox(height: 10),

          // ── Добавить фото ──
          _SettingsItem(
            icon: CupertinoIcons.camera,
            iconColor: const Color(0xFF00BCD4),
            title: 'Добавить фото',
            subtitle: 'Сделать фото или из галереи',
            onTap: () => _showPhotoOptions(context),
          ),
          const SizedBox(height: 10),

          // ── Помощь ──
          _SettingsItem(
            icon: CupertinoIcons.question_circle,
            iconColor: const Color(0xFF8E8E93),
            title: 'Нужна помощь',
            subtitle: 'Центр помощи · FAQ и поддержка',
            onTap: () => context.push('/help'),
          ),
          const SizedBox(height: 32),

          // ── Выйти ──
          GestureDetector(
            onTap: () => _confirmSignOut(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFFE5E5), width: 0.5),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.square_arrow_left, color: Color(0xFFE53E3E), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Выйти из аккаунта',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE53E3E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Диалог редактирования имени ──────────────────────────
  void _showEditNameDialog(BuildContext context) {
    final controller = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.displayName ?? '',
    );
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Редактировать имя'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: controller,
            placeholder: 'Имя Фамилия',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              await FirebaseAuth.instance.currentUser
                  ?.updateDisplayName(controller.text.trim());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  // ── Выбор языка ──────────────────────────────────────────
  void _showLanguagePicker(BuildContext context) {
    const languages = ['Русский', 'Қазақша', 'English'];
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Выберите язык'),
        actions: languages.map((lang) {
          return CupertinoActionSheetAction(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('language', lang);
              setState(() => _currentLang = lang);
              if (context.mounted) Navigator.pop(context);
              // TODO: подключи к LocalizationBloc
            },
            child: Text(lang),
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
      ),
    );
  }

  // ── Выбор фото ───────────────────────────────────────────
  void _showPhotoOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Фото профиля'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final picker = ImagePicker();
              final file = await picker.pickImage(source: ImageSource.camera);
              if (file != null) {
                // TODO: загрузи в Firebase Storage и обнови photoURL
              }
            },
            child: const Text('Сделать фото'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final picker = ImagePicker();
              final file = await picker.pickImage(source: ImageSource.gallery);
              if (file != null) {
                // TODO: загрузи в Firebase Storage и обнови photoURL
              }
            },
            child: const Text('Выбрать из галереи'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
      ),
    );
  }

  // ── Подтверждение выхода ─────────────────────────────────
  void _confirmSignOut(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) context.go('/register');
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}

// ─── Компонент пункта настроек ───────────────────────────────
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: Color(0xFFC7C7CC),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Компонент пункта с переключателем ──────────────────────
class _SettingsItemWithToggle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsItemWithToggle({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1C1E),
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: const Color(0xFF6366F1),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}