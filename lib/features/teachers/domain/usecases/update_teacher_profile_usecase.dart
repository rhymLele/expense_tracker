import '../../../../core/utils/result.dart';
import '../entities/teacher_profile_entity.dart';
import '../repositories/teachers_repository.dart';

class UpdateTeacherProfileUseCase {
  final TeachersRepository _repository;

  const UpdateTeacherProfileUseCase(this._repository);

  Future<Result<TeacherProfileEntity>> call({
    List<String>? subjects,
    String? teachingMode,
  }) {
    return _repository.updateMyProfile(subjects: subjects, teachingMode: teachingMode);
  }
}
