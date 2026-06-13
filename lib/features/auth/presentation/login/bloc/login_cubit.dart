import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/biometric/biometric_sdk.dart';
import '../../../../../core/biometric/models/biometric_result.dart';
import '../../../../../core/biometric/models/biometric_status.dart';
import '../../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const LoginState());

  void started() {
    emit(const LoginState());
    checkBiometricStatus();
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(
      obscurePassword: !state.obscurePassword,
      errorMessage: state.errorMessage,
    ));
  }

  void dismissError() {
    emit(state.copyWith(status: LoginStatus.initial));
  }

  Future<void> submit({required String email, required String password}) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _loginUseCase(email: email, password: password);

    await result.fold(
      (failure) async => emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      )),
      (user) async {
        try {
          await _trySetupBiometric(email: email);
        } catch (_) {}
        emit(state.copyWith(status: LoginStatus.success, user: user));
      },
    );
  }

  Future<void> checkBiometricStatus() async {
    try {
      final biometricStatus = await BiometricSDK.checkStatus();
      emit(state.copyWith(biometricStatus: biometricStatus));
    } catch (_) {}
  }

  Future<void> requestBiometricLogin() async {
    emit(state.copyWith(status: LoginStatus.biometricLoading));

    final result = await BiometricSDK.authenticate(
      reason: 'Đăng nhập bằng vân tay / Face ID',
    );

    switch (result) {
      case BiometricSuccess():
        final credentials = await BiometricSDK.getStoredCredentials();
        if (credentials.email == null) {
          emit(state.copyWith(
            status: LoginStatus.failure,
            errorMessage: 'Không tìm thấy thông tin đăng nhập. Vui lòng đăng nhập bằng mật khẩu.',
          ));
          return;
        }
        final loginResult = await _loginUseCase(
          email: credentials.email!,
          password: credentials.refreshToken ?? '',
        );
        loginResult.fold(
          (failure) => emit(state.copyWith(
            status: LoginStatus.failure,
            errorMessage: failure.message,
          )),
          (user) => emit(state.copyWith(status: LoginStatus.success, user: user)),
        );

      case BiometricEnrollmentChanged():
        await BiometricSDK.reset();
        emit(state.copyWith(
          status: LoginStatus.initial,
          biometricStatus: BiometricStatus.enrollmentChanged,
        ));

      case BiometricFailure(:final message):
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: message,
        ));

      case BiometricUnavailable():
        emit(state.copyWith(
          status: LoginStatus.initial,
          biometricStatus: BiometricStatus.notAvailable,
        ));
    }
  }

  Future<void> resetBiometric() async {
    await BiometricSDK.reset();
    emit(state.copyWith(biometricStatus: BiometricStatus.notSetup));
  }

  Future<void> _trySetupBiometric({required String email}) async {
    final status = await BiometricSDK.checkStatus();
    if (status == BiometricStatus.notAvailable ||
        status == BiometricStatus.notEnrolled) {
      return;
    }
    await BiometricSDK.setup(email: email, refreshToken: '');
  }
}
