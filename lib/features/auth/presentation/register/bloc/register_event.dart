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
  final String fullName;
  final String email;
  final String password;

  const RegisterSubmitted({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
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
