import '../storage/app_secure_storage.dart';
import 'biometric_method_channel.dart';
import 'models/biometric_result.dart';
import 'models/biometric_status.dart';

/// SDK tập trung toàn bộ logic biometric — 100% native qua [BiometricMethodChannel].
/// Xử lý enrollment change, secure credential storage và authentication prompt.
class BiometricSDK {
  BiometricSDK._();

  static final _channel = BiometricMethodChannel.instance;
  static final _storage = AppSecureStorage.instance;

  static const _keyEmail = 'biometric_email';
  static const _keyToken = 'biometric_refresh_token';

  // ─── Public API ──────────────────────────────────────────────────────────

  /// Kiểm tra trạng thái biometric trên thiết bị.
  static Future<BiometricStatus> checkStatus() async {
    final supported = await _channel.checkSupportBiometric();
    if (!supported) return BiometricStatus.notAvailable;

    final enrolled = await _channel.getEnrolledBiometrics();
    if (enrolled.isEmpty) return BiometricStatus.notEnrolled;

    final nativeStatus = await _channel.checkEnrollmentStatus();
    return switch (nativeStatus) {
      'notSetup' => BiometricStatus.notSetup,
      'changed'  => BiometricStatus.enrollmentChanged,
      'ok'       => BiometricStatus.available,
      _          => BiometricStatus.notAvailable,
    };
  }

  /// Xác thực bằng biometric qua native prompt.
  /// Tự động phát hiện enrollment thay đổi và trả về [BiometricEnrollmentChanged].
  static Future<BiometricResult> authenticate({
    String reason = 'Xác thực để tiếp tục',
  }) async {
    final status = await checkStatus();

    if (status == BiometricStatus.enrollmentChanged) {
      return BiometricEnrollmentChanged();
    }
    if (status == BiometricStatus.notAvailable ||
        status == BiometricStatus.notEnrolled) {
      return BiometricUnavailable(status);
    }

    final result = await _channel.authenticate(reason: reason);
    return switch (result) {
      'success'              => BiometricSuccess(),
      'lockedOut'            => BiometricFailure('Xác thực bị tạm khóa. Vui lòng thử lại sau.'),
      'permanentlyLockedOut' => BiometricFailure('Xác thực bị khóa vĩnh viễn. Vui lòng dùng mật khẩu.'),
      _                      => BiometricFailure('Xác thực thất bại'),
    };
  }

  /// Gọi sau khi đăng nhập thành công bằng mật khẩu.
  /// Lưu credentials vào secure storage + tạo enrollment marker.
  static Future<void> setup({
    required String email,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _keyEmail, value: email),
      _storage.write(key: _keyToken, value: refreshToken),
      _channel.setupBiometricKey(),
    ]);
  }

  /// Lấy credentials đã lưu sau khi biometric thành công.
  static Future<({String? email, String? refreshToken})> getStoredCredentials() async {
    final email = await _storage.read(key: _keyEmail);
    final token = await _storage.read(key: _keyToken);
    return (email: email, refreshToken: token);
  }

  /// Xóa toàn bộ dữ liệu biometric.
  /// Gọi khi: enrollment thay đổi, user đăng xuất, user tắt tính năng.
  static Future<void> reset() async {
    await Future.wait([
      _storage.delete(key: _keyEmail),
      _storage.delete(key: _keyToken),
      _channel.resetBiometricKey(),
    ]);
  }

  /// Kiểm tra xem đã có credentials lưu chưa (đã từng setup chưa).
  static Future<bool> hasStoredCredentials() async {
    final email = await _storage.read(key: _keyEmail);
    return email != null;
  }
}
