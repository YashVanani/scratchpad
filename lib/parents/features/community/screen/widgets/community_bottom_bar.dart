import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

 List<TabItem> items = [
  TabItem(
    icon: Icons.people_outline,
    title: 'Community',
    key: 'parents-community',
  ),
  TabItem(
    icon: Icons.dashboard,
    title: 'My Post',
    key: 'parents-my-post',
  ),
  TabItem(
    icon: Icons.account_circle,
    title: 'Create Post',
    key: 'parents-create-post',
  ),
];

class CommunityNavBar extends StatelessWidget {
  final String selected;
  const CommunityNavBar({
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
