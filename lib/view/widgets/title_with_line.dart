import 'package:flutter/material.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:sizer/sizer.dart';

class TitleWithLine extends StatelessWidget {
  final double lineHeight;
  final double lineWidth;
  final double fontSize;
  final String text;

  const TitleWithLine({
    required this.lineHeight,
    required this.lineWidth,
    required this.fontSize,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 2.w),
            height: lineHeight,
            width: lineWidth,
            decoration: BoxDecoration(
              color: ColorsConstant.appColor,
              borderRadius: BorderRadius.circular(1.h),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: ColorsConstant.textDark,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
