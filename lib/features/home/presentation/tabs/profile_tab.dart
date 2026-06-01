import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/shared/auth_bloc.dart';
import '../../../auth/presentation/shared/auth_event.dart';
import '../../../auth/presentation/shared/auth_state.dart';
import '../../../follows/presentation/cubit/follow_cubit.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user =
            state is AuthAuthenticated ? state.user : null;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(user)),
            SliverToBoxAdapter(child: _buildStats(context)),
            SliverPadding(
              padding: const EdgeInsets.all(AppSizes.paddingLg),
              sliver: SliverList.list(children: [
                _buildSection('Tài khoản'),
                _MenuItem(
                  icon: Icons.person_outline,
                  label: 'Thông tin cá nhân',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  label: 'Thông báo',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.lock_outline,
                  label: 'Đổi mật khẩu',
                  onTap: () {},
                ),
                const SizedBox(height: AppSizes.paddingLg),
                _buildSection('Khác'),
                _MenuItem(
                  icon: Icons.help_outline,
                  label: 'Trợ giúp',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  label: 'Về ứng dụng',
                  onTap: () {},
                ),
                const SizedBox(height: AppSizes.paddingLg),
                _LogoutButton(onTap: () => _logout(context)),
                const SizedBox(height: AppSizes.xxxl),
              ]),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(UserEntity? user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.paddingLg,
        AppSizes.paddingXl,
        AppSizes.paddingLg,
        AppSizes.paddingLg,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary,
            backgroundImage: user?.avatarUrl != null
                ? NetworkImage(user!.avatarUrl!)
                : null,
            child: user?.avatarUrl == null
                ? Text(
                    (user?.name.isNotEmpty == true)
                        ? user!.name[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.background,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSizes.paddingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Người dùng',
                  style: AppTextStyles.titleLarge,
                ),
                const SizedBox(height: AppSizes.paddingXs),
                Text(
                  user?.email ?? '',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: AppSizes.paddingXs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingSm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Text(
                    user?.role == 'teacher' ? 'Giáo viên' : 'Học viên',
                    style: AppTextStyles.labelSmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    final followCount = context.watch<FollowCubit?>()?.state.followedIds.length ?? 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingLg),
      padding: const EdgeInsets.all(AppSizes.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          const Expanded(child: _StatItem(value: '0', label: 'Đang học')),
          const _StatDivider(),
          const Expanded(child: _StatItem(value: '0', label: 'Đã hoàn thành')),
          const _StatDivider(),
          Expanded(
            child: _StatItem(
              value: '$followCount',
              label: 'Đang theo dõi',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.paddingSm),
      child: Text(title, style: AppTextStyles.labelMedium),
    );
  }

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineSmall),
        const SizedBox(height: AppSizes.paddingXs),
        Text(label, style: AppTextStyles.labelSmall),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: AppColors.divider,
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingMd),
          child: Row(
            children: [
              Icon(icon, size: AppSizes.iconMd, color: AppColors.textSecondary),
              const SizedBox(width: AppSizes.paddingMd),
              Expanded(
                  child: Text(label, style: AppTextStyles.bodyMedium)),
              const Icon(Icons.chevron_right,
                  size: AppSizes.iconMd, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.paddingMd),
          child: Row(
            children: [
              const Icon(Icons.logout,
                  size: AppSizes.iconMd, color: AppColors.error),
              const SizedBox(width: AppSizes.paddingMd),
              Text(
                'Đăng xuất',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
