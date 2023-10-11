import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/profile/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().getUserDataFromUserProvider(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  ReusableWidgets.transparentFlexibleSpace(),
                  SliverAppBar(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(3.h),
                        topRight: Radius.circular(3.h),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    pinned: true,
                    floating: true,
                    title: Container(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: Text(
                        StringConstant.yourProfile,
                        style: StyleConstant.headingTextStyle,
                      ),
                    ),
                    centerTitle: false,
                  ),
                  SliverFillRemaining(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 2.h, right: 5.w, left: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 7.h,
                                  backgroundImage: AssetImage(
                                    'assets/images/salon_dummy_image.png',
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                userDetailsWithEditButton(),
                              ],
                            ),
                            SizedBox(height: 3.h),
                            Column(
                              children: <Widget>[
                                profileOptions(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    NamedRoutes.reviewsRoute,
                                  ),
                                  imagePath: ImagePathConstant.reviewsIcon,
                                  optionTitle: StringConstant.reviews,
                                ),
                                profileOptions(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    NamedRoutes.favouritesRoute,
                                  ),
                                  imagePath: ImagePathConstant.saveIcon,
                                  optionTitle: StringConstant.favourties,
                                ),
                                profileOptions(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    NamedRoutes.bookingHistoryRoute,
                                  ),
                                  imagePath:
                                      ImagePathConstant.bookingHistoryIcon,
                                  optionTitle: StringConstant.bookingHistory,
                                ),
                                // profileOptions(
                                //   onTap: () => print('tapped'),
                                //   imagePath: ImagePathConstant.referralIcon,
                                //   optionTitle: StringConstant.referral,
                                // ),
                                // profileOptions(
                                //   onTap: () => print('tapped'),
                                //   imagePath:
                                //       ImagePathConstant.salonRegistrationIcon,
                                //   optionTitle: StringConstant.salonRegistration,
                                // ),
                                // profileOptions(
                                //   onTap: () => print('tapped'),
                                //   imagePath: ImagePathConstant.settingsIcon,
                                //   optionTitle: StringConstant.settings,
                                // ),
                                profileOptions(
                                  onTap: () => launchUrl(
                                    Uri.parse(
                                        'https://www.instagram.com/naaiindia'),
                                  ),
                                  imagePath: ImagePathConstant.informationIcon,
                                  optionTitle: StringConstant.more,
                                ),
                                profileOptions(
                                  onTap: () =>
                                      provider.handleLogoutClick(context),
                                  imagePath: ImagePathConstant.logoutIcon,
                                  optionTitle: StringConstant.logout,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget profileOptions({
    required Function() onTap,
    required String imagePath,
    required String optionTitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: optionTitle == StringConstant.logout
                  ? Colors.white
                  : ColorsConstant.graphicFillDark,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  imagePath,
                ),
                SizedBox(width: 3.w),
                Text(
                  optionTitle,
                  style: StyleConstant.userProfileOptionsStyle,
                ),
              ],
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.textDark,
              height: 1.5.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget userDetailsWithEditButton() {
    return Consumer<ProfileProvider>(builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(provider.userData.name ?? '',
                      style: StyleConstant.textDark15sp600Style),
                  Text(
                    provider.userData.phoneNumber ??
                        provider.userData.gmailId ??
                        '',
                    style: TextStyle(
                      color: ColorsConstant.textLight,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
              // SizedBox(width: 3.w),
              // Container(
              //   padding: EdgeInsets.all(1.1.h),
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Colors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         offset: Offset(2, 2),
              //         color: Colors.grey.shade300,
              //         spreadRadius: 0.5,
              //         blurRadius: 15,
              //       ),
              //     ],
              //   ),
              //   child: SvgPicture.asset(
              //     ImagePathConstant.pencilIcon,
              //   ),
              // ),
            ],
          ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.8.h),
          //   margin: EdgeInsets.only(top: 1.5.h),
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       color: ColorsConstant.incompleteProfileBoxBorderColor,
          //     ),
          //     borderRadius: BorderRadius.circular(1.h),
          //     color: ColorsConstant.incompleteProfileBoxColor,
          //   ),
          //   child: Text(
          //     StringConstant.incompleteProfile,
          //     style: TextStyle(
          //       fontWeight: FontWeight.w500,
          //       fontSize: 10.sp,
          //       color: ColorsConstant.textDark,
          //     ),
          //   ),
          // ),
        ],
      );
    });
  }
}
