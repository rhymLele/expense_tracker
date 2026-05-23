import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/journey_day_entity.dart';
import '../../domain/entities/journey_entity.dart';
import '../../domain/repositories/journeys_repository.dart';
import '../datasources/journeys_remote_datasource.dart';

class JourneysRepositoryImpl implements JourneysRepository {
  final JourneysRemoteDataSource _dataSource;

  const JourneysRepositoryImpl(this._dataSource);

  @override
  Future<Result<JourneyEntity>> getJourney(String id) async {
    try {
      return Result.success(await _dataSource.getJourney(id));
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<PaginatedResult<JourneyEntity>>> getJourneysByTeacher(
    String teacherId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return Result.success(
        await _dataSource.getJourneysByTeacher(teacherId, page: page, limit: limit),
      );
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<JourneyDayEntity>>> getJourneyDays(String journeyId) async {
    try {
      return Result.success(await _dataSource.getJourneyDays(journeyId));
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> enrollJourney(String journeyId) async {
    try {
      await _dataSource.enrollJourney(journeyId);
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
