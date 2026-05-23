import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/sizes.dart';
import 'tabs/chat_tab.dart';
import 'tabs/discover_tab.dart';
import 'tabs/feed_tab.dart';
import 'tabs/my_learning_tab.dart';
import 'tabs/profile_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const _tabs = [
    FeedTab(),
    DiscoverTab(),
    MyLearningTab(),
    ChatTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

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
          _destination(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: 'Feed',
            selected: currentIndex == 0,
          ),
          _destination(
            icon: Icons.explore_outlined,
            selectedIcon: Icons.explore,
            label: 'Khám phá',
            selected: currentIndex == 1,
          ),
          _destination(
            icon: Icons.school_outlined,
            selectedIcon: Icons.school,
            label: 'Học tập',
            selected: currentIndex == 2,
          ),
          _destination(
            icon: Icons.chat_bubble_outline,
            selectedIcon: Icons.chat_bubble,
            label: 'Tin nhắn',
            selected: currentIndex == 3,
          ),
          _destination(
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: 'Hồ sơ',
            selected: currentIndex == 4,
          ),
        ],
      ),
    );
  }

  NavigationDestination _destination({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool selected,
  }) {
    return NavigationDestination(
      icon: Icon(icon,
          size: AppSizes.iconMd, color: AppColors.textHint),
      selectedIcon: Icon(selectedIcon,
          size: AppSizes.iconMd, color: AppColors.primary),
      label: label,
      tooltip: label,
    );
  }
}
