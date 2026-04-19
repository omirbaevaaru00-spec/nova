import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'profile_screen.dart';
import '../../auth/screens/register_screen.dart';

class ProfileEntryScreen extends StatelessWidget {
  const ProfileEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const RegisterScreen();
    }

    return const ProfileScreen();
  }
}