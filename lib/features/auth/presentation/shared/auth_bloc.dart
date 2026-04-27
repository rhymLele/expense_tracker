import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Global BLoC — singleton, tồn tại suốt vòng đời app.
/// Chỉ quản lý trạng thái xác thực tổng thể.
/// LoginBloc / RegisterBloc sẽ notify qua AuthLoginSucceeded.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase _getCurrentUser;
  final LogoutUseCase _logout;

  AuthBloc({
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _getCurrentUser = getCurrentUserUseCase,
        _logout = logoutUseCase,
        super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginSucceeded>(_onLoginSucceeded);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final user = await _getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  void _onLoginSucceeded(AuthLoginSucceeded event, Emitter<AuthState> emit) {
    emit(AuthAuthenticated(event.user));
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logout();
    emit(const AuthUnauthenticated());
  }
}
