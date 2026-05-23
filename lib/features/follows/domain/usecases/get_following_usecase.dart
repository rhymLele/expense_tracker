import '../../../../core/utils/result.dart';
import '../../../teachers/domain/entities/teacher_profile_entity.dart';
import '../repositories/follows_repository.dart';

class GetFollowingUseCase {
  final FollowsRepository _repository;
  const GetFollowingUseCase(this._repository);
  Future<Result<List<TeacherProfileEntity>>> call() => _repository.getFollowing();
}
