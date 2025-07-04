import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/values/app_colors.dart';
import '../utils/values/app_icons.dart';
import '../utils/widgets/persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'main_home_view.dart';
import 'main_like_view.dart';
import 'main_product_add_view.dart';
import 'main_profile_view.dart';

class MainBottomNavigationBar extends StatefulWidget {
  const MainBottomNavigationBar({super.key});

  @override
  State<MainBottomNavigationBar> createState() =>
      _MainBottomNavigationBarState();
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  List<Widget> _buildScreens() {
    return [
      MainHomeView(),
      Container(),
      MainProductAddView(),
      MainLikeView(),
      MainProfileView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.home, size: 24),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.gray,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.location, size: 24),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.gray,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.add, size: 32, color: AppColors.white),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.heart, size: 24),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.gray,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.profile, size: 24),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.gray,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navBarsItems(),
      navBarStyle: NavBarStyle.style15,
    );
  }


}
