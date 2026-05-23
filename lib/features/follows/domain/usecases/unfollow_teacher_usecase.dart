import '../../../../core/utils/result.dart';
import '../repositories/follows_repository.dart';

class UnfollowTeacherUseCase {
  final FollowsRepository _repository;
  const UnfollowTeacherUseCase(this._repository);
  Future<Result<void>> call(String teacherId) => _repository.unfollow(teacherId);
}
