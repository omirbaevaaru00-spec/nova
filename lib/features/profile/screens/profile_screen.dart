import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ─── Цвета приложения ──────────────────────────────────────
class AppColors {
  static const primary = Color(0xFF6366F1);
  static const primaryLight = Color(0xFFEEEDFE);
  static const background = Color(0xFFF2F2F7);
  static const cardBg = Colors.white;
  static const textPrimary = Color(0xFF1C1C1E);
  static const textSecondary = Color(0xFF8E8E93);
  static const divider = Color(0xFFE5E5EA);
  static const heartRed = Color(0xFFE53E3E);
  static const avatarBg = Color(0xFFF9A8A8);
}

// ─── Модель избранного университета ────────────────────────
class FavoriteUniversity {
  final String name;
  final String location;
  final String emoji;

  const FavoriteUniversity({
    required this.name,
    required this.location,
    required this.emoji,
  });
}

// ─── Главный экран профиля ──────────────────────────────────
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Замени на реальные данные из Firebase/BLoC
  static const _favorites = [
    FavoriteUniversity(
      name: 'МГУ им. М.В. Ломоносова',
      location: 'Москва, Россия',
      emoji: '🏛️',
    ),
    FavoriteUniversity(
      name: 'МФТИ',
      location: 'Московская обл., Россия',
      emoji: '🎓',
    ),
    FavoriteUniversity(
      name: 'Назарбаев Университет',
      location: 'Астана, Казахстан',
      emoji: '🌍',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Если нет пользователя — редиректим на регистрацию
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/register');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _ProfileAppBar(
        onSettingsTap: () => context.push('/settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 8),
          _AvatarSection(user: user),
          const SizedBox(height: 16),
          _ScoresCard(),
          const SizedBox(height: 20),
          _FavoritesSection(favorites: _favorites),
        ],
      ),
    );
  }
}

// ─── AppBar профиля ─────────────────────────────────────────
class _ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSettingsTap;

  const _ProfileAppBar({required this.onSettingsTap});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
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
          child: const Icon(CupertinoIcons.back, color: AppColors.textPrimary, size: 20),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onSettingsTap,
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
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(CupertinoIcons.settings, color: AppColors.textPrimary, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Секция аватара, имени, города ─────────────────────────
class _AvatarSection extends StatelessWidget {
  final User user;

  const _AvatarSection({required this.user});

  @override
  Widget build(BuildContext context) {
    final displayName = user.displayName ?? 'Пользователь';
    final photoUrl = user.photoURL;

    return Column(
      children: [
        Stack(
          children: [
            // Аватар
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.avatarBg,
                image: photoUrl != null
                    ? DecorationImage(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: photoUrl == null
                  ? const Icon(CupertinoIcons.person_fill, color: Colors.white, size: 46)
                  : null,
            ),
            // Кнопка добавить фото
            Positioned(
              bottom: 2,
              right: 2,
              child: GestureDetector(
                onTap: () => _showPhotoOptions(context),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 2),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          displayName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Алматы', // Замени на реальный город из профиля
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Фото профиля'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // TODO: image_picker камера
            },
            child: const Text('Сделать фото'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // TODO: image_picker галерея
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
}

// ─── Карточка баллов ────────────────────────────────────────
class _ScoresCard extends StatelessWidget {
  // Замени на реальные данные из BLoC/Firestore
  final double gpa;
  final double ielts;
  final int ent;

  const _ScoresCard({
    this.gpa = 3.5,
    this.ielts = 6.5,
    this.ent = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ScoreItem(label: 'gpa', value: gpa.toString()),
          _Divider(),
          _ScoreItem(label: 'ielts', value: ielts.toString()),
          _Divider(),
          _ScoreItem(label: 'ент', value: ent.toString()),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String label;
  final String value;

  const _ScoreItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: AppColors.divider);
  }
}

// ─── Секция избранных ────────────────────────────────────────
class _FavoritesSection extends StatelessWidget {
  final List<FavoriteUniversity> favorites;

  const _FavoritesSection({required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'избранные',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (favorites.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Center(
              child: Text(
                'Нет избранных университетов',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _FavoriteCard(university: favorites[index]),
          ),
      ],
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteUniversity university;

  const _FavoriteCard({required this.university});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(university.emoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  university.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  university.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(CupertinoIcons.heart_fill, color: AppColors.heartRed, size: 18),
        ],
      ),
    );
  }
}