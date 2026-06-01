import 'package:flutter/material.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/validators/app_validator.dart';
import '../../domain/usecases/register_usecase.dart';
import 'bloc/register_bloc.dart';
import 'bloc/register_event.dart';

class RegisterViewModel extends BaseViewModel<RegisterBloc> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RegisterViewModel({required RegisterUseCase registerUseCase})
      : super(RegisterBloc(registerUseCase: registerUseCase)) {
    bloc.add(const RegisterStarted());
  }

  void selectRole(String role) => bloc.add(RegisterRoleChanged(role));

  void submit() {
    if (!formKey.currentState!.validate()) return;
    bloc.add(RegisterSubmitted(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      role: bloc.state.selectedRole,
    ));
  }

  void togglePasswordVisibility() =>
      bloc.add(const RegisterPasswordVisibilityToggled());

  void toggleConfirmPasswordVisibility() =>
      bloc.add(const RegisterConfirmPasswordVisibilityToggled());

  void dismissError() => bloc.add(const RegisterErrorDismissed());

  String? validateName(String? v) => AppValidator.required(v, 'Họ và tên');
  String? validateEmail(String? v) => AppValidator.email(v);
  String? validatePassword(String? v) => AppValidator.password(v);
  String? validateConfirmPassword(String? v) =>
      AppValidator.confirmPassword(v, passwordController.text);

  @override
  void disposeResources() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
  }
}
