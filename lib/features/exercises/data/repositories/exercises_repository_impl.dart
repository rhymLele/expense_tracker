import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/exercise_entity.dart';
import '../../domain/repositories/exercises_repository.dart';
import '../datasources/exercises_remote_datasource.dart';

class ExercisesRepositoryImpl implements ExercisesRepository {
  final ExercisesRemoteDataSource _dataSource;

  const ExercisesRepositoryImpl(this._dataSource);

  @override
  Future<Result<ExerciseEntity>> getExercise(String id) async {
    try {
      return Result.success(await _dataSource.getExercise(id));
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<PaginatedResult<ExerciseEntity>>> getExercisesByTeacher(
    String teacherId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return Result.success(
        await _dataSource.getExercisesByTeacher(teacherId, page: page, limit: limit),
      );
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
