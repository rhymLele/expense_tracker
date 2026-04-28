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
import 'login_view_model.dart';

/// View — StatelessWidget thuần.
/// Không có bất kỳ logic nào. Chỉ render + forward action đến ViewModel.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<LoginViewModel>();

    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (ctx, state) => _onStateChanged(ctx, state, vm),
      builder: (ctx, state) => _buildScaffold(ctx, state, vm),
    );
  }

  // ─── Listener ─────────────────────────────────────────────────────────────

  void _onStateChanged(BuildContext ctx, LoginState state, LoginViewModel vm) {
    if (state.isSuccess && state.user != null) {
      ctx.read<AuthBloc>().add(AuthLoginSucceeded(state.user!));
      Navigator.pushReplacementNamed(ctx, AppRoutes.home);
      return;
    }
    if (state.isFailure) {
      ScaffoldMessenger.of(ctx)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(state.errorMessage ?? 'Đăng nhập thất bại'),
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

  // ─── Builder ──────────────────────────────────────────────────────────────

  Widget _buildScaffold(BuildContext ctx, LoginState state, LoginViewModel vm) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(ctx).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingXl,
            vertical: AppSizes.paddingXxl,
          ),
          child: Form(
            key: vm.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSizes.xxxl),
                const _Header(),
                const SizedBox(height: AppSizes.xxxl),
                _EmailField(vm: vm),
                const SizedBox(height: AppSizes.paddingLg),
                _PasswordField(vm: vm, state: state),
                const SizedBox(height: AppSizes.paddingSm),
                const _ForgotPasswordButton(),
                const SizedBox(height: AppSizes.xxxl),
                _SubmitButton(onPressed: vm.submit, isLoading: state.isLoading),
                if (state.showEnrollmentChangedWarning) ...[
                  const SizedBox(height: AppSizes.paddingMd),
                  _EnrollmentChangedBanner(onReset: vm.resetBiometric),
                ],
                if (state.showBiometricButton) ...[
                  const SizedBox(height: AppSizes.paddingLg),
                  _BiometricButton(
                    onPressed: vm.authenticateWithBiometric,
                    isLoading: state.isBiometricLoading,
                  ),
                ],
                const SizedBox(height: AppSizes.paddingLg),
                const _RegisterLink(),
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
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: const Icon(Icons.lock_outline, color: AppColors.background, size: 28),
          ),
          const SizedBox(height: AppSizes.paddingLg),
          const Text('Đăng nhập', style: AppTextStyles.displayMedium),
          const SizedBox(height: AppSizes.paddingSm),
          const Text('Chào mừng bạn trở lại!', style: AppTextStyles.bodyLarge),
        ],
      );
}

class _EmailField extends StatelessWidget {
  final LoginViewModel vm;
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
  final LoginViewModel vm;
  final LoginState state;
  const _PasswordField({required this.vm, required this.state});

  @override
  Widget build(BuildContext context) => BaseTextField(
        controller: vm.passwordController,
        labelText: 'Mật khẩu',
        hintText: '••••••••',
        obscureText: state.obscurePassword,
        textInputAction: TextInputAction.done,
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

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
          child: const Text('Quên mật khẩu?', style: AppTextStyles.bodyMedium),
        ),
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
                'Đăng nhập',
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      );
}

class _RegisterLink extends StatelessWidget {
  const _RegisterLink();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Chưa có tài khoản?', style: AppTextStyles.bodyMedium),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
            child: const Text('Đăng ký ngay'),
          ),
        ],
      );
}

class _EnrollmentChangedBanner extends StatelessWidget {
  final VoidCallback onReset;
  const _EnrollmentChangedBanner({required this.onReset});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.warning, width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
            const SizedBox(width: AppSizes.paddingSm),
            Expanded(
              child: Text(
                'Thông tin sinh trắc học đã thay đổi. Vui lòng thiết lập lại.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
              ),
            ),
            TextButton(
              onPressed: onReset,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.warning,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSm),
              ),
              child: const Text('Đặt lại', style: AppTextStyles.labelMedium),
            ),
          ],
        ),
      );
}

class _BiometricButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  const _BiometricButton({required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
        ),
        child: isLoading
            ? const BaseLoading(color: AppColors.primary, size: 24)
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fingerprint, color: AppColors.primary, size: 24),
                  SizedBox(width: AppSizes.paddingSm),
                  Text(
                    'Đăng nhập bằng sinh trắc học',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      );
}
