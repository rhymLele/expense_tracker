import 'package:flutter_bloc/flutter_bloc.dart';

/// Base cho mọi ViewModel trong app.
/// [B] là BLoC mà ViewModel này sở hữu.
///
/// Pattern: ViewModel tạo và sở hữu BLoC → get_it chỉ cần tạo ViewModel.
/// Router lấy [blocProvider] rồi đưa vào MultiBlocProvider.
abstract class BaseViewModel<B extends BlocBase<dynamic>> extends Cubit<void> {
  final B bloc;

  BaseViewModel(this.bloc) : super(null);

  /// Trả về BlocProvider đúng type — router dùng cái này.
  /// Dart reified generics đảm bảo B được giữ đúng runtime type.
  BlocProvider<B> get blocProvider => BlocProvider<B>.value(value: bloc);

  /// Override để dispose TextEditingController, FocusNode, v.v.
  void disposeResources() {}

  @override
  Future<void> close() async {
    disposeResources();
    await bloc.close();
    return super.close();
  }
}
