import '../../../../core/utils/result.dart';
import '../entities/exercise_entity.dart';
import '../repositories/exercises_repository.dart';

class GetExerciseUseCase {
  final ExercisesRepository _repository;
  const GetExerciseUseCase(this._repository);
  Future<Result<ExerciseEntity>> call(String id) => _repository.getExercise(id);
}
