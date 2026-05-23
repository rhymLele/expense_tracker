import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/submission_entity.dart';
import '../../domain/repositories/submissions_repository.dart';
import '../datasources/submissions_remote_datasource.dart';

class SubmissionsRepositoryImpl implements SubmissionsRepository {
  final SubmissionsRemoteDataSource _dataSource;

  const SubmissionsRepositoryImpl(this._dataSource);

  @override
  Future<Result<SubmissionEntity>> submitAnswer({
    required String enrollmentId,
    required String dayTaskId,
    required Map<String, dynamic> answer,
  }) async {
    try {
      return Result.success(
        await _dataSource.submitAnswer(
          enrollmentId: enrollmentId,
          dayTaskId: dayTaskId,
          answer: answer,
        ),
      );
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<SubmissionEntity>>> getEnrollmentSubmissions(String enrollmentId) async {
    try {
      return Result.success(await _dataSource.getEnrollmentSubmissions(enrollmentId));
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
