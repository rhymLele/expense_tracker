import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  final RegisterStatus status;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String selectedRole;
  final String? errorMessage;
  final UserEntity? user;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.selectedRole = 'student',
    this.errorMessage,
    this.user,
  });

  bool get isLoading => status == RegisterStatus.loading;
  bool get isSuccess => status == RegisterStatus.success;
  bool get isFailure => status == RegisterStatus.failure;

  RegisterState copyWith({
    RegisterStatus? status,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? selectedRole,
    String? errorMessage,
    UserEntity? user,
  }) =>
      RegisterState(
        status: status ?? this.status,
        obscurePassword: obscurePassword ?? this.obscurePassword,
        obscureConfirmPassword:
            obscureConfirmPassword ?? this.obscureConfirmPassword,
        selectedRole: selectedRole ?? this.selectedRole,
        errorMessage: errorMessage,
        user: user ?? this.user,
      );

  @override
  List<Object?> get props => [
        status,
        obscurePassword,
        obscureConfirmPassword,
        selectedRole,
        errorMessage,
        user,
      ];
}
