import '../../../../core/utils/result.dart';
import '../entities/journey_day_entity.dart';
import '../repositories/journeys_repository.dart';

class GetJourneyDaysUseCase {
  final JourneysRepository _repository;
  const GetJourneyDaysUseCase(this._repository);
  Future<Result<List<JourneyDayEntity>>> call(String journeyId) =>
      _repository.getJourneyDays(journeyId);
}
