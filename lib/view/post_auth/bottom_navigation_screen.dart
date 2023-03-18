import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/view/post_auth/explore/explore_screen.dart';
import 'package:naai/view/post_auth/home/home_screen.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/view_model/post_auth/bottom_navigation_provider.dart';
import 'package:provider/provider.dart';
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
              padding: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.h),
                  topRight: Radius.circular(3.h),
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _bottomWidget(
                            image: ImagePathConstant.homeIcon,
                            index: 0,
                            onTap: () => provider.setCurrentScreenIndex(0)),
                        _bottomWidget(
                          image: ImagePathConstant.exploreIcon,
                          index: 1,
                          onTap: () => provider.setCurrentScreenIndex(1),
                        ),
                        _bottomWidget(
                          image: ImagePathConstant.mapIcon,
                          index: 2,
                          onTap: () => provider.setCurrentScreenIndex(2),
                        ),
                        _bottomWidget(
                          image: ImagePathConstant.profileIcon,
                          index: 3,
                          onTap: () => provider.setCurrentScreenIndex(3),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomWidget({
    required String image,
    required int index,
    required VoidCallback onTap,
  }) {
    return Consumer<BottomNavigationProvider>(
        builder: (context, provider, child) {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              image,
              color: provider.currentScreenIndex == index
                  ? ColorsConstant.appColor
                  : ColorsConstant.bottomNavIconsDisabled,
              height: 2.5.h,
            ),
          ],
        ),
      );
    });
  }
}
