import 'biometric_status.dart';

sealed class BiometricResult {}

/// Xác thực thành công
final class BiometricSuccess extends BiometricResult {}

/// Xác thực thất bại (user cancel, quét sai...)
final class BiometricFailure extends BiometricResult {
  final String message;
  BiometricFailure(this.message);
}

/// Phát hiện vân tay mới được đăng ký → cần reset + đăng nhập bằng mật khẩu
final class BiometricEnrollmentChanged extends BiometricResult {}

/// Biometric không khả dụng trên thiết bị này
final class BiometricUnavailable extends BiometricResult {
  final BiometricStatus status;
  BiometricUnavailable(this.status);
}
