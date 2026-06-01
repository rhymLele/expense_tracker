import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _dataSource.login(email: email, password: password);
      return Result.success(user);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      final user = await _dataSource.register(
        email: email,
        password: password,
        name: name,
        role: role,
      );
      return Result.success(user);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _dataSource.logout();
      return const Result.success(null);
    } on AppException catch (e) {
      return Result.failure(e.toFailure());
    } catch (e) {
      return Result.failure(const UnknownFailure());
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() => _dataSource.getCurrentUser();
}
