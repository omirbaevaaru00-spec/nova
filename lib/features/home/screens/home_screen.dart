import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/router/route_names.dart';
import '../../../widgets/university_card.dart';
import '../../../widgets/university_model.dart';
import '../../../widgets/favorites_notifier.dart';

const String kInterestsPrefsKey = 'user_interests';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<University> _feed = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    FavoritesNotifier.instance.load();
    _buildFeed();
  }

  Future<void> _buildFeed() async {
    setState(() => _loading = true);

    // ── Интересы из SharedPreferences ──────────────────────
    final prefs = await SharedPreferences.getInstance();
    final interests = prefs.getStringList(kInterestsPrefsKey) ?? [];

    // ── Баллы из Firestore (только если залогинен) ──────────
    double? gpa;
    double? ielts;
    int? ent;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        final data = doc.data() ?? {};
        gpa = double.tryParse(data['gpa']?.toString() ?? '');
        ielts = double.tryParse(data['ielts']?.toString() ?? '');
        ent = int.tryParse(data['ent']?.toString() ?? '');
      } catch (_) {}
    }

    // ── Сортировка ─────────────────────────────────────────
    final all = List<University>.from(kazakhUniversities);

    // Нет данных — показываем как есть
    if (interests.isEmpty && gpa == null && ielts == null && ent == null) {
      setState(() {
        _feed = all;
        _loading = false;
      });
      return;
    }

    // Скоринг каждого вуза
    final scored = all.map((uni) {
      int score = 0;

      // По интересам
      if (interests.isNotEmpty && uni.tags.isNotEmpty) {
        score += uni.tags.where((t) => interests.contains(t)).length * 10;
      }

      // По баллам
      if (ent != null && uni.minEnt != null && ent >= uni.minEnt!) score += 8;
      if (gpa != null && uni.minGpa != null && gpa >= uni.minGpa!) score += 5;
      if (ielts != null && uni.minIelts != null && ielts >= uni.minIelts!) score += 5;

      return (uni, score);
    }).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));

    setState(() {
      _feed = scored.map((e) => e.$1).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Column(
            children: [
              _AppBar(),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _buildFeed,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8, bottom: 24),
                          itemCount: _feed.length,
                          itemBuilder: (context, index) {
                            final uni = _feed[index];
                            return UniversityFeedCard(
                              university: uni,
                              onTap: () => context.push(
                                '/university/${uni.id}',
                                extra: uni,
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3B3B8E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/nova_logo.png',
                height: 32,
                fit: BoxFit.contain,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.push(RouteNames.search),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}