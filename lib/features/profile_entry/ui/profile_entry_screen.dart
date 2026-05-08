import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/auth/auth_repository.dart';
import '../../profile/ui/profile_screen.dart';
import '../../register/ui/register_screen.dart';

/// Тонкий маршрутный экран: показывает профиль авторизованным
/// и регистрацию — гостям.
class ProfileEntryScreen extends StatelessWidget {
  const ProfileEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.read<AuthRepository>().isAuthenticated;
    return isAuthenticated ? const ProfileScreen() : const RegisterScreen();
  }
}
