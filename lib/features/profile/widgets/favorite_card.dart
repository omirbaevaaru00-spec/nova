import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/university/university_model.dart';

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({super.key, required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/university/${university.id}', extra: university),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                university.imageUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 110,
                  color: AppColors.surfaceMuted,
                  child: const Icon(
                    Icons.school_outlined,
                    color: AppColors.authPrimaryLight,
                    size: 36,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Row(
                children: [
                  _Logo(university: university),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      university.name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    final initial = Center(
      child: Text(
        university.name.isNotEmpty ? university.name[0] : 'U',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.authPrimaryLight,
        ),
      ),
    );
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceMuted,
        border: Border.all(color: AppColors.border),
      ),
      child: ClipOval(
        child: university.logoUrl.isNotEmpty
            ? Image.network(
                university.logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => initial,
              )
            : initial,
      ),
    );
  }
}
