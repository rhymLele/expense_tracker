import 'package:flutter/material.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/validators/app_validator.dart';
import '../../domain/usecases/login_usecase.dart';
import 'bloc/login_cubit.dart';

class LoginViewModel extends BaseViewModel<LoginCubit> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginViewModel({required LoginUseCase loginUseCase})
      : super(LoginCubit(loginUseCase: loginUseCase)) {
    bloc.started();
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;
    bloc.submit(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  void togglePasswordVisibility() => bloc.togglePasswordVisibility();

  void dismissError() => bloc.dismissError();

  void authenticateWithBiometric() => bloc.requestBiometricLogin();

  void resetBiometric() => bloc.resetBiometric();

  String? validateEmail(String? v) => AppValidator.email(v);
  String? validatePassword(String? v) => AppValidator.password(v);

  @override
  void disposeResources() {
    emailController.dispose();
    passwordController.dispose();
  }
}
