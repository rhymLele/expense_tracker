import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/base_button.dart';
import '../../../../core/widgets/base_icon_button.dart';
import '../../../../core/widgets/base_loading.dart';
import '../../../../core/widgets/base_text_field.dart';
import '../shared/src.dart';
import 'bloc/src.dart';
import 'register_view_model.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<RegisterViewModel>();

    return BlocConsumer<RegisterCubit, RegisterState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (ctx, state) => _onStateChanged(ctx, state, vm),
      builder: (ctx, state) => _buildScaffold(ctx, state, vm),
    );
  }

  void _onStateChanged(BuildContext ctx, RegisterState state, RegisterViewModel vm) {
    if (state.isSuccess && state.user != null) {
      ctx.read<AuthCubit>().loginSucceeded(state.user!);
      Navigator.pushReplacementNamed(ctx, AppRoutes.home);
      return;
    }
    if (state.isFailure) {
      ScaffoldMessenger.of(ctx)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.errorMessage ?? 'Đăng ký thất bại'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Đóng',
            textColor: AppColors.background,
            onPressed: vm.dismissError,
          ),
        ));
    }
  }

  Widget _buildScaffold(BuildContext ctx, RegisterState state, RegisterViewModel vm) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(ctx),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(ctx).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingXl,
              vertical: AppSizes.paddingMd,
            ),
            child: Form(
              key: vm.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
                  const SizedBox(height: AppSizes.xxxl),
                  _NameField(vm: vm),
                  const SizedBox(height: AppSizes.paddingLg),
                  _EmailField(vm: vm),
                  const SizedBox(height: AppSizes.paddingLg),
                  _PasswordField(vm: vm, state: state),
                  const SizedBox(height: AppSizes.paddingLg),
                  _ConfirmPasswordField(vm: vm, state: state),
                  const SizedBox(height: AppSizes.paddingLg),
                  _RoleSelector(
                    selected: state.selectedRole,
                    onChanged: vm.selectRole,
                  ),
                  const SizedBox(height: AppSizes.xxxl),
                  _SubmitButton(onPressed: vm.submit, isLoading: state.isLoading),
                  const SizedBox(height: AppSizes.paddingLg),
                  const _LoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tạo tài khoản', style: AppTextStyles.displayMedium),
          SizedBox(height: AppSizes.paddingSm),
          Text('Điền thông tin để bắt đầu', style: AppTextStyles.bodyLarge),
        ],
      );
}

class _NameField extends StatelessWidget {
  final RegisterViewModel vm;
  const _NameField({required this.vm});

  @override
  Widget build(BuildContext context) => BaseTextField(
        controller: vm.nameController,
        labelText: 'Họ và tên',
        hintText: 'Nguyễn Văn A',
        textInputAction: TextInputAction.next,
        prefixIcon: const Icon(Icons.person_outline, color: AppColors.textHint),
        validator: vm.validateName,
      );
}

class _EmailField extends StatelessWidget {
  final RegisterViewModel vm;
  const _EmailField({required this.vm});

  @override
  Widget build(BuildContext context) => BaseTextField(
        controller: vm.emailController,
        labelText: 'Email',
        hintText: 'name@example.com',
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textHint),
        validator: vm.validateEmail,
      );
}

class _PasswordField extends StatelessWidget {
  final RegisterViewModel vm;
  final RegisterState state;
  const _PasswordField({required this.vm, required this.state});

  @override
  Widget build(BuildContext context) => BaseTextField(
        controller: vm.passwordController,
        labelText: 'Mật khẩu',
        hintText: '••••••••',
        obscureText: state.obscurePassword,
        textInputAction: TextInputAction.next,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textHint),
        suffixIcon: BaseIconButton(
          icon: Icon(
            state.obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textHint,
          ),
          onPressed: vm.togglePasswordVisibility,
        ),
        validator: vm.validatePassword,
      );
}

class _ConfirmPasswordField extends StatelessWidget {
  final RegisterViewModel vm;
  final RegisterState state;
  const _ConfirmPasswordField({required this.vm, required this.state});

  @override
  Widget build(BuildContext context) => BaseTextField(
        controller: vm.confirmController,
        labelText: 'Xác nhận mật khẩu',
        hintText: '••••••••',
        obscureText: state.obscureConfirmPassword,
        textInputAction: TextInputAction.done,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textHint),
        suffixIcon: BaseIconButton(
          icon: Icon(
            state.obscureConfirmPassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: AppColors.textHint,
          ),
          onPressed: vm.toggleConfirmPasswordVisibility,
        ),
        validator: vm.validateConfirmPassword,
      );
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  const _SubmitButton({required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) => BaseButton(
        width: double.infinity,
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const BaseLoading(color: AppColors.background, size: 24)
            : const Text(
                'Đăng ký',
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      );
}

class _RoleSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _RoleSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bạn là', style: AppTextStyles.labelMedium),
        const SizedBox(height: AppSizes.paddingSm),
        Row(
          children: [
            Expanded(child: _RoleOption(
              label: 'Học viên',
              icon: Icons.school_outlined,
              value: 'student',
              selected: selected,
              onTap: onChanged,
            )),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(child: _RoleOption(
              label: 'Giáo viên',
              icon: Icons.cast_for_education_outlined,
              value: 'teacher',
              selected: selected,
              onTap: onChanged,
            )),
          ],
        ),
      ],
    );
  }
}

class _RoleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final String selected;
  final ValueChanged<String> onTap;
  const _RoleOption({
    required this.label,
    required this.icon,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.paddingMd,
          horizontal: AppSizes.paddingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? AppColors.primary : AppColors.textHint,
                size: 20),
            const SizedBox(width: AppSizes.paddingXs),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginLink extends StatelessWidget {
  const _LoginLink();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Đã có tài khoản?', style: AppTextStyles.bodyMedium),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đăng nhập'),
          ),
        ],
      );
}
