import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:sizer/sizer.dart';

class ReusableWidgets {
  static Widget redFullWidthButon({
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
}
