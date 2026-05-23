import '../../../../core/utils/result.dart';
import '../entities/journey_entity.dart';
import '../repositories/journeys_repository.dart';

class GetJourneyUseCase {
  final JourneysRepository _repository;
  const GetJourneyUseCase(this._repository);
  Future<Result<JourneyEntity>> call(String id) => _repository.getJourney(id);
}
