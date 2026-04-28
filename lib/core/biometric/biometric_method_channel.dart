import 'package:flutter/services.dart';

import 'models/biometric_type.dart';

/// Bridge đến native platform — singleton.
/// Android: KeyStore với setInvalidatedByBiometricEnrollment(true)
/// iOS: LAContext.evaluatedPolicyDomainState
class BiometricMethodChannel {
  BiometricMethodChannel._();

  static final instance = BiometricMethodChannel._();

  static const _channel = MethodChannel('com.example.sam/biometric');

  // ─── Enrollment ──────────────────────────────────────────────────────────

  /// Trả về: 'ok' | 'changed' | 'notSetup' | 'notAvailable'
  Future<String> checkEnrollmentStatus() async {
    try {
      final result = await _channel.invokeMethod<String>('checkEnrollmentStatus');
      return result ?? 'notAvailable';
    } on PlatformException {
      return 'notAvailable';
    }
  }

  /// Gọi sau khi user đăng nhập thành công → tạo key/lưu domain state
  Future<void> setupBiometricKey() async {
    try {
      await _channel.invokeMethod('setupBiometricKey');
    } on PlatformException {
      // ignore — không ảnh hưởng luồng chính
    }
  }

  /// Xóa key/domain state → dùng khi enrollment thay đổi hoặc user tắt biometric
  Future<void> resetBiometricKey() async {
    try {
      await _channel.invokeMethod('resetBiometricKey');
    } on PlatformException {
      // ignore
    }
  }

  // ─── Device capability ───────────────────────────────────────────────────

  /// Kiểm tra phần cứng sinh trắc học có được hỗ trợ không.
  /// Android: BiometricManager.canAuthenticate(BIOMETRIC_STRONG | BIOMETRIC_WEAK)
  /// iOS: LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics)
  Future<bool> checkSupportBiometric() async {
    try {
      final result = await _channel.invokeMethod<bool>('checkSupportBiometric');
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }

  /// Trả về danh sách loại biometric đã đăng ký trên thiết bị.
  /// Android: ['fingerprint'] | ['face'] | []
  /// iOS: ['face'] (Face ID) | ['fingerprint'] (Touch ID) | []
  Future<List<BiometricType>> getEnrolledBiometrics() async {
    try {
      final result = await _channel.invokeMethod<List<Object?>>('getEnrolledBiometrics');
      return result
              ?.whereType<String>()
              .map(BiometricType.fromString)
              .toList() ??
          [];
    } on PlatformException {
      return [];
    }
  }

  // ─── Authentication ───────────────────────────────────────────────────────

  /// Hiển thị prompt xác thực sinh trắc học.
  /// Trả về: 'success' | 'failed' | 'lockedOut' | 'permanentlyLockedOut' | 'notAvailable'
  Future<String> authenticate({required String reason}) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'authenticate',
        {'reason': reason},
      );
      return result ?? 'failed';
    } on PlatformException catch (e) {
      return switch (e.code) {
        'lockedOut'          => 'lockedOut',
        'permanentlyLockedOut' => 'permanentlyLockedOut',
        'notAvailable'       => 'notAvailable',
        _                    => 'failed',
      };
    }
  }
}
