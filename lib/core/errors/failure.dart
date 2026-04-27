abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  const ServerFailure(super.message, {this.statusCode});
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Không có kết nối mạng']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Lỗi đọc dữ liệu local']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Đã có lỗi xảy ra, vui lòng thử lại']);
}
