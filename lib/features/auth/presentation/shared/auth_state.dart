import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

/// Chưa kiểm tra session (trước splash)
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Đang kiểm tra session
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Đã đăng nhập — dùng user ở bất kỳ feature nào
final class AuthAuthenticated extends AuthState {
  final UserEntity user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

/// Chưa đăng nhập / đã đăng xuất
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}
