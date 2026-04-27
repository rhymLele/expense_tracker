import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  final LoginStatus status;
  final bool obscurePassword;
  final String? errorMessage;
  final UserEntity? user;

  const LoginState({
    this.status = LoginStatus.initial,
    this.obscurePassword = true,
    this.errorMessage,
    this.user,
  });

  bool get isLoading => status == LoginStatus.loading;
  bool get isSuccess => status == LoginStatus.success;
  bool get isFailure => status == LoginStatus.failure;

  LoginState copyWith({
    LoginStatus? status,
    bool? obscurePassword,
    String? errorMessage,
    UserEntity? user,
  }) =>
      LoginState(
        status: status ?? this.status,
        obscurePassword: obscurePassword ?? this.obscurePassword,
        // null khi dismiss error
        errorMessage: errorMessage,
        user: user ?? this.user,
      );

  @override
  List<Object?> get props => [status, obscurePassword, errorMessage, user];
}
