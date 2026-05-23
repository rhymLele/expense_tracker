import '../../../../core/utils/result.dart';
import '../repositories/journeys_repository.dart';

class EnrollJourneyUseCase {
  final JourneysRepository _repository;
  const EnrollJourneyUseCase(this._repository);
  Future<Result<void>> call(String journeyId) => _repository.enrollJourney(journeyId);
}
