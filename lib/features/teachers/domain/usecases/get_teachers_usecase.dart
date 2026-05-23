import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../entities/teacher_profile_entity.dart';
import '../repositories/teachers_repository.dart';

class GetTeachersUseCase {
  final TeachersRepository _repository;

  const GetTeachersUseCase(this._repository);

  Future<Result<PaginatedResult<TeacherProfileEntity>>> call({
    String? subject,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getTeachers(subject: subject, page: page, limit: limit);
  }
}
