import '../../../../core/utils/result.dart';
import '../entities/teacher_profile_entity.dart';
import '../repositories/teachers_repository.dart';

class GetTeacherProfileUseCase {
  final TeachersRepository _repository;

  const GetTeacherProfileUseCase(this._repository);

  Future<Result<TeacherProfileEntity>> call(String userId) {
    return _repository.getTeacherProfile(userId);
  }
}
