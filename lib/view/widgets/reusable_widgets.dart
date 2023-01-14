import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/view/utils/colors_constant.dart';
import 'package:naai/view/utils/image_path_constant.dart';
import 'package:naai/view/utils/string_constant.dart';
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
            fontSize: 11.5.sp,
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
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget otpTextBox() {
    return Container(
      height: 7.h,
      width: 7.5.h,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.center,
        showCursor: false,
        cursorColor: ColorsConstant.appColor,
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorsConstant.appColorAccent,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorsConstant.appColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
