import '../../../../core/utils/result.dart';
import '../repositories/topics_repository.dart';

class ToggleLikeUseCase {
  final TopicsRepository _repository;
  const ToggleLikeUseCase(this._repository);
  Future<Result<void>> call(String topicId) => _repository.toggleLike(topicId);
}
