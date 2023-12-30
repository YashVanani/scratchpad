import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const List<TabItem> pItems = [
  TabItem(
    icon: Icons.home,
    title: 'Home',
    key: 'teachers-home',
  ),
  TabItem(
    icon: Icons.dashboard,
    title: 'Dashboard',
    key: 'parents-report',
  ),
  TabItem(
    icon: Icons.menu_book,
    title: 'Playbook',
    key: 'parents-playbook',
  ),
   TabItem(
    icon: Icons.av_timer,
    title: 'My Space',
    key: 'parents-playbook',
  ),
  TabItem(
    icon: Icons.account_circle,
    title: 'Profile',
    key: 'parents-profile',
  ),
  
];

class TeachersBottomBar extends StatelessWidget {
  final String selected;
  const TeachersBottomBar({
    super.key,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomBarFloating(
      items: pItems,
      backgroundColor: Colors.white,
      color: const Color(0xFF98A2B3),
      colorSelected: const Color(0xFF04686E),
      indexSelected: pItems.indexWhere((e) => e.key == selected),
      paddingVertical: 12,
      onTap: (int index) => GoRouter.of(context).goNamed(pItems[index].key!),
    );
  }
}
