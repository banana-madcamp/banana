import 'package:banana/main/main_home_view.dart';
import 'package:banana/main/main_like_view.dart';
import 'package:banana/main/main_profile_view.dart';
import 'package:banana/utils/values/app_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/values/app_colors.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  List<Widget> _buildScreens() {
    return [MainHomeView(), Container(), MainLikeView(), MainProfileView()];
  }

  List<BottomNavigationBarItem> _navBarsItems() {
    return [
      BottomNavigationBarItem(
        icon: Icon(AppIcons.home, size: 24, color: AppColors.gray),
        label: 'Home',
        activeIcon: Icon(
          AppIcons.homeEnabled,
          size: 24,
          color: AppColors.black,
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(AppIcons.location, size: 24, color: AppColors.gray),
        label: 'Location',
        activeIcon: Icon(
          AppIcons.locationEnabled,
          size: 24,
          color: AppColors.black,
        ),
      ),
      BottomNavigationBarItem(
        label: 'ike',
        icon: Icon(AppIcons.heart, size: 24, color: AppColors.gray),
        activeIcon: Icon(
          AppIcons.heartEnabled,
          size: 24,
          color: AppColors.black,
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(AppIcons.profile, size: 24, color: AppColors.gray),
        label: 'Profile',
        activeIcon: Icon(
          AppIcons.profileEnabled,
          size: 24,
          color: AppColors.black,
        ),
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: mainBottomNavigationBar(),
      body: Center(child: _buildScreens().elementAt(_selectedIndex)),
    );
  }

  Widget mainBottomNavigationBar() {
    return Stack(
      children: [
        BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: _navBarsItems(),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          onTap: (index) => _onItemTapped(index),
        ),
      ],
    );
  }
}
