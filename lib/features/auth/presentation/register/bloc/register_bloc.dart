import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/register_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc({required RegisterUseCase registerUseCase})
      : _registerUseCase = registerUseCase,
        super(const RegisterState()) {
    on<RegisterStarted>(_onStarted);
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterPasswordVisibilityToggled>(_onPasswordToggled);
    on<RegisterConfirmPasswordVisibilityToggled>(_onConfirmPasswordToggled);
    on<RegisterErrorDismissed>(_onErrorDismissed);
  }

  void _onStarted(RegisterStarted event, Emitter<RegisterState> emit) {
    emit(const RegisterState());
  }

  void _onPasswordToggled(
    RegisterPasswordVisibilityToggled event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      obscurePassword: !state.obscurePassword,
      errorMessage: state.errorMessage,
    ));
  }

  void _onConfirmPasswordToggled(
    RegisterConfirmPasswordVisibilityToggled event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
      errorMessage: state.errorMessage,
    ));
  }

  void _onErrorDismissed(RegisterErrorDismissed event, Emitter<RegisterState> emit) {
    emit(state.copyWith(status: RegisterStatus.initial));
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    final result = await _registerUseCase(
      email: event.email,
      password: event.password,
      name: event.name,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: RegisterStatus.success,
        user: user,
      )),
    );
  }
}
