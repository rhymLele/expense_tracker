import 'package:flutter/material.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/validators/app_validator.dart';
import '../../domain/usecases/register_usecase.dart';
import 'bloc/register_cubit.dart';

class RegisterViewModel extends BaseViewModel<RegisterCubit> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  RegisterViewModel({required RegisterUseCase registerUseCase})
      : super(RegisterCubit(registerUseCase: registerUseCase)) {
    bloc.started();
  }

  void selectRole(String role) => bloc.changeRole(role);

  void submit() {
    if (!formKey.currentState!.validate()) return;
    bloc.submit(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      role: bloc.state.selectedRole,
    );
  }

  void togglePasswordVisibility() => bloc.togglePasswordVisibility();

  void toggleConfirmPasswordVisibility() => bloc.toggleConfirmPasswordVisibility();

  void dismissError() => bloc.dismissError();

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
