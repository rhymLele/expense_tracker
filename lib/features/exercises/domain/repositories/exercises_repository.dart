import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../entities/exercise_entity.dart';

abstract class ExercisesRepository {
  Future<Result<ExerciseEntity>> getExercise(String id);
  Future<Result<PaginatedResult<ExerciseEntity>>> getExercisesByTeacher(
    String teacherId, {
    int page = 1,
    int limit = 20,
  });
}
