import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit({required RegisterUseCase registerUseCase})
      : _registerUseCase = registerUseCase,
        super(const RegisterState());

  void started() {
    emit(const RegisterState());
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(
      obscurePassword: !state.obscurePassword,
      errorMessage: state.errorMessage,
    ));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
      errorMessage: state.errorMessage,
    ));
  }

  void changeRole(String role) {
    emit(state.copyWith(selectedRole: role));
  }

  void dismissError() {
    emit(state.copyWith(status: RegisterStatus.initial));
  }

  Future<void> submit({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    final result = await _registerUseCase(
      email: email,
      password: password,
      name: name,
      role: role,
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
