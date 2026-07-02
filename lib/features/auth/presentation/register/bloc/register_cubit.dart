import '../../../../../core/base/base_cubit.dart';
import '../../../../../core/base/base_state.dart';
import '../../../domain/usecases/register_usecase.dart';
import 'register_state.dart';

class RegisterCubit extends LoadCubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit({required RegisterUseCase registerUseCase})
      : _registerUseCase = registerUseCase,
        super(const RegisterState());

  /// Form-driven — không load ban đầu.
  @override
  Future<void> fetchData() async {}

  void started() {
    emit(const RegisterState());
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(
      obscurePassword: !state.obscurePassword,
      error: state.error,
    ));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(
      obscureConfirmPassword: !state.obscureConfirmPassword,
      error: state.error,
    ));
  }

  void changeRole(String role) {
    emit(state.copyWith(selectedRole: role));
  }

  void dismissError() {
    emit(state.copyWith(status: ViewStatus.initial));
  }

  Future<void> submit({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await _registerUseCase(
      email: email,
      password: password,
      name: name,
      role: role,
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: ViewStatus.failure, error: failure.message)),
      (user) => emit(state.copyWith(
        status: ViewStatus.success,
        user: user,
      )),
    );
  }
}
