import 'package:firebase_auth/firebase_auth.dart';
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
    } on FirebaseAuthException catch (e) {
      return Result.failure(ServerFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final user = await _dataSource.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      return Result.success(user);
    } on FirebaseAuthException catch (e) {
      return Result.failure(ServerFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _dataSource.logout();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(UnknownFailure());
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() => _dataSource.getCurrentUser();

  String _mapFirebaseError(String code) => switch (code) {
        'user-not-found' => 'Tài khoản không tồn tại',
        'wrong-password' => 'Mật khẩu không chính xác',
        'invalid-email' => 'Email không hợp lệ',
        'user-disabled' => 'Tài khoản đã bị vô hiệu hóa',
        'email-already-in-use' => 'Email đã được sử dụng',
        'weak-password' => 'Mật khẩu quá yếu',
        'too-many-requests' => 'Quá nhiều lần thử, vui lòng thử lại sau',
        'network-request-failed' => 'Không có kết nối mạng',
        _ => 'Thao tác thất bại, vui lòng thử lại',
      };
}
