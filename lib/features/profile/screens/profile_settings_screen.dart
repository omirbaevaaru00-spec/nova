import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/localization/locale_controller.dart';
import '../../../core/theme/theme_controller.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Профиль
  String _name = '';
  String _city = '';

  // Баллы (Firestore — только для залогиненных)
  String _gpa = '';
  String _ielts = '';
  String _ent = '';

  // Интересы (SharedPreferences — работает без логина)
  List<String> _interests = [];

  bool _uploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    await Future.wait([
      _loadUserData(),
      _loadInterests(),
    ]);
  }

  // ── Firestore: имя, город, баллы ────────────────────────
  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final data = doc.data();
      if (data != null && mounted) {
        setState(() {
          _name = data['name']?.toString() ??
              FirebaseAuth.instance.currentUser?.displayName ??
              '';
          _city = data['city']?.toString() ?? '';
          _gpa = data['gpa']?.toString() ?? '';
          _ielts = data['ielts']?.toString() ?? '';
          _ent = data['ent']?.toString() ?? '';
        });
      }
    } catch (_) {}
  }

  // ── SharedPreferences: интересы ─────────────────────────
  Future<void> _loadInterests() async {
    // final prefs = await SharedPreferences.getInstance();
    // final saved = prefs.getStringList(kInterestsPrefsKey) ?? [];
    // if (mounted) setState(() => _interests = saved);
  }

  String get _profileSubtitle {
    final parts = <String>[];
    if (_name.isNotEmpty) parts.add(_name);
    if (_city.isNotEmpty) parts.add(_city);
    return parts.isEmpty ? 'Не заполнено' : parts.join(' · ');
  }

  String get _scoresSubtitle {
    final parts = <String>[];
    if (_gpa.isNotEmpty) parts.add('GPA: $_gpa');
    if (_ielts.isNotEmpty) parts.add('IELTS: $_ielts');
    if (_ent.isNotEmpty) parts.add('ЕНТ: $_ent');
    return parts.isEmpty ? 'Не заполнено' : parts.join(' · ');
  }

  String get _interestsSubtitle {
    if (_interests.isEmpty) return 'Не выбраны';
    const emojiMap = {
      'it': '💻', 'medicine': '🩺', 'business': '📊', 'grants': '🎓',
      'design': '🎨', 'law': '⚖️', 'pedagogy': '📚', 'engineering': '⚙️',
      'bachelor': '🏫', 'college': '🏢', 'master': '🎯',
    };
    return _interests.take(5).map((k) => emojiMap[k] ?? k).join('  ');
  }

  // ── Сохранение в Firestore ───────────────────────────────
  Future<void> _saveToFirestore(Map<String, dynamic> updates) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || updates.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(updates);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Сохранено ✓'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка при сохранении'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ── Загрузка фото в Firebase Storage ────────────────────
  Future<void> _uploadPhoto(ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked == null || !mounted) return;

    setState(() => _uploadingPhoto = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final ref =
          FirebaseStorage.instance.ref().child('avatars/$uid.jpg');
      await ref.putFile(File(picked.path));
      final url = await ref.getDownloadURL();
      await FirebaseAuth.instance.currentUser!.updatePhotoURL(url);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'photoUrl': url});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Фото обновлено ✓'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка загрузки фото'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeController.instance,
      builder: (context, _) {
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
                child: const Icon(CupertinoIcons.back,
                    color: Color(0xFF1C1C1E), size: 20),
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
              // ── Профиль: ник + город ──
              _SettingsItem(
                icon: CupertinoIcons.person,
                iconColor: const Color(0xFF6366F1),
                title: 'Редактировать профиль',
                subtitle: _profileSubtitle,
                onTap: () => _showEditProfileDialog(context),
              ),
              const SizedBox(height: 10),

              // ── Баллы (Firestore) ──
              _SettingsItem(
                icon: CupertinoIcons.star_fill,
                iconColor: const Color(0xFFFF9500),
                title: 'Редактировать баллы',
                subtitle: _scoresSubtitle,
                onTap: FirebaseAuth.instance.currentUser != null
                    ? () => _showEditScoresDialog(context)
                    : () => _showNotLoggedIn(context),
              ),
              const SizedBox(height: 10),

              // ── Интересы (SharedPreferences) ──
              _SettingsItem(
                icon: CupertinoIcons.doc_checkmark,
                iconColor: const Color(0xFFFF9500),
                title: 'Пройти опрос по интересам',
                subtitle: _interestsSubtitle,
                onTap: () async {
                  await context.push('/quiz');
                  // Перечитываем интересы после возврата
                  await _loadInterests();
                },
              ),
              const SizedBox(height: 10),

              // ── Язык ──
              _SettingsItem(
                icon: CupertinoIcons.globe,
                iconColor: const Color(0xFF34C759),
                title: 'Сменить язык',
                subtitle: _langLabel,
                onTap: () => _showLanguagePicker(context),
              ),
              const SizedBox(height: 10),

              // ── Тёмная тема (ThemeController) ──
              _SettingsItemWithToggle(
                icon: CupertinoIcons.moon_fill,
                iconColor: const Color(0xFF8E44AD),
                title: 'Тёмная тема',
                value: ThemeController.instance.isDark,
                onChanged: (v) => ThemeController.instance.setDark(v),
              ),
              const SizedBox(height: 10),

              // ── Фото ──
              _uploadingPhoto
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Center(
                          child: CircularProgressIndicator()),
                    )
                  : _SettingsItem(
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
                    border: Border.all(
                        color: const Color(0xFFFFE5E5), width: 0.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.square_arrow_left,
                          color: Color(0xFFE53E3E), size: 18),
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
      },
    );
  }

  String get _langLabel {
    switch (LocaleController.instance.locale.languageCode) {
      case 'kk': return 'Қазақша';
      case 'en': return 'English';
      default: return 'Русский';
    }
  }

  // ── Диалог: ник + город ──────────────────────────────────
  void _showEditProfileDialog(BuildContext context) {
    final nameCtrl = TextEditingController(text: _name);
    final cityCtrl = TextEditingController(text: _city);

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Редактировать профиль'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              CupertinoTextField(
                  controller: nameCtrl, placeholder: 'Имя / ник'),
              const SizedBox(height: 8),
              CupertinoTextField(
                  controller: cityCtrl,
                  placeholder: 'Город (напр. Алматы)'),
            ],
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
              Navigator.pop(context);
              final newName = nameCtrl.text.trim();
              final newCity = cityCtrl.text.trim();
              final updates = <String, dynamic>{
                if (newName.isNotEmpty) 'name': newName,
                if (newCity.isNotEmpty) 'city': newCity,
              };
              if (newName.isNotEmpty) {
                await FirebaseAuth.instance.currentUser
                    ?.updateDisplayName(newName);
              }
              await _saveToFirestore(updates);
              if (mounted) setState(() {
                if (newName.isNotEmpty) _name = newName;
                if (newCity.isNotEmpty) _city = newCity;
              });
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  // ── Диалог: баллы (Firestore) ────────────────────────────
  void _showEditScoresDialog(BuildContext context) {
    final gpaCtrl = TextEditingController(text: _gpa);
    final ieltsCtrl = TextEditingController(text: _ielts);
    final entCtrl = TextEditingController(text: _ent);

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Редактировать баллы'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              CupertinoTextField(
                controller: gpaCtrl,
                placeholder: 'GPA (напр. 3.8)',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: ieltsCtrl,
                placeholder: 'IELTS (напр. 7.0)',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              CupertinoTextField(
                controller: entCtrl,
                placeholder: 'ЕНТ (напр. 120)',
                keyboardType: TextInputType.number,
              ),
            ],
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
              Navigator.pop(context);
              final newGpa = gpaCtrl.text.trim();
              final newIelts = ieltsCtrl.text.trim();
              final newEnt = entCtrl.text.trim();
              await _saveToFirestore({
                if (newGpa.isNotEmpty)
                  'gpa': double.tryParse(newGpa) ?? newGpa,
                if (newIelts.isNotEmpty)
                  'ielts': double.tryParse(newIelts) ?? newIelts,
                if (newEnt.isNotEmpty)
                  'ent': int.tryParse(newEnt) ??
                      double.tryParse(newEnt) ??
                      newEnt,
              });
              if (mounted) setState(() {
                if (newGpa.isNotEmpty) _gpa = newGpa;
                if (newIelts.isNotEmpty) _ielts = newIelts;
                if (newEnt.isNotEmpty) _ent = newEnt;
              });
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showNotLoggedIn(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Требуется вход'),
        content: const Text('Войдите в аккаунт чтобы сохранять баллы.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ок'),
          ),
        ],
      ),
    );
  }

  // ── Язык через LocaleController ─────────────────────────
  void _showLanguagePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Выберите язык'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              LocaleController.instance.setLocale(const Locale('ru'));
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Русский'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              LocaleController.instance.setLocale(const Locale('kk'));
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Қазақша'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              LocaleController.instance.setLocale(const Locale('en'));
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('English'),
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

  // ── Фото ────────────────────────────────────────────────
  void _showPhotoOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Фото профиля'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _uploadPhoto(ImageSource.camera);
            },
            child: const Text('Сделать фото'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _uploadPhoto(ImageSource.gallery);
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

  // ── Выход ────────────────────────────────────────────────
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
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
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
                  Text(title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C1C1E),
                      )),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8E8E93),
                        )),
                  ],
                ],
              ),
            ),
            const Icon(CupertinoIcons.chevron_right,
                size: 16, color: Color(0xFFC7C7CC)),
          ],
        ),
      ),
    );
  }
}

// ─── Пункт с переключателем ─────────────────────────────────
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
        border:
            Border.all(color: const Color(0xFFE5E5EA), width: 0.5),
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
            child: Text(title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1C1C1E),
                )),
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