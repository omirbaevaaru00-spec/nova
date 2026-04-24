// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../widgets/favorites_notifier.dart';
// import '../../../widgets/university_model.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   Map<String, dynamic>? _userData;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     FavoritesNotifier.instance.load();
//   }

//   Future<void> _loadUserData() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .get();
//       if (mounted) {
//         setState(() {
//           _userData = doc.data();
//           _loading = false;
//         });
//       }
//     } catch (_) {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         context.go('/register');
//       });
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_loading) {
//       return const Scaffold(
//         backgroundColor: Color(0xFFF2F2F7),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final name = _userData?['name'] ?? user.displayName ?? 'Пользователь';
//     final city = _userData?['city'] ?? '';
//     final gpa = _userData?['gpa'];
//     final ielts = _userData?['ielts'];
//     final ent = _userData?['ent'];
//     final photoUrl = user.photoURL;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F2F7),
//       body: CustomScrollView(
//         slivers: [
//           // ── Закреплённый AppBar ──────────────────────────
//           SliverAppBar(
//             backgroundColor: const Color(0xFFF2F2F7),
//             elevation: 0,
//             pinned: true,
//             automaticallyImplyLeading: false,
//             toolbarHeight: 56,
//             leading: GestureDetector(
//               onTap: () {
//                 if (context.canPop()) context.pop();
//               },
//               child: const Icon(
//                 Icons.arrow_back_rounded,
//                 color: Color(0xFF1C1C1E),
//               ),
//             ),
//             actions: [
//               GestureDetector(
//                 onTap: () => context.push('/profile-settings'),
//                 child: const Padding(
//                   padding: EdgeInsets.only(right: 16),
//                   child: Icon(
//                     Icons.settings_outlined,
//                     color: Color(0xFF1C1C1E),
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 const SizedBox(height: 8),

//                 // ── Аватар ───────────────────────────────
//                 _AvatarWidget(photoUrl: photoUrl, name: name),

//                 const SizedBox(height: 12),

//                 // ── Имя ──────────────────────────────────
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1C1C1E),
//                   ),
//                 ),

//                 // ── Город ────────────────────────────────
//                 if (city.isNotEmpty) ...[
//                   const SizedBox(height: 2),
//                   Text(
//                     city,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFF8E8E93),
//                     ),
//                   ),
//                 ],

//                 const SizedBox(height: 16),

//                 // ── Баллы ────────────────────────────────
//                 _ScoresRow(gpa: gpa, ielts: ielts, ent: ent),

//                 const SizedBox(height: 24),

//                 // ── Избранные ────────────────────────────
//                 _FavoritesSection(),

//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Аватар ──────────────────────────────────────────────────
// class _AvatarWidget extends StatelessWidget {
//   final String? photoUrl;
//   final String name;

//   const _AvatarWidget({required this.photoUrl, required this.name});

//   void _showPhotoOptions(BuildContext context) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (_) => CupertinoActionSheet(
//         title: const Text('Фото профиля'),
//         actions: [
//           CupertinoActionSheetAction(
//             onPressed: () async {
//               Navigator.pop(context);
//               await ImagePicker().pickImage(source: ImageSource.camera);
//               // TODO: загрузи в Firebase Storage
//             },
//             child: const Text('Сделать фото'),
//           ),
//           CupertinoActionSheetAction(
//             onPressed: () async {
//               Navigator.pop(context);
//               await ImagePicker().pickImage(source: ImageSource.gallery);
//               // TODO: загрузи в Firebase Storage
//             },
//             child: const Text('Выбрать из галереи'),
//           ),
//         ],
//         cancelButton: CupertinoActionSheetAction(
//           isDestructiveAction: true,
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Отмена'),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showPhotoOptions(context),
//       child: Stack(
//         children: [
//           Container(
//             width: 96,
//             height: 96,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: const Color(0xFFF4A8A8),
//               image: photoUrl != null
//                   ? DecorationImage(
//                       image: NetworkImage(photoUrl!),
//                       fit: BoxFit.cover,
//                     )
//                   : null,
//             ),
//             child: photoUrl == null
//                 ? const Icon(
//                     CupertinoIcons.person_fill,
//                     color: Colors.white,
//                     size: 48,
//                   )
//                 : null,
//           ),
//           Positioned(
//             bottom: 2,
//             right: 2,
//             child: Container(
//               width: 26,
//               height: 26,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6366F1),
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: const Color(0xFFF2F2F7),
//                   width: 2,
//                 ),
//               ),
//               child: const Icon(Icons.add, color: Colors.white, size: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Строка баллов ───────────────────────────────────────────
// class _ScoresRow extends StatelessWidget {
//   final dynamic gpa;
//   final dynamic ielts;
//   final dynamic ent;

