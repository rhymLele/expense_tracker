import '../../../../core/models/paginated_result.dart';
import '../../../../core/network/api_constants.dart';
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
    return JourneyModel.fromJson(res['data'] as Map<String, dynamic>);
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
    final data = res['data'] as List;
    return PaginatedResult(
      items: data
          .map((e) => JourneyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: res['count'] as int? ?? data.length,
    );
  }

  @override
  Future<List<JourneyDayModel>> getJourneyDays(String journeyId) async {
    final res = await baseSendRequest(
      ApiConstants.journeyDays(journeyId),
      HttpMethod.get,
    );
    final data = res['data'] as List;
    return data
        .map((e) => JourneyDayModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> enrollJourney(String journeyId) =>
      baseSendRequest(ApiConstants.enrollJourney(journeyId), HttpMethod.post);
}
