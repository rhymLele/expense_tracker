import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

/// Splash gọi khi app khởi động — kiểm tra session
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Login/Register thành công → cập nhật auth state toàn app
final class AuthLoginSucceeded extends AuthEvent {
  final UserEntity user;
  const AuthLoginSucceeded(this.user);
  @override
  List<Object?> get props => [user];
}

/// Bất kỳ màn hình nào cũng có thể gửi event này
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
