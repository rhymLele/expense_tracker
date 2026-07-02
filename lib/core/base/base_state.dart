import 'package:equatable/equatable.dart';

/// Trạng thái chung cho các màn hình "load dữ liệu".
enum ViewStatus { initial, loading, success, failure, loadingMore }

extension ViewStatusX on ViewStatus {
  bool get isInitial => this == ViewStatus.initial;
  bool get isLoading => this == ViewStatus.loading;
  bool get isSuccess => this == ViewStatus.success;
  bool get isFailure => this == ViewStatus.failure;
  bool get isLoadingMore => this == ViewStatus.loadingMore;
}

/// Base cho State dạng load dữ liệu: luôn có [status] + [error].
///
/// Dùng CRTP ([S] chính là subclass) để [copyWithBase] trả về đúng type con,
/// nhờ đó [LoadCubit] có thể tự đổi status mà không cần biết state cụ thể.
abstract class BaseState<S extends BaseState<S>> extends Equatable {
  final ViewStatus status;
  final String? error;

  const BaseState({this.status = ViewStatus.initial, this.error});

  /// Subclass override: copy chỉ thay đổi status/error.
  /// Quy ước: [status] null → giữ nguyên; [error] luôn ghi đè (null = xoá lỗi).
  S copyWithBase({ViewStatus? status, String? error});
}
