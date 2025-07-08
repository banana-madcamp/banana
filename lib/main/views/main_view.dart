
import 'package:banana/main/bindings/main_initial_bindings.dart';
import 'package:banana/main/views/main_location_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../utils/values/app_colors.dart';
import '../../utils/values/app_icons.dart';
import '../../utils/widgets/persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'main_home_view.dart';
import 'main_like_view.dart';
import 'main_product_add_view.dart';
import 'main_profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  void initState() {
    super.initState();
    MainInitialBindings().dependencies();
  }

  List<Widget> _buildScreens() {
    return [
      MainHomeView(),
      MainLocationView(),
      Container(),
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
        onPressed: (context) {
          _controller.index = 0;
        },
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.location, size: 24),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.gray,
        onPressed: (context) {
          _controller.index = 1;
        },
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.add, size: 32, color: AppColors.white),
        activeColorPrimary: AppColors.primary,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        onPressed: (context) {
          Get.to(() => MainProductAddView(),
               transition: Transition.downToUp);
        },
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.heart, size: 24),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.gray,
        onPressed: (context) {
          _controller.index = 3;
        },
      ),
      PersistentBottomNavBarItem(
        icon: Icon(AppIcons.profile, size: 24),
        activeColorPrimary: AppColors.black,
        inactiveColorPrimary: AppColors.gray,
        onPressed: (context) {
          _controller.index = 4;
        },
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
      controller: _controller,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
        ),
      ),
    );
  }
}
