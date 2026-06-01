import '../../../../core/utils/result.dart';
import '../entities/topic_entity.dart';
import '../repositories/topics_repository.dart';

class CreateTopicUseCase {
  final TopicsRepository _repository;
  const CreateTopicUseCase(this._repository);

  Future<Result<TopicEntity>> call({
    required String type,
    required String title,
    String? description,
    String? visibility,
  }) =>
      _repository.createTopic(
        type: type,
        title: title,
        description: description,
        visibility: visibility,
      );
}
