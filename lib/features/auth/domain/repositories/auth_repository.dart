import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Result<UserEntity>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  });

  Future<Result<void>> logout();

  Future<UserEntity?> getCurrentUser();
}
