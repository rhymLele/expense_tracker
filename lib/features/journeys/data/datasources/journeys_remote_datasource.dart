import '../../../../core/models/paginated_result.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/api_response_mapper.dart';
import '../../../../core/network/base_remote_datasource.dart';
import '../../../../core/network/http_method.dart';
import '../models/journey_day_model.dart';
import '../models/journey_model.dart';

abstract class JourneysRemoteDataSource {
  Future<JourneyModel> getJourney(String id);
  Future<PaginatedResult<JourneyModel>> getJourneysByTeacher(String teacherId,
      {int page, int limit});
  Future<List<JourneyDayModel>> getJourneyDays(String journeyId);
  Future<void> enrollJourney(String journeyId);
}

class JourneysRemoteDataSourceImpl extends BaseRemoteDataSource
    implements JourneysRemoteDataSource {
  @override
  Future<JourneyModel> getJourney(String id) async {
    final res = await baseSendRequest(ApiConstants.journeyById(id), HttpMethod.get);
    return ApiResponseMapper.single(res, JourneyModel.fromJson);
  }

  @override
  Future<PaginatedResult<JourneyModel>> getJourneysByTeacher(
    String teacherId, {
    int page = 1,
    int limit = 20,
  }) async {
    final res = await baseSendRequest(
      ApiConstants.journeys,
      HttpMethod.get,
      queryParameters: {'teacherId': teacherId, 'page': page, 'limit': limit},
    );
    return ApiResponseMapper.paginated(res, JourneyModel.fromJson);
  }

  @override
  Future<List<JourneyDayModel>> getJourneyDays(String journeyId) async {
    final res = await baseSendRequest(
      ApiConstants.journeyDays(journeyId),
      HttpMethod.get,
    );
    return ApiResponseMapper.paginated(res, JourneyDayModel.fromJson).items;
  }

  @override
  Future<void> enrollJourney(String journeyId) =>
      baseSendRequest(ApiConstants.enrollJourney(journeyId), HttpMethod.post);
}
