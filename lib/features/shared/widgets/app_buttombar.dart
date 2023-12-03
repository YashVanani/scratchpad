import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:go_router/go_router.dart';

const List<TabItem> items = [
  TabItem(
    icon: Icons.home,
    title: 'Home',
    key: 'home',
  ),
  TabItem(
    icon: Icons.dashboard,
    title: 'Leaderboard',
    key: 'leaderboard',
  ),
  TabItem(
    icon: Icons.account_circle,
    title: 'Profile',
    key: 'profile',
  ),
];

class AppNavBar extends StatelessWidget {
  final String selected;
  const AppNavBar({
    super.key,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomBarFloating(
      items: items,
      backgroundColor: Colors.white,
      color: const Color(0xFF98A2B3),
      colorSelected: const Color(0xFF04686E),
      indexSelected: items.indexWhere((e) => e.key == selected),
      paddingVertical: 12,
      onTap: (int index) => GoRouter.of(context).goNamed(items[index].key!),
    );
  }
}
