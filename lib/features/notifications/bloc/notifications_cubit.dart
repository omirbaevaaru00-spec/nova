
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logger/logger.dart';

// import 'notifications_state.dart';

// /// Cubit экрана уведомлений.
// ///
// /// Загружает новости из избранных университетов пользователя.
// /// До появления отдельного репозитория новостей — stub-данные.
// class NotificationsCubit extends Cubit<NotificationsState> {
//   NotificationsCubit() : super(const NotificationsState());

//   final _log = Logger();

//   /// Загружает список новостей.
//   ///
//   /// TODO: принять [FavoritesRepository] и [NewsRepository] через конструктор
//   ///       когда будет реализован NewsRepository.
//   Future<void> load() async {
//     emit(state.copyWith(status: NotificationsStatus.loading));
//     try {
//       // TODO: заменить на реальный запрос:
//       //   1. Получить список favId через favoritesRepository.getFavorites()
//       //   2. Для каждого universityId загрузить newsRepository.getNews(id)
//       //   3. Смержить и отсортировать по publishedAt desc
//       await Future.delayed(const Duration(milliseconds: 700));
//       final items = _stubNews();
//       emit(state.copyWith(
//         status: NotificationsStatus.ready,
//         newsItems: items,
//       ));
//     } catch (e, st) {
//       _log.e('Ошибка загрузки уведомлений', error: e, stackTrace: st);
//       emit(state.copyWith(
//         status: NotificationsStatus.failure,
//         errorMessage: e.toString(),
//       ));
//     }
//   }

//   /// Помечает новость как просмотренную.
//   void markAsRead(String itemId) {
//     final updated = state.newsItems.map((item) {
//       return item.id == itemId
//           ? UniversityNewsItem(
//               id: item.id,
//               universityId: item.universityId,
//               universityName: item.universityName,
//               universityLogoUrl: item.universityLogoUrl,
//               title: item.title,
//               summary: item.summary,
//               publishedAt: item.publishedAt,
//               isNew: false,
//             )
//           : item;
//     }).toList();
//     emit(state.copyWith(newsItems: updated));
//   }

//   /// Временные stub-данные для разработки UI.
//   List<UniversityNewsItem> _stubNews() {
//     final now = DateTime.now();
//     return [
//       UniversityNewsItem(
//         id: '1',
//         universityId: 'nu',
//         universityName: 'Назарбаев Университет',
//         title: 'Открытие нового инженерного корпуса',
//         summary:
//             'НУ объявляет об открытии новейшего лабораторного комплекса '
//             'для студентов инженерных специальностей.',
//         publishedAt: now.subtract(const Duration(hours: 1)),
//         isNew: true,
//       ),
//       UniversityNewsItem(
//         id: '2',
//         universityId: 'nu',
//         universityName: 'Назарбаев Университет',
//         title: 'Стипендиальная программа 2025: приём заявок открыт',
//         summary: 'Дедлайн подачи документов — 15 июня 2025 года.',
//         publishedAt: now.subtract(const Duration(hours: 3)),
//         isNew: true,
//       ),
//       UniversityNewsItem(
//         id: '3',
//         universityId: 'kimep',
//         universityName: 'KIMEP University',
//         title: 'KIMEP вошёл в топ-500 QS World Rankings',
//         summary:
//             'Впервые за историю университет получил признание '
//             'в международном рейтинге.',
//         publishedAt: now.subtract(const Duration(days: 1, hours: 2)),
//         isNew: false,
//       ),
//       UniversityNewsItem(
//         id: '4',
//         universityId: 'iitu',
//         universityName: 'МУИТ',
//         title: 'Хакатон AI Challenge 2025: регистрация открыта',
//         summary:
//             'Призовой фонд 5 000 000 ₸. '
//             'Команды до 4 человек, все специальности.',
//         publishedAt: now.subtract(const Duration(days: 1, hours: 5)),
//         isNew: false,
//       ),
//       UniversityNewsItem(
//         id: '5',
//         universityId: 'sdu',
//         universityName: 'SDU University',
//         title: 'День открытых дверей — 20 мая',
//         summary: 'Приглашаем абитуриентов и их родителей посетить кампус.',
//         publishedAt: now.subtract(const Duration(days: 3)),
//         isNew: false,
//       ),
//     ];
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../core/services/firebase_service.dart';
import '../../favorites/global_favorites_notifier.dart';
import 'notifications_state.dart';

