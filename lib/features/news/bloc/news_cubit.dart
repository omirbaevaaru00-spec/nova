import 'package:flutter_bloc/flutter_bloc.dart';

import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(const NewsState());

  Future<void> load() async {
    emit(state.copyWith(status: NewsStatus.loading));
    // TODO: подключить NewsRepository (Firestore).
    emit(
      state.copyWith(
        status: NewsStatus.ready,
        items: const [
          NewsItem(
            title: 'Narxoz жаңа бағдарлама ашты',
            subtitle: 'IT және Business бағытында жаңа мүмкіндіктер',
          ),
          NewsItem(
            title: 'SDU қабылдау мерзімін жариялады',
            subtitle: 'Құжат қабылдау басталды',
          ),
          NewsItem(
            title: 'KBTU ашық есік күнін өткізеді',
            subtitle: 'Болашақ студенттерге арналған іс-шара',
          ),
        ],
      ),
    );
  }
}
