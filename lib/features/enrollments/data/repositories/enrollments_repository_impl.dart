import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/enrollment_entity.dart';
import '../../domain/repositories/enrollments_repository.dart';
import '../datasources/enrollments_remote_datasource.dart';

class EnrollmentsRepositoryImpl implements EnrollmentsRepository {
  final EnrollmentsRemoteDataSource _dataSource;

  const EnrollmentsRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<EnrollmentEntity>>> getMyEnrollments() async {
    try {
      return Result.success(await _dataSource.getMyEnrollments());
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> useFreeze(String enrollmentId) async =>
      const Result.success(null); // feature removed
}
