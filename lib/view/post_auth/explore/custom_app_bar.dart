import 'package:flutter/material.dart';
import 'package:naai/view/utils/colors_constant.dart';
import 'package:naai/view/utils/string_constant.dart';
import 'package:sizer/sizer.dart';

class CustomAppBar extends SliverPersistentHeaderDelegate {
  final _maxHeaderExtent = 15.h;
  final _minHeaderExtent = 10.h;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Align(
      child: Container(
        padding: EdgeInsets.only(top: 5.h),
        width: 100.w,
        height: 10.h,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: shrinkOffset > 11.h
                  ? 20 * ((shrinkOffset - 7.h) / _maxHeaderExtent)
                  : 0,
            )
          ],
          color: Colors.red,
        ),
        child: Text(
          StringConstant.exploreSalons,
          style: TextStyle(
            color: ColorsConstant.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _minHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
