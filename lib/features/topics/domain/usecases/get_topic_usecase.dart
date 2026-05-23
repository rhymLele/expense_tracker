import '../../../../core/utils/result.dart';
import '../entities/topic_entity.dart';
import '../repositories/topics_repository.dart';

class GetTopicUseCase {
  final TopicsRepository _repository;
  const GetTopicUseCase(this._repository);
  Future<Result<TopicEntity>> call(String id) => _repository.getTopic(id);
}
