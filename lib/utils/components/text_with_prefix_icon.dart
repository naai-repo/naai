import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class TextWithPrefixIcon extends StatelessWidget {
  final String text;
  final String iconPath;
  final double? iconHeight;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final Color? iconColor;

  const TextWithPrefixIcon({
    super.key,
    required this.iconPath,
    required this.text,
    this.iconHeight,
    this.iconColor,
    this.fontSize,
    this.fontWeight,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SvgPicture.asset(
          iconPath,
          height: iconHeight,
          color: iconColor,
        ),
        SizedBox(width: 1.w),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
