import '../../../../../core/base/base_state.dart';
import '../../../domain/entities/user_entity.dart';

class RegisterState extends BaseState<RegisterState> {
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String selectedRole;
  final UserEntity? user;

  const RegisterState({
    super.status,
    super.error,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.selectedRole = 'student',
    this.user,
  });

  bool get isLoading => status.isLoading;
  bool get isSuccess => status.isSuccess;
  bool get isFailure => status.isFailure;

  RegisterState copyWith({
    ViewStatus? status,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? selectedRole,
    String? error,
    UserEntity? user,
  }) =>
      RegisterState(
        status: status ?? this.status,
        obscurePassword: obscurePassword ?? this.obscurePassword,
        obscureConfirmPassword:
            obscureConfirmPassword ?? this.obscureConfirmPassword,
        selectedRole: selectedRole ?? this.selectedRole,
        error: error,
        user: user ?? this.user,
      );

  @override
  RegisterState copyWithBase({ViewStatus? status, String? error}) =>
      copyWith(status: status, error: error);

  @override
  List<Object?> get props => [
        status,
        error,
        obscurePassword,
        obscureConfirmPassword,
        selectedRole,
        user,
      ];
}