/// Cubit экрана уведомлений.
///
/// Логика:
/// 1. Если пользователь не авторизован → статус [NotificationsStatus.unauthenticated].
/// 2. Получаем список избранных universityId из [GlobalFavoritesNotifier].
/// 3. Для каждого избранного университета загружаем подколлекцию
///    `universities/{id}/news` из Firestore (последние 10 новостей).
/// 4. Мержим, сортируем по дате убыванию.
///
/// Структура документа новости в Firestore:
/// ```
/// universities/{universityId}/news/{newsId}
///   title: String
///   summary: String (опционально)
///   publishedAt: Timestamp
///   universityName: String  (денормализованное для удобства)
///   universityLogoUrl: String (денормализованное)
/// ```
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({required FirebaseService firebaseService})
      : _firebase = firebaseService,
        super(const NotificationsState());

  final FirebaseService _firebase;
  final _log = Logger();

  /// Загружает новости избранных университетов.
  Future<void> load() async {
    // ── 1. Проверка авторизации ──────────────────────────────
    if (!_firebase.isAuthenticated) {
      emit(state.copyWith(status: NotificationsStatus.unauthenticated));
      return;
    }

    emit(state.copyWith(status: NotificationsStatus.loading));

    try {
      // ── 2. Получаем избранные ────────────────────────────────
      final favoriteIds =
          GlobalFavoritesNotifier.instance.value.toList();

      if (favoriteIds.isEmpty) {
        // Нет избранных — нет новостей
        emit(state.copyWith(
          status: NotificationsStatus.ready,
          newsItems: [],
        ));
        return;
      }

      // ── 3. Загружаем новости параллельно ────────────────────
      final futures = favoriteIds.map((uniId) => _loadNewsForUniversity(uniId));
      final results = await Future.wait(futures);

      // ── 4. Мержим и сортируем по дате ───────────────────────
      final all = results.expand((list) => list).toList()
        ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

      emit(state.copyWith(
        status: NotificationsStatus.ready,
        newsItems: all,
      ));
    } catch (e, st) {
      _log.e('Ошибка загрузки уведомлений', error: e, stackTrace: st);
      emit(state.copyWith(
        status: NotificationsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Загружает последние 10 новостей одного университета из Firestore.
  Future<List<UniversityNewsItem>> _loadNewsForUniversity(
      String universityId) async {
    try {
      final snap = await _firebase.firestore
          .collection('universities')
          .doc(universityId)
          .collection('news')
          .orderBy('publishedAt', descending: true)
          .limit(10)
          .get();

      // Читаем имя и лого из родительского документа университета
      // (денормализованное в каждом doc новости, либо из метаданных)
      return snap.docs.map((doc) {
        final data = doc.data();
        final ts = data['publishedAt'];
        final publishedAt = ts != null
            ? (ts as dynamic).toDate() as DateTime
            : DateTime.now();

        return UniversityNewsItem(
          id: doc.id,
          universityId: universityId,
          universityName: (data['universityName'] as String?) ?? '',
          universityLogoUrl: data['universityLogoUrl'] as String?,
          title: (data['title'] as String?) ?? '',
          summary: (data['summary'] as String?) ?? '',
          publishedAt: publishedAt,
          isNew: _isNew(publishedAt),
        );
      }).toList();
    } catch (e) {
      _log.w('Не удалось загрузить новости для $universityId: $e');
      return [];
    }
  }

  /// Новость считается «новой» если опубликована за последние 48 часов.
  bool _isNew(DateTime publishedAt) {
    return DateTime.now().difference(publishedAt).inHours < 48;
  }

  /// Помечает новость как прочитанную (локально).
  void markAsRead(String itemId) {
    final updated = state.newsItems.map((item) {
      if (item.id != itemId) return item;
      return UniversityNewsItem(
        id: item.id,
        universityId: item.universityId,
        universityName: item.universityName,
        universityLogoUrl: item.universityLogoUrl,
        title: item.title,
        summary: item.summary,
        publishedAt: item.publishedAt,
        isNew: false,
      );
    }).toList();
    emit(state.copyWith(newsItems: updated));
  }
}