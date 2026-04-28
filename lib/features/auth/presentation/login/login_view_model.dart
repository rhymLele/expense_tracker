import 'package:flutter/material.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/validators/app_validator.dart';
import '../../domain/usecases/login_usecase.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_event.dart';

class LoginViewModel extends BaseViewModel<LoginBloc> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginViewModel({required LoginUseCase loginUseCase})
      : super(LoginBloc(loginUseCase: loginUseCase)) {
    bloc.add(const LoginStarted());
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    bloc.add(LoginSubmitted(
      email: emailController.text.trim(),
      password: passwordController.text,
    ));
  }

  void togglePasswordVisibility() =>
      bloc.add(const LoginPasswordVisibilityToggled());

  void dismissError() => bloc.add(const LoginErrorDismissed());

  void authenticateWithBiometric() => bloc.add(const BiometricLoginRequested());

  void resetBiometric() => bloc.add(const BiometricResetRequested());

  String? validateEmail(String? v) => AppValidator.email(v);
  String? validatePassword(String? v) => AppValidator.password(v);

  @override
  void disposeResources() {
    emailController.dispose();
    passwordController.dispose();
  }
}
