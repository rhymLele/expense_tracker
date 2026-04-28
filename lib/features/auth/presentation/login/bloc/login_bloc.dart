import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/biometric/biometric_sdk.dart';
import '../../../../../core/biometric/models/biometric_result.dart';
import '../../../../../core/biometric/models/biometric_status.dart';
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
    on<BiometricStatusChecked>(_onBiometricStatusChecked);
    on<BiometricLoginRequested>(_onBiometricLoginRequested);
    on<BiometricResetRequested>(_onBiometricResetRequested);
  }

  void _onStarted(LoginStarted event, Emitter<LoginState> emit) {
    emit(const LoginState());
    add(const BiometricStatusChecked());
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

    await result.fold(
      (failure) async => emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: failure.message,
      )),
      (user) async {
        // Biometric setup là optional — không được block login success
        try {
          await _trySetupBiometric(email: event.email);
        } catch (_) {}
        emit(state.copyWith(status: LoginStatus.success, user: user));
      },
    );
  }

  // ─── Biometric ────────────────────────────────────────────────────────────

  Future<void> _onBiometricStatusChecked(
    BiometricStatusChecked event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final biometricStatus = await BiometricSDK.checkStatus();
      emit(state.copyWith(biometricStatus: biometricStatus));
    } catch (_) {
      // Biometric không khả dụng → giữ nguyên trạng thái notAvailable
    }
  }

  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequested event,
    Emitter<LoginState> emit,
  ) async {
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
        // Dùng stored credentials để đăng nhập Firebase
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
        // Vân tay mới được thêm → cảnh báo user
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

  Future<void> _onBiometricResetRequested(
    BiometricResetRequested event,
    Emitter<LoginState> emit,
  ) async {
    await BiometricSDK.reset();
    emit(state.copyWith(biometricStatus: BiometricStatus.notSetup));
  }

  Future<void> _trySetupBiometric({required String email}) async {
    final status = await BiometricSDK.checkStatus();
    if (status == BiometricStatus.notAvailable ||
        status == BiometricStatus.notEnrolled) {
      return;
    }
    // Lưu email, token sẽ được update sau khi có Firebase token
    await BiometricSDK.setup(email: email, refreshToken: '');
  }
}
