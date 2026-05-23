import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../entities/teacher_profile_entity.dart';

abstract class TeachersRepository {
  Future<Result<PaginatedResult<TeacherProfileEntity>>> getTeachers({
    String? subject,
    int page = 1,
    int limit = 20,
  });

  Future<Result<TeacherProfileEntity>> getTeacherProfile(String userId);

  Future<Result<TeacherProfileEntity>> updateMyProfile({
    List<String>? subjects,
    String? teachingMode,
  });
}
