import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../teachers/domain/entities/teacher_profile_entity.dart';
import '../../domain/repositories/follows_repository.dart';
import '../datasources/follows_remote_datasource.dart';

class FollowsRepositoryImpl implements FollowsRepository {
  final FollowsRemoteDataSource _dataSource;

  const FollowsRepositoryImpl(this._dataSource);

  @override
  Future<Result<void>> follow(String teacherId) async {
    try {
      await _dataSource.follow(teacherId);
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> unfollow(String teacherId) async {
    try {
      await _dataSource.unfollow(teacherId);
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TeacherProfileEntity>>> getFollowing() async {
    try {
      final result = await _dataSource.getFollowing();
      return Result.success(result);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TeacherProfileEntity>>> getFollowers(String teacherId) async {
    try {
      final result = await _dataSource.getFollowers(teacherId);
      return Result.success(result);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }
}
