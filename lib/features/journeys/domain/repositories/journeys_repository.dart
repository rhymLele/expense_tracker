import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../entities/journey_day_entity.dart';
import '../entities/journey_entity.dart';

abstract class JourneysRepository {
  Future<Result<JourneyEntity>> getJourney(String id);
  Future<Result<PaginatedResult<JourneyEntity>>> getJourneysByTeacher(
    String teacherId, {
    int page = 1,
    int limit = 20,
  });
  Future<Result<List<JourneyDayEntity>>> getJourneyDays(String journeyId);
  Future<Result<void>> enrollJourney(String journeyId);
}
