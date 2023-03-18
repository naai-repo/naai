import 'package:flutter/material.dart';
import 'dart:math' as math;
// import 'package:naai/utils/colors_constant.dart';
// import 'package:naai/utils/string_constant.dart';
// import 'package:sizer/sizer.dart';

// class CustomAppBar extends SliverPersistentHeaderDelegate {
//   final _maxHeaderExtent = 15.h;
//   final _minHeaderExtent = 10.h;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Align(
//       child: Container(
//         padding: EdgeInsets.only(top: 5.h),
//         width: 100.w,
//         height: 10.h,
//         decoration: BoxDecoration(
//           boxShadow: <BoxShadow>[
//             BoxShadow(
//               blurRadius: shrinkOffset > 11.h
//                   ? 20 * ((shrinkOffset - 7.h) / _maxHeaderExtent)
//                   : 0,
//             )
//           ],
//           color: Colors.red,
//         ),
//         child: Text(
//           StringConstant.exploreSalons,
//           style: TextStyle(
//             color: ColorsConstant.textDark,
//             fontWeight: FontWeight.w600,
//             fontSize: 18.sp,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => _maxHeaderExtent;

//   @override
//   double get minExtent => _minHeaderExtent;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
//       false;
// }

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
