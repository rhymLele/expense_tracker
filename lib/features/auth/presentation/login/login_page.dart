import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/base_loading.dart';
import '../shared/src.dart';
import 'bloc/src.dart';
import 'login_view_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<LoginViewModel>();
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (prev, curr) => prev.status != curr.status,
      listener: (ctx, state) => _onStateChanged(ctx, state, vm),
      builder: (ctx, state) => _buildScaffold(ctx, state, vm),
    );
  }

  void _onStateChanged(BuildContext ctx, LoginState state, LoginViewModel vm) {
    if (state.isSuccess && state.user != null) {
      ctx.read<AuthCubit>().loginSucceeded(state.user!);
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
            textColor: Colors.white,
            onPressed: vm.dismissError,
          ),
        ));
    }
  }

  Widget _buildScaffold(
      BuildContext ctx, LoginState state, LoginViewModel vm) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () => FocusScope.of(ctx).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          child: Form(
            key: vm.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Hero(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _EmailField(vm: vm),
                      const SizedBox(height: 16),
                      _PasswordField(vm: vm, state: state),
                      const SizedBox(height: 6),
                      _ForgotPasswordBtn(),
                      const SizedBox(height: 20),
                      _LoginButton(
                        isLoading: state.isLoading,
                        onPressed: vm.submit,
                      ),
                      if (state.showEnrollmentChangedWarning) ...[
                        const SizedBox(height: 12),
                        _BiometricWarningBanner(onReset: vm.resetBiometric),
                      ],
                      if (state.showBiometricButton) ...[
                        const SizedBox(height: 12),
                        _BiometricButton(
                          isLoading: state.isBiometricLoading,
                          onPressed: vm.authenticateWithBiometric,
                        ),
                      ],
                      const SizedBox(height: 20),
                      const _Divider(),
                      const SizedBox(height: 16),
                      const _SocialButtons(),
                      const SizedBox(height: 28),
                      const _SignupFooter(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Hero (gradient mint, rounded bottom corners) ────────────────────────────

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary600],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(28, 92, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo icon in frosted box
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.route_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'LearnSpace',
            style: GoogleFonts.inter(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Học tiếng Anh cùng cộng đồng — theo lộ trình, giữ streak, kết nối gia sư.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Form fields ─────────────────────────────────────────────────────────────

class _EmailField extends StatelessWidget {
  final LoginViewModel vm;
  const _EmailField({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email hoặc tên đăng nhập',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: vm.emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: vm.validateEmail,
          decoration: const InputDecoration(
            hintText: 'email@example.com',
          ),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final LoginViewModel vm;
  final LoginState state;
  const _PasswordField({required this.vm, required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mật khẩu',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: vm.passwordController,
          obscureText: state.obscurePassword,
          textInputAction: TextInputAction.done,
          validator: vm.validatePassword,
          onFieldSubmitted: (_) => vm.submit(),
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: IconButton(
              icon: Icon(
                state.obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20,
                color: AppColors.textHint,
              ),
              onPressed: vm.togglePasswordVisibility,
            ),
          ),
        ),
      ],
    );
  }
}

class _ForgotPasswordBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
        child: const Text(
          'Quên mật khẩu?',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primary600,
          ),
        ),
      ),
    );
  }
}

// ─── Primary CTA ─────────────────────────────────────────────────────────────

class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _LoginButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ).copyWith(
          // Mint glow shadow
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
        ),
        child: isLoading
            ? const BaseLoading(color: Colors.white, size: 22)
            : const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// ─── Divider with text ────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.stroke)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'hoặc tiếp tục với',
            style: AppTextStyles.bodySmall,
          ),
        ),
        const Expanded(child: Divider(color: AppColors.stroke)),
      ],
    );
  }
}

// ─── Social buttons ───────────────────────────────────────────────────────────

class _SocialButtons extends StatelessWidget {
  const _SocialButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _SocialBtn(label: 'Google', icon: Icons.g_mobiledata)),
        const SizedBox(width: 12),
        Expanded(child: _SocialBtn(label: 'Apple', icon: Icons.apple)),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  const _SocialBtn({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.stroke),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        minimumSize: const Size(0, 50),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ─── Biometric ────────────────────────────────────────────────────────────────

class _BiometricWarningBanner extends StatelessWidget {
  final VoidCallback onReset;
  const _BiometricWarningBanner({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning50,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.warning),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Thông tin sinh trắc học đã thay đổi. Vui lòng thiết lập lại.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning700),
            ),
          ),
          TextButton(
            onPressed: onReset,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.warning,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text('Đặt lại', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _BiometricButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _BiometricButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const BaseLoading(color: AppColors.primary, size: 18)
          : const Icon(Icons.fingerprint, size: 20),
      label: const Text('Đăng nhập bằng sinh trắc học'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
      ),
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _SignupFooter extends StatelessWidget {
  const _SignupFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Chưa có tài khoản? ',
          style: TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.register),
          child: const Text(
            'Đăng ký ngay',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary600,
            ),
          ),
        ),
      ],
    );
  }
}
