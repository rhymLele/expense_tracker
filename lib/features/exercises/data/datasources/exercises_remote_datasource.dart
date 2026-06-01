import '../../../../core/models/paginated_result.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response_mapper.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/exercise_model.dart';
import '../models/exercise_template_model.dart';

abstract class ExercisesRemoteDataSource {
  Future<ExerciseModel> getExercise(String id);
  Future<PaginatedResult<ExerciseModel>> getExercisesByTeacher(String teacherId,
      {int page, int limit});
  Future<List<ExerciseTemplateModel>> getTemplates({String? category});
  Future<void> createExercise({
    required String type,
    required String title,
    required String question,
    required Map<String, dynamic> config,
  });
}

class ExercisesRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ExercisesRemoteDataSource {
  @override
  Future<ExerciseModel> getExercise(String id) async {
    final res = await baseSendRequest(ApiConstants.exerciseById(id), HttpMethod.get);
    return ApiResponseMapper.single(res, ExerciseModel.fromJson);
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
    return ApiResponseMapper.paginated(res, ExerciseModel.fromJson);
  }

  @override
  Future<List<ExerciseTemplateModel>> getTemplates({String? category}) async {
    final res = await baseSendRequest(
      ApiConstants.exerciseTemplates,
      HttpMethod.get,
      queryParameters: category != null ? {'category': category} : null,
    );
    return ApiResponseMapper.list(res, ExerciseTemplateModel.fromJson);
  }

  @override
  Future<void> createExercise({
    required String type,
    required String title,
    required String question,
    required Map<String, dynamic> config,
  }) async {
    await baseSendRequest(
      ApiConstants.exercises,
      HttpMethod.post,
      data: {
        'type': type,
        'title': title,
        'question': question,
        'config': config,
      },
    );
  }
}
