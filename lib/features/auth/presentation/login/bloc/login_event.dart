import 'package:equatable/equatable.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

final class LoginStarted extends LoginEvent {
  const LoginStarted();
}

final class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  const LoginSubmitted({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

final class LoginPasswordVisibilityToggled extends LoginEvent {
  const LoginPasswordVisibilityToggled();
}

final class LoginErrorDismissed extends LoginEvent {
  const LoginErrorDismissed();
}

/// Kiểm tra biometric có khả dụng không khi màn hình mở
final class BiometricStatusChecked extends LoginEvent {
  const BiometricStatusChecked();
}

/// User nhấn nút biometric login
final class BiometricLoginRequested extends LoginEvent {
  const BiometricLoginRequested();
}

/// User đồng ý reset sau khi phát hiện enrollment thay đổi
final class BiometricResetRequested extends LoginEvent {
  const BiometricResetRequested();
}
