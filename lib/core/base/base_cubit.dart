import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_state.dart';

/// Base cho MỌI Cubit trong app — chuẩn hoá vòng đời:
///   init() → fetchData() → ready()   ... rồi   close() → onDispose()
///
/// Dùng được cho cả cubit có state-machine riêng (không cần [BaseState]),
/// vì nó chỉ ràng buộc vòng đời chứ không ràng buộc hình dạng state.
abstract class BaseCubit<S> extends Cubit<S> {
  BaseCubit(super.initialState);

  bool _initialized = false;

  /// Gọi 1 lần từ UI (BlocProvider.create / initState). Idempotent & an toàn
  /// khi cubit đã đóng.
  Future<void> init() async {
    if (_initialized || isClosed) return;
    _initialized = true;
    await fetchData();
    if (!isClosed) ready();
  }

  /// Nạp dữ liệu lần đầu — subclass BẮT BUỘC implement.
  Future<void> fetchData();

  /// Hook chạy sau khi [init] hoàn tất (mặc định no-op).
  void ready() {}

  /// Hook dọn dẹp trước khi đóng (dispose controller, huỷ subscription...).
  void onDispose() {}

  @override
  Future<void> close() {
    onDispose();
    return super.close();
  }
}

/// Base cho cubit "load dữ liệu" theo khuôn chuẩn [ViewStatus].
/// Thêm [guard] để tự set loading → success/failure quanh một tác vụ async.
abstract class LoadCubit<S extends BaseState<S>> extends BaseCubit<S> {
  LoadCubit(super.initialState);

  /// Chạy [action] với auto status:
  ///   emit(loading) → [action]() trả về state kết quả → emit(state đó)
  ///   nếu ném lỗi → emit(failure + error).
  ///
  /// Dùng [loading] = [ViewStatus.loadingMore] cho phân trang.
  Future<void> guard(
    Future<S> Function() action, {
    ViewStatus loading = ViewStatus.loading,
  }) async {
    if (isClosed) return;
    emit(state.copyWithBase(status: loading, error: null));
    try {
      final next = await action();
      if (!isClosed) emit(next);
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWithBase(status: ViewStatus.failure, error: e.toString()));
      }
    }
  }
}
