import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_cubit.dart';

/// Mixin cho [State] sở hữu một hoặc nhiều cubit.
///
/// Đăng ký cubit qua [own]: nó tự gọi [BaseCubit.init] (nếu là [BaseCubit])
/// và tự [BlocBase.close] khi view dispose — bỏ hết boilerplate
/// `initState { ..init() }` + `dispose { ..close() }`.
///
/// View vẫn tự khai báo `MultiBlocProvider`/`BlocProvider.value` trong `build`
/// để giữ đúng type cho `context.read<T>()`.
///
/// ```dart
/// class _HomePageState extends State<HomePage> with CubitHost<HomePage> {
///   late final _feedCubit = own(sl<FeedCubit>());
///   ...
/// }
/// ```
mixin CubitHost<W extends StatefulWidget> on State<W> {
  final List<BlocBase<dynamic>> _ownedCubits = [];

  /// Sở hữu [cubit]: init ngay (nếu là [BaseCubit]) và close khi view dispose.
  /// Trả lại chính [cubit] để gán vào field.
  T own<T extends BlocBase<dynamic>>(T cubit) {
    _ownedCubits.add(cubit);
    if (cubit is BaseCubit) {
      cubit.init();
    }
    return cubit;
  }

  @override
  void dispose() {
    for (final cubit in _ownedCubits) {
      cubit.close();
    }
    super.dispose();
  }
}
