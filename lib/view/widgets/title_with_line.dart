import 'package:flutter/material.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:sizer/sizer.dart';

class TitleWithLine extends StatelessWidget {
  final double lineHeight;
  final double lineWidth;
  final double fontSize;
  final String text;
  final Color? textColor;
  final Color? lineColor;

  const TitleWithLine({
    required this.lineHeight,
    required this.lineWidth,
    required this.fontSize,
    required this.text,
    this.textColor,
    this.lineColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 2.w),
          height: lineHeight,
          width: lineWidth,
          decoration: BoxDecoration(
            color: lineColor ?? ColorsConstant.appColor,
            borderRadius: BorderRadius.circular(1.h),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: textColor ?? ColorsConstant.textDark,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
