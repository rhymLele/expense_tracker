import 'failure.dart';

enum AppExceptionStatus { auth, network, notFound, server, unknown }

abstract class AppException implements Exception {
  final String code;
  final String message;
  final AppExceptionStatus status;

  const AppException({
    required this.code,
    required this.message,
    required this.status,
  });

  Failure toFailure();

  @override
  String toString() => '$runtimeType(code: $code, message: $message)';
}

// ─── Subtypes ─────────────────────────────────────────────────────────────────

class AuthException extends AppException {
  const AuthException({required super.code, required super.message})
      : super(status: AppExceptionStatus.auth);

  factory AuthException.fromCode(String code, {String? firebaseMessage}) =>
      AuthException(code: code, message: _mapCode(code, firebaseMessage));

  @override
  AuthFailure toFailure() => AuthFailure(message, code: code);

  static String _mapCode(String code, [String? firebaseMessage]) => switch (code) {
        'user-not-found'                            => 'Tài khoản không tồn tại',
        'wrong-password'                            => 'Mật khẩu không chính xác',
        'invalid-credential'                        => 'Email hoặc mật khẩu không chính xác',
        'invalid-email'                             => 'Email không hợp lệ',
        'user-disabled'                             => 'Tài khoản đã bị vô hiệu hóa',
        'email-already-in-use'                      => 'Email đã được sử dụng',
        'weak-password'                             => 'Mật khẩu quá yếu (tối thiểu 6 ký tự)',
        'too-many-requests'                         => 'Quá nhiều lần thử, vui lòng thử lại sau',
        'operation-not-allowed'                     => 'Phương thức đăng nhập không được hỗ trợ',
        'network-request-failed'                    => 'Không có kết nối mạng',
        'requires-recent-login'                     => 'Vui lòng đăng nhập lại để tiếp tục',
        'account-exists-with-different-credential'  => 'Email đã được dùng với phương thức khác',
        'credential-already-in-use'                 => 'Thông tin xác thực đã được sử dụng',
        'expired-action-code'                       => 'Liên kết đã hết hạn, vui lòng thử lại',
        'invalid-action-code'                       => 'Liên kết không hợp lệ',
        'configuration-not-found'                   => 'Firebase chưa được cấu hình đúng',
        _                                           => firebaseMessage ?? 'Lỗi xác thực [$code]',
      };
}

class NetworkException extends AppException {
  const NetworkException()
      : super(
          code: 'network-error',
          message: 'Không có kết nối mạng',
          status: AppExceptionStatus.network,
        );

  @override
  NetworkFailure toFailure() => const NetworkFailure();
}

class NotFoundException extends AppException {
  const NotFoundException([String message = 'Không tìm thấy dữ liệu'])
      : super(
          code: 'not-found',
          message: message,
          status: AppExceptionStatus.notFound,
        );

  @override
  ServerFailure toFailure() => ServerFailure(message);
}

class ServerException extends AppException {
  const ServerException({required super.code, required super.message})
      : super(status: AppExceptionStatus.server);

  @override
  ServerFailure toFailure() => ServerFailure(message);
}
