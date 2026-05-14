import 'package:stiky/data/news/university_news_model.dart';

abstract class UniversityNewsRepository {
  Future<List<UniversityNews>> getNews(String universityId);
  Future<void> seedNews(
    String universityId,
    List<UniversityNews> news,
  );
}