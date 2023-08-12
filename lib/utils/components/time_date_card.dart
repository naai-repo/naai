import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TimeDateCard extends StatelessWidget {
  final Widget child;
  final Color? fillColor;

  const TimeDateCard({
    super.key,
    required this.child,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 0.5.h,
        horizontal: 2.5.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.h),
        color: fillColor ?? const Color(0xFFEBEBEB),
      ),
      child: child,
    );
  }
}
