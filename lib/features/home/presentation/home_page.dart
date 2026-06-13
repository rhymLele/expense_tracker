import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/router/app_router.dart';
import '../../auth/presentation/shared/auth_cubit.dart';
import '../../auth/presentation/shared/auth_state.dart';
import '../../feed/presentation/bloc/feed_cubit.dart';
import '../../roadmaps/presentation/creation/roadmap_creation_page.dart';
import 'tabs/chat_tab.dart';
import 'tabs/feed_tab.dart';
import 'tabs/profile_tab.dart';
import 'tabs/roadmap_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late final FeedCubit _feedBloc;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _feedBloc = sl<FeedCubit>()..load();
    _tabs = [
      FeedTab(bloc: _feedBloc),
      const RoadmapTab(),
      const ChatTab(),
      const ProfileTab(),
    ];
  }

  @override
  void dispose() {
    _feedBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(index: _currentIndex, children: _tabs),
      ),
      floatingActionButton: _currentIndex == 0 ? _buildFab(context) : null,
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }

  Widget? _buildFab(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) return null;

    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.background,
      tooltip: 'Tạo nội dung',
      onPressed: () => _showCreateSheet(context),
      child: const Icon(Icons.add),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (_) => _CreateSheet(
        onPostTap: () async {
          Navigator.pop(context);
          final created = await Navigator.pushNamed(
            context,
            AppRoutes.createTopic,
          );
          if (created == true) {
            _feedBloc.refresh();
          }
        },
        onJourneyTap: () async {
          Navigator.pop(context);
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RoadmapCreationPage(),
              fullscreenDialog: true,
            ),
          );
        },
      ),
    );
  }
}

// ─── Create Sheet ─────────────────────────────────────────────────────────────

class _CreateSheet extends StatelessWidget {
  final VoidCallback onPostTap;
  final VoidCallback onJourneyTap;

  const _CreateSheet({required this.onPostTap, required this.onJourneyTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.paddingLg),
            const Text('Tạo nội dung', style: AppTextStyles.titleLarge),
            const SizedBox(height: AppSizes.paddingLg),
            _SheetOption(
              icon: Icons.edit_outlined,
              title: 'Đăng bài',
              subtitle: 'Chia sẻ bài viết, hình ảnh lên Feed',
              onTap: onPostTap,
            ),
            const SizedBox(height: AppSizes.paddingSm),
            _SheetOption(
              icon: Icons.route_outlined,
              title: 'Tạo lộ trình học',
              subtitle: 'Thiết kế chương trình học theo ngày',
              onTap: onJourneyTap,
            ),
            const SizedBox(height: AppSizes.paddingMd),
          ],
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: AppSizes.iconMd,
              ),
            ),
            const SizedBox(width: AppSizes.paddingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.labelSmall),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: AppColors.background,
        indicatorColor: AppColors.surface,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          _dest(
            Icons.home_outlined,
            Icons.home,
            'Trang chủ',
            currentIndex == 0,
          ),
          _dest(
            Icons.route_outlined,
            Icons.route,
            'Lộ trình',
            currentIndex == 1,
          ),
          _dest(
            Icons.chat_bubble_outline,
            Icons.chat_bubble,
            'Tin nhắn',
            currentIndex == 2,
          ),
          _dest(Icons.person_outline, Icons.person, 'Hồ sơ', currentIndex == 3),
        ],
      ),
    );
  }

  NavigationDestination _dest(
    IconData icon,
    IconData selectedIcon,
    String label,
    bool selected,
  ) {
    return NavigationDestination(
      icon: Icon(icon, size: AppSizes.iconMd, color: AppColors.textHint),
      selectedIcon: Icon(
        selectedIcon,
        size: AppSizes.iconMd,
        color: AppColors.primary,
      ),
      label: label,
      tooltip: label,
    );
  }
}
