import '../../../../core/utils/result.dart';
import '../../../teachers/domain/entities/teacher_profile_entity.dart';
import '../repositories/follows_repository.dart';

class GetFollowersUseCase {
  final FollowsRepository _repository;
  const GetFollowersUseCase(this._repository);
  Future<Result<List<TeacherProfileEntity>>> call(String teacherId) =>
      _repository.getFollowers(teacherId);
}
