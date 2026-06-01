import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<Result<UserEntity>> call({
    required String email,
    required String password,
    required String name,
    required String role,
  }) {
    return _repository.register(email: email, password: password, name: name, role: role);
  }
}