//   const _ScoresRow({this.gpa, this.ielts, this.ent});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(50),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Text(
//             'gpa : ${gpa ?? '—'}',
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF1C1C1E),
//             ),
//           ),
//           const Text(
//             ':',
//             style: TextStyle(color: Color(0xFF8E8E93)),
//           ),
//           Text(
//             'ielts : ${ielts ?? '—'}',
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF1C1C1E),
//             ),
//           ),
//           const Text(
//             ':',
//             style: TextStyle(color: Color(0xFF8E8E93)),
//           ),
//           Text(
//             'ент : ${ent ?? '—'}',
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF1C1C1E),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Секция избранных ────────────────────────────────────────
// class _FavoritesSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<Set<String>>(
//       valueListenable: FavoritesNotifier.instance,
//       builder: (_, favoriteIds, __) {
//         final favs = kazakhUniversities
//             .where((u) => favoriteIds.contains(u.id))
//             .toList();

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               'избранные',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1C1C1E),
//               ),
//             ),
//             const SizedBox(height: 12),
//             if (favs.isEmpty)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 32),
//                 child: Column(
//                   children: const [
//                     Icon(
//                       Icons.favorite_border_rounded,
//                       color: Color(0xFFCCCCCC),
//                       size: 48,
//                     ),
//                     SizedBox(height: 12),
//                     Text(
//                       'Нет избранных университетов',
//                       style: TextStyle(
//                         color: Color(0xFF8E8E93),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 gridDelegate:
//                     const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.82,
//                 ),
//                 itemCount: favs.length,
//                 itemBuilder: (context, i) => _FavCard(university: favs[i]),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// // ─── Карточка избранного ─────────────────────────────────────
// class _FavCard extends StatelessWidget {
//   final University university;
//   const _FavCard({required this.university});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () =>
//           context.push('/university/${university.id}', extra: university),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Фото
//             ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(16)),
//               child: Image.network(
//                 university.imageUrl,
//                 height: 110,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                   height: 110,
//                   color: const Color(0xFFF0EEF8),
//                   child: const Icon(
//                     Icons.school_outlined,
//                     color: Color(0xFF3B3B8E),
//                     size: 36,
//                   ),
//                 ),
//               ),
//             ),
//             // Логотип + название
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
//               child: Row(
//                 children: [
//                   // Логотип
//                   Container(
//                     width: 28,
//                     height: 28,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: const Color(0xFFF0EEF8),
//                       border: Border.all(
//                         color: const Color(0xFFE0DDEF),
//                         width: 1,
//                       ),
//                     ),
//                     child: ClipOval(
//                       child: university.logoUrl.isNotEmpty
//                           ? Image.network(
//                               university.logoUrl,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) => Center(
//                                 child: Text(
//                                   university.name[0],
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                     color: Color(0xFF3B3B8E),
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : Center(
//                               child: Text(
//                                 university.name[0],
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color(0xFF3B3B8E),
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       university.name,
//                       style: const TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1C1C1E),
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';

// import '../../../widgets/favorites_notifier.dart';
// import '../../../widgets/university_model.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   Map<String, dynamic>? _userData;
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     FavoritesNotifier.instance.load();
//   }

//   Future<void> _loadUserData() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid == null) return;
//     try {
//       final doc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(uid)
//           .get();
//       if (mounted) {
//         setState(() {
//           _userData = doc.data();
//           _loading = false;
//         });
//       }
//     } catch (_) {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         context.go('/register');
//       });
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (_loading) {
//       return const Scaffold(
//         backgroundColor: Color(0xFFF2F2F7),
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final name = _userData?['name'] ?? user.displayName ?? 'Пользователь';
//     final city = _userData?['city'] ?? '';
//     final gpa = _userData?['gpa'];
//     final ielts = _userData?['ielts'];
//     final ent = _userData?['ent'];
//     final photoUrl = user.photoURL;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF2F2F7),
//       body: CustomScrollView(
//         slivers: [
//           // ── Закреплённый AppBar ──────────────────────────
//           SliverAppBar(
//             backgroundColor: const Color(0xFFF2F2F7),
//             elevation: 0,
//             pinned: true,
//             automaticallyImplyLeading: false,
//             toolbarHeight: 56,
//             leading: GestureDetector(
//               onTap: () {
//                 if (context.canPop()) context.pop();
//               },
//               child: const Icon(
//                 Icons.arrow_back_rounded,
//                 color: Color(0xFF1C1C1E),
//               ),
//             ),
//             actions: [
//               GestureDetector(
//                 onTap: () => context.push('/profile-settings'),
//                 child: const Padding(
//                   padding: EdgeInsets.only(right: 16),
//                   child: Icon(
//                     Icons.settings_outlined,
//                     color: Color(0xFF1C1C1E),
//                     size: 24,
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 const SizedBox(height: 8),

//                 // ── Аватар ───────────────────────────────
//                 _AvatarWidget(photoUrl: photoUrl, name: name),

//                 const SizedBox(height: 12),

//                 // ── Имя ──────────────────────────────────
//                 Text(
//                   name,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFF1C1C1E),
//                   ),
//                 ),

//                 // ── Город ────────────────────────────────
//                 if (city.isNotEmpty) ...[
//                   const SizedBox(height: 2),
//                   Text(
//                     city,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFF8E8E93),
//                     ),
//                   ),
//                 ],

//                 const SizedBox(height: 16),

//                 // ── Баллы ────────────────────────────────
//                 _ScoresRow(gpa: gpa, ielts: ielts, ent: ent),

//                 const SizedBox(height: 24),

//                 // ── Избранные ────────────────────────────
//                 _FavoritesSection(),

//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Аватар ──────────────────────────────────────────────────
// class _AvatarWidget extends StatelessWidget {
//   final String? photoUrl;
//   final String name;

//   const _AvatarWidget({required this.photoUrl, required this.name});

//   void _showPhotoOptions(BuildContext context) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (_) => CupertinoActionSheet(
//         title: const Text('Фото профиля'),
//         actions: [
//           CupertinoActionSheetAction(
//             onPressed: () async {
//               Navigator.pop(context);
//               await ImagePicker().pickImage(source: ImageSource.camera);
//               // TODO: загрузи в Firebase Storage
//             },
//             child: const Text('Сделать фото'),
//           ),
//           CupertinoActionSheetAction(
//             onPressed: () async {
//               Navigator.pop(context);
//               await ImagePicker().pickImage(source: ImageSource.gallery);
//               // TODO: загрузи в Firebase Storage
//             },
//             child: const Text('Выбрать из галереи'),
//           ),
//         ],
//         cancelButton: CupertinoActionSheetAction(
//           isDestructiveAction: true,
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Отмена'),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _showPhotoOptions(context),
//       child: Stack(
//         children: [
//           Container(
//             width: 96,
//             height: 96,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: const Color(0xFFF4A8A8),
//               image: photoUrl != null
//                   ? DecorationImage(
//                       image: NetworkImage(photoUrl!),
//                       fit: BoxFit.cover,
//                     )
//                   : null,
//             ),
//             child: photoUrl == null
//                 ? const Icon(
//                     CupertinoIcons.person_fill,
//                     color: Colors.white,
//                     size: 48,
//                   )
//                 : null,
//           ),
//           Positioned(
//             bottom: 2,
//             right: 2,
//             child: Container(
//               width: 26,
//               height: 26,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF6366F1),
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: const Color(0xFFF2F2F7),
//                   width: 2,
//                 ),
//               ),
//               child: const Icon(Icons.add, color: Colors.white, size: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Строка баллов ───────────────────────────────────────────
// class _ScoresRow extends StatelessWidget {
//   final dynamic gpa;
//   final dynamic ielts;
//   final dynamic ent;

//   const _ScoresRow({this.gpa, this.ielts, this.ent});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(50),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Text(
//             'gpa : ${gpa ?? '—'}',
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF1C1C1E),
//             ),
//           ),
//           const Text(
//             ':',
//             style: TextStyle(color: Color(0xFF8E8E93)),
//           ),
//           Text(
//             'ielts : ${ielts ?? '—'}',
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF1C1C1E),
//             ),
//           ),
//           const Text(
//             ':',
//             style: TextStyle(color: Color(0xFF8E8E93)),
//           ),
//           Text(
//             'ент : ${ent ?? '—'}',
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF1C1C1E),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Секция избранных ────────────────────────────────────────
// class _FavoritesSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder<Set<String>>(
//       valueListenable: FavoritesNotifier.instance,
//       builder: (_, favoriteIds, __) {
//         final favs = kazakhUniversities
//             .where((u) => favoriteIds.contains(u.id))
//             .toList();

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               'избранные',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF1C1C1E),
//               ),
//             ),
//             const SizedBox(height: 12),
//             if (favs.isEmpty)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 32),
//                 child: Column(
//                   children: const [
//                     Icon(
//                       Icons.favorite_border_rounded,
//                       color: Color(0xFFCCCCCC),
//                       size: 48,
//                     ),
//                     SizedBox(height: 12),
//                     Text(
//                       'Нет избранных университетов',
//                       style: TextStyle(
//                         color: Color(0xFF8E8E93),
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             else
//               GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 gridDelegate:
//                     const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   childAspectRatio: 0.82,
//                 ),
//                 itemCount: favs.length,
//                 itemBuilder: (context, i) => _FavCard(university: favs[i]),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// // ─── Карточка избранного ─────────────────────────────────────
// class _FavCard extends StatelessWidget {
//   final University university;
//   const _FavCard({required this.university});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () =>
//           context.push('/university/${university.id}', extra: university),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Фото
//             ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(16)),
//               child: Image.network(
//                 university.imageUrl,
//                 height: 110,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) => Container(
//                   height: 110,
//                   color: const Color(0xFFF0EEF8),
//                   child: const Icon(
//                     Icons.school_outlined,
//                     color: Color(0xFF3B3B8E),
//                     size: 36,
//                   ),
//                 ),
//               ),
//             ),
//             // Логотип + название
//             Padding(
//               padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
//               child: Row(
//                 children: [
//                   // Логотип
//                   Container(
//                     width: 28,
//                     height: 28,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: const Color(0xFFF0EEF8),
//                       border: Border.all(
//                         color: const Color(0xFFE0DDEF),
//                         width: 1,
//                       ),
//                     ),
//                     child: ClipOval(
//                       child: university.logoUrl.isNotEmpty
//                           ? Image.network(
//                               university.logoUrl,
//                               fit: BoxFit.cover,
//                               errorBuilder: (_, __, ___) => Center(
//                                 child: Text(
//                                   university.name[0],
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                     color: Color(0xFF3B3B8E),
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : Center(
//                               child: Text(
//                                 university.name[0],
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color(0xFF3B3B8E),
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Expanded(
//                     child: Text(
//                       university.name,
//                       style: const TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                         color: Color(0xFF1C1C1E),
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/favorites_notifier.dart';
import '../../../widgets/university_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    FavoritesNotifier.instance.load();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (mounted) {
        setState(() {
          _userData = doc.data();
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/register');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF2F2F7),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = _userData?['name'] ?? user.displayName ?? 'Пользователь';
    final city = _userData?['city'] ?? '';
    final gpa = _userData?['gpa'];
    final ielts = _userData?['ielts'];
    final ent = _userData?['ent'];
    final photoUrl = user.photoURL;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: CustomScrollView(
        slivers: [
          // ── Закреплённый AppBar ──────────────────────────
          SliverAppBar(
            backgroundColor: const Color(0xFFF2F2F7),
            elevation: 0,
            pinned: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 56,
            leading: GestureDetector(
              onTap: () {
                if (context.canPop()) context.pop();
              },
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Color(0xFF1C1C1E),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => context.push('/profile-settings'),
                child: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.settings_outlined,
                    color: Color(0xFF1C1C1E),
                    size: 24,
                  ),
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 8),

                // ── Аватар ───────────────────────────────
                _AvatarWidget(photoUrl: photoUrl, name: name),

                const SizedBox(height: 12),

                // ── Имя ──────────────────────────────────
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1C1E),
                  ),
                ),

                // ── Город ────────────────────────────────
                if (city.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    city,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // ── Баллы ────────────────────────────────
                _ScoresRow(gpa: gpa, ielts: ielts, ent: ent),

                const SizedBox(height: 24),

                // ── Избранные ────────────────────────────
                _FavoritesSection(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Аватар ──────────────────────────────────────────────────
class _AvatarWidget extends StatelessWidget {
  final String? photoUrl;
  final String name;

  const _AvatarWidget({required this.photoUrl, required this.name});

  void _showPhotoOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Фото профиля'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await ImagePicker().pickImage(source: ImageSource.camera);
              // TODO: загрузи в Firebase Storage
            },
            child: const Text('Сделать фото'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await ImagePicker().pickImage(source: ImageSource.gallery);
              // TODO: загрузи в Firebase Storage
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPhotoOptions(context),
      child: Stack(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF4A8A8),
              image: photoUrl != null
                  ? DecorationImage(
                      image: NetworkImage(photoUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: photoUrl == null
                ? const Icon(
                    CupertinoIcons.person_fill,
                    color: Colors.white,
                    size: 48,
                  )
                : null,
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFF2F2F7),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Строка баллов ───────────────────────────────────────────
class _ScoresRow extends StatelessWidget {
  final dynamic gpa;
  final dynamic ielts;
  final dynamic ent;

  const _ScoresRow({this.gpa, this.ielts, this.ent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'gpa : ${gpa ?? '—'}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const Text(
            ':',
            style: TextStyle(color: Color(0xFF8E8E93)),
          ),
          Text(
            'ielts : ${ielts ?? '—'}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const Text(
            ':',
            style: TextStyle(color: Color(0xFF8E8E93)),
          ),
          Text(
            'ент : ${ent ?? '—'}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1C1C1E),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Секция избранных ────────────────────────────────────────
class _FavoritesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: FavoritesNotifier.instance,
      builder: (_, favoriteIds, __) {
        final favs = kazakhUniversities
            .where((u) => favoriteIds.contains(u.id))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'избранные',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1C1E),
              ),
            ),
            const SizedBox(height: 12),
            if (favs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: const [
                    Icon(
                      Icons.favorite_border_rounded,
                      color: Color(0xFFCCCCCC),
                      size: 48,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Нет избранных университетов',
                      style: TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemCount: favs.length,
                itemBuilder: (context, i) => _FavCard(university: favs[i]),
              ),
          ],
        );
      },
    );
  }
}

// ─── Карточка избранного ─────────────────────────────────────
class _FavCard extends StatelessWidget {
  final University university;
  const _FavCard({required this.university});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/university/${university.id}', extra: university),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                university.imageUrl,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 110,
                  color: const Color(0xFFF0EEF8),
                  child: const Icon(
                    Icons.school_outlined,
                    color: Color(0xFF3B3B8E),
                    size: 36,
                  ),
                ),
              ),
            ),
            // Логотип + название
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Row(
                children: [
                  // Логотип
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFF0EEF8),
                      border: Border.all(
                        color: const Color(0xFFE0DDEF),
                        width: 1,
                      ),
                    ),
                    child: ClipOval(
                      child: university.logoUrl.isNotEmpty
                          ? Image.network(
                              university.logoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text(
                                  university.name[0],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF3B3B8E),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                university.name[0],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3B3B8E),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      university.name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
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