import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:sizer/sizer.dart';

class StyleConstant {
  static TextStyle headingTextStyle = TextStyle(
    color: ColorsConstant.textDark,
    fontWeight: FontWeight.w600,
    fontSize: 18.sp,
  );

  static TextStyle greySemiBoldTextStyle = TextStyle(
    color: ColorsConstant.greySalonAddress,
    fontWeight: FontWeight.w500,
  );

  static TextStyle searchTextStyle = TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle appColorBoldTextStyle = TextStyle(
    color: ColorsConstant.appColor,
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
  );

  static TextStyle userProfileOptionsStyle = TextStyle(
    color: ColorsConstant.textDark,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
  );

  static InputDecoration searchBoxInputDecoration({required String hintText}) =>
      InputDecoration(
        filled: true,
        fillColor: ColorsConstant.graphicFillDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 3.5.w),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 3.5.w),
          child: SvgPicture.asset(
            ImagePathConstant.searchIcon,
            fit: BoxFit.scaleDown,
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 11.w),
        hintText: hintText,
        hintStyle: TextStyle(
          color: ColorsConstant.textLight,
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.h),
          borderSide: BorderSide.none,
        ),
      );
}
