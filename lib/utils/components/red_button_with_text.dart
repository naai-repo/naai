import 'package:flutter/material.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:sizer/sizer.dart';

class RedButtonWithText extends StatelessWidget {
  final String buttonText;
  final Function() onTap;
  final Color? fillColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsets? padding;
  final Border? border;
  final bool shouldShowBoxShadow;

  const RedButtonWithText({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.fillColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.border,
    this.shouldShowBoxShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1.h),
          boxShadow: shouldShowBoxShadow
              ? <BoxShadow>[
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 1,
                    color: ColorsConstant.dropShadowColor,
                  ),
                ]
              : null,
          border: border ?? null,
          color: fillColor ?? ColorsConstant.appColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              buttonText,
              style: TextStyle(
                fontSize: fontSize ?? 12.sp,
                fontWeight: fontWeight ?? FontWeight.w600,
                color: textColor ?? Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
