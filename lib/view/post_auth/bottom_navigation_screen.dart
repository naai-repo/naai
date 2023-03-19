import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/post_auth/explore/explore_screen.dart';
import 'package:naai/view/post_auth/home/home_screen.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/view_model/post_auth/bottom_navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:sizer/sizer.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with WidgetsBindingObserver {
  late List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    Scaffold(
      body: Center(
        child: Text('Maps'),
      ),
    ),
    Scaffold(
      body: Center(
        child: Text('Profile'),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, provider, child) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            body: _screens[provider.currentScreenIndex],
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.h),
                  topRight: Radius.circular(3.h),
                ),
              ),
              child: SalomonBottomBar(
                currentIndex: provider.currentScreenIndex,
                onTap: (i) => provider.setCurrentScreenIndex(i),
                items: <SalomonBottomBarItem>[
                  _bottomWidget(
                    provider: provider,
                    tabName: StringConstant.home,
                    image: ImagePathConstant.homeIcon,
                    index: 0,
                  ),
                  _bottomWidget(
                    provider: provider,
                    tabName: StringConstant.explore,
                    image: ImagePathConstant.exploreIcon,
                    index: 1,
                  ),
                  _bottomWidget(
                    provider: provider,
                    tabName: StringConstant.map,
                    image: ImagePathConstant.mapIcon,
                    index: 2,
                  ),
                  _bottomWidget(
                    provider: provider,
                    tabName: StringConstant.profile,
                    image: ImagePathConstant.profileIcon,
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SalomonBottomBarItem _bottomWidget({
    required BottomNavigationProvider provider,
    required String tabName,
    required String image,
    required int index,
  }) {
    return SalomonBottomBarItem(
      icon: SvgPicture.asset(
        image,
        color: provider.currentScreenIndex == index
            ? ColorsConstant.appColor
            : ColorsConstant.bottomNavIconsDisabled,
        height: 3.h,
      ),
      title: Text(
        tabName,
        style: StyleConstant.appColorBoldTextStyle,
      ),
      selectedColor: ColorsConstant.appColor,
    );
  }
}
