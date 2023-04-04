import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ReusableWidgets {
  static Widget redFullWidthButton({
    required String buttonText,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: isActive ? onTap : null,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 1.7.h),
        decoration: BoxDecoration(
          color: isActive ? ColorsConstant.appColor : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0, 2.0),
                    color: Colors.grey,
                    spreadRadius: 0.2,
                    blurRadius: 15,
                  ),
                ]
              : null,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static Widget socialSigninButton({
    required bool isAppleLogin,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorsConstant.greyBorderColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              isAppleLogin
                  ? ImagePathConstant.appleIcon
                  : ImagePathConstant.googleIcon,
            ),
            SizedBox(width: 10.w),
            Text(
              isAppleLogin
                  ? StringConstant.signInWithApple
                  : StringConstant.signInWithGoogle,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static showFlutterToast(
    BuildContext context,
    String text,
  ) {
    FToast fToast = FToast();
    fToast.init(context);
    fToast.showToast(
      toastDuration: const Duration(seconds: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: ColorsConstant.appColor,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
      gravity: ToastGravity.TOP,
    );
  }

  /// Location icon with circular white background
  static Widget circularLocationWidget() {
    return Flexible(
      flex: 0,
      child: Container(
        padding: EdgeInsets.all(1.3.h),
        margin: EdgeInsets.only(right: 1.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              color: Colors.grey.shade300,
              spreadRadius: 0.5,
              blurRadius: 15,
            ),
          ],
        ),
        child: SvgPicture.asset(
          ImagePathConstant.locationIcon,
          color: ColorsConstant.appColor,
        ),
      ),
    );
  }

  /// Build dialogue box for salon overview, to appear when clicked on salon
  /// location on map.
  static Future<void> salonOverviewOnMapDialogue(
    BuildContext context, {
    required SalonData clickedSalonData,
  }) async {
    await showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 100.h,
            color: Colors.transparent,
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 14.h),
              padding: EdgeInsets.all(1.h),
              width: 90.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: ColorsConstant.appColor),
              ),
              child: Container(
                height: 15.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 15.h,
                        height: 15.h,
                        child: Image.asset(
                          clickedSalonData.imagePath ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            clickedSalonData.name ?? "",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            clickedSalonData.address?.addressString ?? "",
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: ColorsConstant.greySalonAddress,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                clickedSalonData.rating.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11.sp,
                                ),
                              ),
                              SizedBox(width: 1.w),
                              Row(
                                children: <Widget>[
                                  ...List.generate(
                                    5,
                                    (i) => SvgPicture.asset(
                                      ImagePathConstant.starIcon,
                                      color: i <
                                              (clickedSalonData.rating
                                                      ?.floor() ??
                                                  0)
                                          ? ColorsConstant.yellowStar
                                          : ColorsConstant.greyStar,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<ExploreProvider>()
                                  .setSalonIndexByData(
                                    context,
                                    clickedSalonData,
                                  );
                              Navigator.pushNamed(
                                context,
                                NamedRoutes.salonDetailsRoute,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 1.h,
                                horizontal: 5.w,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1.h),
                                color: ColorsConstant.appColor,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    StringConstant.viewSalon,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.rightArrowIcon,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Common background widget for all the four main screens of the app
  static Widget appScreenCommonBackground() {
    return Container(
      height: 100.h,
      color: ColorsConstant.appBackgroundColor,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(
              ImagePathConstant.appBackgroundImage,
              color: ColorsConstant.graphicFill,
            ),
            SvgPicture.asset(
              ImagePathConstant.appBackgroundImage,
              color: ColorsConstant.graphicFill,
            ),
            SvgPicture.asset(
              ImagePathConstant.appBackgroundImage,
              color: ColorsConstant.graphicFill,
            ),
          ],
        ),
      ),
    );
  }

  static Widget recenterWidget(
    BuildContext context, {
    required dynamic provider,
  }) {
    return Positioned(
      top: 2.h,
      right: 2.h,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          Loader.showLoader(context);
          LatLng latLng = await provider.fetchCurrentLocation(context);
          await provider.animateToPosition(latLng);
          Loader.hideLoader(context);
        },
        child: Container(
          height: 5.h,
          width: 5.h,
          padding: EdgeInsets.all(1.h),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Image.asset(ImagePathConstant.currentLocationPointer),
        ),
      ),
    );
  }
}
