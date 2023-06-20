import 'package:flutter/material.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:sizer/sizer.dart';

class VariableWidthCta extends StatelessWidget {
  final Function() onTap;
  final String buttonText;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool isActive;

  const VariableWidthCta({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.horizontalPadding,
    this.verticalPadding,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 1.7.h,
          horizontal: horizontalPadding ?? 3.w,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? ColorsConstant.appColor
              : ColorsConstant.appColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(1.5.h),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade600,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
