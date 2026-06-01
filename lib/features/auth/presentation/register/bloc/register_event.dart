import 'package:equatable/equatable.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();
  @override
  List<Object?> get props => [];
}

final class RegisterStarted extends RegisterEvent {
  const RegisterStarted();
}

final class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String role;

  const RegisterSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [name, email, password, role];
}

final class RegisterRoleChanged extends RegisterEvent {
  final String role;
  const RegisterRoleChanged(this.role);
  @override
  List<Object?> get props => [role];
}

final class RegisterPasswordVisibilityToggled extends RegisterEvent {
  const RegisterPasswordVisibilityToggled();
}

final class RegisterConfirmPasswordVisibilityToggled extends RegisterEvent {
  const RegisterConfirmPasswordVisibilityToggled();
}

final class RegisterErrorDismissed extends RegisterEvent {
  const RegisterErrorDismissed();
}
