import '../../../../core/models/paginated_result.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/exercise_model.dart';

abstract class ExercisesRemoteDataSource {
  Future<ExerciseModel> getExercise(String id);
  Future<PaginatedResult<ExerciseModel>> getExercisesByTeacher(String teacherId,
      {int page, int limit});
}

class ExercisesRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ExercisesRemoteDataSource {
  @override
  Future<ExerciseModel> getExercise(String id) async {
    final res = await baseSendRequest(ApiConstants.exerciseById(id), HttpMethod.get);
    return ExerciseModel.fromJson(res['data'] as Map<String, dynamic>);
  }

  @override
  Future<PaginatedResult<ExerciseModel>> getExercisesByTeacher(
    String teacherId, {
    int page = 1,
    int limit = 20,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.exercisesByTeacher(teacherId),
      HttpMethod.get,
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = res['data'] as List;
    return PaginatedResult(
      items: data
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: res['count'] as int? ?? data.length,
    );
  }
}
