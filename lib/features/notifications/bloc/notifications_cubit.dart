import 'package:flutter_bloc/flutter_bloc.dart';

import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  Future<void> load() async {
    emit(state.copyWith(status: NotificationsStatus.loading));
    // TODO: подключить репозиторий уведомлений (FirebaseService).
    emit(
      state.copyWith(
        status: NotificationsStatus.ready,
        items: const [
          'Сен сақтаған университет жаңа жаңалық жариялады',
          'Қабылдау мерзімі жақындап қалды',
          'Жаңа университеттер сенің қызығушылығыңа сай табылды',
        ],
      ),
    );
  }
}
