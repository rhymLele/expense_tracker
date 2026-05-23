import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/teacher_profile_entity.dart';
import '../../domain/repositories/teachers_repository.dart';
import '../datasources/teachers_remote_datasource.dart';

class TeachersRepositoryImpl implements TeachersRepository {
  final TeachersRemoteDataSource _dataSource;

  const TeachersRepositoryImpl(this._dataSource);

  @override
  Future<Result<PaginatedResult<TeacherProfileEntity>>> getTeachers({
    String? subject,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await _dataSource.getTeachers(subject: subject, page: page, limit: limit);
      return Result.success(result);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TeacherProfileEntity>> getTeacherProfile(String userId) async {
    try {
      final result = await _dataSource.getTeacherProfile(userId);
      return Result.success(result);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TeacherProfileEntity>> updateMyProfile({
    List<String>? subjects,
    String? teachingMode,
  }) async {
    try {
      final result = await _dataSource.updateMyProfile(subjects: subjects, teachingMode: teachingMode);
      return Result.success(result);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
