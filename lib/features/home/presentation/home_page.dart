import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/base/base_view.dart';
import '../../../core/di/service_locator.dart';
import '../../../lingua_thread/theme/lt_colors.dart';
import '../../../lingua_thread/theme/lt_typography.dart';
import '../../feed/presentation/bloc/feed_cubit.dart';
import '../../notifications/presentation/bloc/notifications_cubit.dart';
import '../../notifications/presentation/bloc/notifications_state.dart';
import '../../chat/presentation/chat_tab.dart';
import '../../feed/presentation/feed_tab.dart';
import '../../notifications/presentation/notifications_tab.dart';
import '../../roadmaps/presentation/roadmap_tab.dart';
import 'tabs/profile_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with CubitHost<HomePage> {
  int _currentIndex = 0;
  // own() tự init() khi tạo và tự close() khi dispose.
  late final NotificationsCubit _notifCubit = own(sl<NotificationsCubit>());
  late final FeedCubit _feedCubit = own(sl<FeedCubit>());

  // 0=Feed, 1=Lộ trình, 2=Chat, 3=Thông báo, 4=Me
  static const _tabs = <Widget>[
    FeedTab(),
    RoadmapTab(),
    ChatTab(),
    NotificationsTab(),
    ProfileTab(),
  ];

  void _onNavTap(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _notifCubit),
        BlocProvider.value(value: _feedCubit),
      ],
      child: Scaffold(
        backgroundColor: LtColors.bg,
        body: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
        bottomNavigationBar: BlocBuilder<NotificationsCubit, NotificationsState>(
          buildWhen: (p, c) => p.unreadCount != c.unreadCount,
          builder: (_, notifState) => _LtNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
            unreadCount: notifState.unreadCount,
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

class _LtNavBar extends StatelessWidget {
  const _LtNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.unreadCount,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: LtColors.divider)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: 55,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_outlined, iconActive: Icons.home,
              label: 'Home', active: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.route_outlined, iconActive: Icons.route,
              label: 'Lộ trình', active: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.chat_bubble_outline, iconActive: Icons.chat_bubble,
              label: 'Chat', active: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            _NavItem(
              icon: Icons.notifications_outlined,
              iconActive: Icons.notifications,
              label: 'Thông báo', active: currentIndex == 3,
              onTap: () => onTap(3),
              badgeCount: unreadCount,
            ),
            _NavItem(
              icon: Icons.person_outline, iconActive: Icons.person,
              label: 'Me', active: currentIndex == 4,
              onTap: () => onTap(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.iconActive,
    required this.label,
    required this.active,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData iconActive;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  active ? iconActive : icon,
                  size: 24,
                  color: active ? LtColors.ink : LtColors.textDim,
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -2,
                    right: -4,
                    child: Container(
                      constraints:
                          const BoxConstraints(minWidth: 15, minHeight: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        badgeCount > 9 ? '9+' : '$badgeCount',
                        style: const TextStyle(
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: LtTypography.micro.copyWith(
                color: active ? LtColors.ink : LtColors.textDim,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
