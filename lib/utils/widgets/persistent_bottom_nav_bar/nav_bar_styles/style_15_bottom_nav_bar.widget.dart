part of '../persistent_bottom_nav_bar.dart';

class _BottomNavStyle15 extends StatelessWidget {
  const _BottomNavStyle15({
    required this.navBarEssentials,
    super.key,
    this.navBarDecoration = const NavBarDecoration(),
  });

  final _NavBarEssentials navBarEssentials;
  final NavBarDecoration? navBarDecoration;

  Widget _buildItem(
    final BuildContext context,
    final PersistentBottomNavBarItem item,
    final bool isSelected,
    final double? height,
  ) =>
      navBarEssentials.navBarHeight == 0
          ? const SizedBox.shrink()
          : Container(
            width: 150,
            height: height,
            color: Colors.transparent,
            padding: EdgeInsets.only(
              top: navBarEssentials.padding.top,
              bottom: navBarEssentials.padding.bottom,
            ),
            child: Container(
              alignment: Alignment.center,
              height: height,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: IconTheme(
                          data: IconThemeData(
                            size: item.iconSize,
                            color:
                                isSelected
                                    ? (item.activeColorSecondary ??
                                        item.activeColorPrimary)
                                    : item.inactiveColorPrimary ??
                                        item.activeColorPrimary,
                          ),
                          child:
                              isSelected
                                  ? item.icon
                                  : item.inactiveIcon ?? item.icon,
                        ),
                      ),
                      if (item.title == null)
                        const SizedBox.shrink()
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Material(
                            type: MaterialType.transparency,
                            child: FittedBox(
                              child: Text(
                                item.title!,
                                style:
                                    item.textStyle != null
                                        ? (item.textStyle!.apply(
                                          color:
                                              isSelected
                                                  ? (item.activeColorSecondary ??
                                                      item.activeColorPrimary)
                                                  : item.inactiveColorPrimary,
                                        ))
                                        : TextStyle(
                                          color:
                                              isSelected
                                                  ? (item.activeColorSecondary ??
                                                      item.activeColorPrimary)
                                                  : item.inactiveColorPrimary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );

  Widget _buildMiddleItem(
    final PersistentBottomNavBarItem item,
    final bool isSelected,
    final double? height,
  ) =>
      navBarEssentials.navBarHeight == 0
          ? const SizedBox.shrink()
          : Padding(
            padding: EdgeInsets.only(
              top: navBarEssentials.padding.top,
              bottom: navBarEssentials.padding.bottom,
            ),
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(0, -23),
                  child: Container(
                    width: 150,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 10,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                      boxShadow: navBarDecoration!.boxShadow,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.activeColorPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF613EEA).withOpacity(0.5),
                            spreadRadius: 0,
                            blurRadius: 5.0,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: IconTheme(
                        data: IconThemeData(
                          size: item.iconSize,
                          color:
                              item.activeColorSecondary ??
                              item.activeColorPrimary,
                        ),
                        child:
                            isSelected
                                ? item.icon
                                : item.inactiveIcon ?? item.icon,
                      ),
                    ),
                  ),
                ),

                if (item.title == null)
                  const SizedBox.shrink()
                else
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      type: MaterialType.transparency,
                      child: FittedBox(
                        child: Text(
                          item.title!,
                          style:
                              item.textStyle != null
                                  ? (item.textStyle!.apply(
                                    color:
                                        isSelected
                                            ? (item.activeColorSecondary ??
                                                item.activeColorPrimary)
                                            : item.inactiveColorPrimary,
                                  ))
                                  : TextStyle(
                                    color:
                                        isSelected
                                            ? (item.activeColorPrimary)
                                            : item.inactiveColorPrimary,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );

  @override
  Widget build(final BuildContext context) {
    final midIndex = (navBarEssentials.items.length / 2).floor();
    return SizedBox(
      width: double.infinity,
      height: navBarEssentials.navBarHeight,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: navBarDecoration!.borderRadius ?? BorderRadius.zero,
            child: BackdropFilter(
              filter:
                  navBarEssentials
                      .items[navBarEssentials.selectedIndex]
                      .filter ??
                  ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Row(
                mainAxisAlignment: navBarEssentials.navBarItemsAlignment,
                children:
                    navBarEssentials.items.map((final item) {
                      final int index = navBarEssentials.items.indexOf(item);
                      return Flexible(
                        child: GestureDetector(
                          onTap: () {
                            if (index != navBarEssentials.selectedIndex) {
                              navBarEssentials
                                  .items[index]
                                  .iconAnimationController
                                  ?.forward();
                              navBarEssentials
                                  .items[navBarEssentials.selectedIndex]
                                  .iconAnimationController
                                  ?.reverse();
                            }
                            if (navBarEssentials.items[index].onPressed !=
                                null) {
                              navBarEssentials.items[index].onPressed!(
                                navBarEssentials.selectedScreenBuildContext,
                              );
                            } else {
                              navBarEssentials.onItemSelected?.call(index);
                            }
                          },
                          child:
                              index == midIndex
                                  ? Container(
                                    width: 150,
                                    color: Colors.transparent,
                                  )
                                  : _buildItem(
                                    context,
                                    item,
                                    navBarEssentials.selectedIndex == index,
                                    navBarEssentials.navBarHeight,
                                  ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          if (navBarEssentials.navBarHeight == 0)
            const SizedBox.shrink()
          else
            Center(
              child: GestureDetector(
                onTap: () {
                  if (midIndex != navBarEssentials.selectedIndex) {
                    navBarEssentials.items[midIndex].iconAnimationController
                        ?.forward();
                    navBarEssentials
                        .items[navBarEssentials.selectedIndex]
                        .iconAnimationController
                        ?.reverse();
                  } else {
                    if (navBarEssentials
                            .items[midIndex]
                            .iconAnimationController
                            ?.isCompleted ??
                        false) {
                      navBarEssentials.items[midIndex].iconAnimationController
                          ?.reverse();
                    } else {
                      navBarEssentials
                          .items[navBarEssentials.selectedIndex]
                          .iconAnimationController
                          ?.forward();
                    }
                  }

                  if (navBarEssentials.items[midIndex].onPressed != null) {
                    navBarEssentials.items[midIndex].onPressed!(
                      navBarEssentials.selectedScreenBuildContext,
                    );
                  } else {
                    navBarEssentials.onItemSelected?.call(midIndex);
                  }
                },
                child: _buildMiddleItem(
                  navBarEssentials.items[midIndex],
                  navBarEssentials.selectedIndex == midIndex,
                  navBarEssentials.navBarHeight,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
