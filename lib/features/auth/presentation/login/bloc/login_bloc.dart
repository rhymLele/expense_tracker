import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const LoginState()) {
    on<LoginStarted>(_onStarted);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginErrorDismissed>(_onErrorDismissed);
  }

  void _onStarted(LoginStarted event, Emitter<LoginState> emit) {
    emit(const LoginState());
  }

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(
      obscurePassword: !state.obscurePassword,
      errorMessage: state.errorMessage,
    ));
  }

  void _onErrorDismissed(LoginErrorDismissed event, Emitter<LoginState> emit) {
    emit(state.copyWith(status: LoginStatus.initial));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: LoginStatus.success,
        user: user,
      )),
    );
  }
}
