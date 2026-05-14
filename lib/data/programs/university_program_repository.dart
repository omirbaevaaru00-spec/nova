import 'package:stiky/data/programs/university_program_model.dart';

abstract class UniversityProgramRepository {
  Future<List<UniversityProgram>> getPrograms(String universityId);
  Future<void> seedPrograms(
    String universityId,
    List<UniversityProgram> programs,
  );
}