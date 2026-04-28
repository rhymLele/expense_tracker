import 'package:equatable/equatable.dart';
import '../../../../../core/biometric/models/biometric_status.dart';
import '../../../domain/entities/user_entity.dart';

enum LoginStatus { initial, loading, success, failure, biometricLoading }

class LoginState extends Equatable {
  final LoginStatus status;
  final bool obscurePassword;
  final String? errorMessage;
  final UserEntity? user;
  final BiometricStatus biometricStatus;

  const LoginState({
    this.status = LoginStatus.initial,
    this.obscurePassword = true,
    this.errorMessage,
    this.user,
    this.biometricStatus = BiometricStatus.notAvailable,
  });

  bool get isLoading => status == LoginStatus.loading;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;
  bool get isBiometricLoading => status == LoginStatus.biometricLoading;

  /// Hiển thị nút biometric khi sẵn sàng hoặc chưa setup
  bool get showBiometricButton =>
      biometricStatus == BiometricStatus.available ||
      biometricStatus == BiometricStatus.notSetup;

  /// Hiển thị cảnh báo enrollment thay đổi
  bool get showEnrollmentChangedWarning =>
      biometricStatus == BiometricStatus.enrollmentChanged;

  LoginState copyWith({
    LoginStatus? status,
    bool? obscurePassword,
    String? errorMessage,
    UserEntity? user,
    BiometricStatus? biometricStatus,
  }) =>
      LoginState(
        status: status ?? this.status,
        obscurePassword: obscurePassword ?? this.obscurePassword,
        errorMessage: errorMessage,
        user: user ?? this.user,
        biometricStatus: biometricStatus ?? this.biometricStatus,
      );

  @override
  List<Object?> get props => [
        status,
        obscurePassword,
        errorMessage,
        user,
        biometricStatus,
      ];
}
