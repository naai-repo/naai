import 'package:flutter/material.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:sizer/sizer.dart';

class VariableWidthCta extends StatelessWidget {
  final Function() onTap;
  final String buttonText;

  const VariableWidthCta({
    super.key,
    required this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 1.7.h,
          horizontal: 3.w,
        ),
        decoration: BoxDecoration(
          color: ColorsConstant.appColor,
          borderRadius: BorderRadius.circular(1.5.h),
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
}
