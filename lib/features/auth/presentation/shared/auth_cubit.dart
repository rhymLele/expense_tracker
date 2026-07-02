import '../../../../core/base/base_cubit.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

/// Global Cubit — singleton, tồn tại suốt vòng đời app.
/// Chỉ quản lý trạng thái xác thực tổng thể.
class AuthCubit extends BaseCubit<AuthState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final LogoutUseCase _logout;

  AuthCubit({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getCurrentUser = getCurrentUserUseCase,
        _logout = logoutUseCase,
        super(const AuthInitial());

  @override
  Future<void> fetchData() => started();

  Future<void> started() async {
    emit(const AuthLoading());
    final user = await _getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  void loginSucceeded(UserEntity user) {
    emit(AuthAuthenticated(user));
  }

  Future<void> logout() async {
    await _logout();
    emit(const AuthUnauthenticated());
  }
}
