import '../../../../core/utils/result.dart';
import '../repositories/follows_repository.dart';

class FollowTeacherUseCase {
  final FollowsRepository _repository;
  const FollowTeacherUseCase(this._repository);
  Future<Result<void>> call(String teacherId) => _repository.follow(teacherId);
}
