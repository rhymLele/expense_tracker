import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

/// Màn hình vừa mở — reset về initial
final class LoginStarted extends LoginEvent {
  const LoginStarted();
}

/// User nhấn nút đăng nhập
final class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  const LoginSubmitted({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

/// Nhấn icon show/hide password
final class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

/// Reset lỗi khi user bắt đầu nhập lại
final class LoginErrorDismissed extends LoginEvent {
  const LoginErrorDismissed();
}
