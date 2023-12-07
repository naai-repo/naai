import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class ColorfulInformationCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final Color color;

  const ColorfulInformationCard({
    super.key,
    required this.imagePath,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 13.w),
      padding: EdgeInsets.symmetric(
        vertical: 0.3.h,
        horizontal: 2.w,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(0.5.h),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withOpacity(0.14),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SvgPicture.asset(
            imagePath,
            color: Colors.white,
            height: 2.h,
          ),
          SizedBox(width: 1.5.w),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

