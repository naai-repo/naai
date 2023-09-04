import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:sizer/sizer.dart';

class ContactAndInteractionWidget extends StatelessWidget {
  final Color? backgroundColor;

  final Function() onTapIconOne;
  final Function() onTapIconTwo;
  final Function() onTapIconThree;
  final Function() onTapIconFour;

  final String iconOnePath;
  final String iconTwoPath;
  final String iconThreePath;
  final String iconFourPath;

  const ContactAndInteractionWidget({
    super.key,
    required this.onTapIconOne,
    required this.onTapIconTwo,
    required this.onTapIconThree,
    required this.onTapIconFour,
    required this.iconOnePath,
    required this.iconTwoPath,
    required this.iconThreePath,
    required this.iconFourPath,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 2.5.h,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(2.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: onTapIconOne,
              child: SvgPicture.asset(
                iconOnePath,
                height: 2.5.h,
                fit: BoxFit.fitHeight,
              ),
            ),
            VerticalDivider(
              color: ColorsConstant.dropShadowColor,
              thickness: 0.4.w,
            ),
            GestureDetector(
              onTap: onTapIconTwo,
              child: SvgPicture.asset(
                iconTwoPath,
                height: 2.5.h,
                fit: BoxFit.fitHeight,
              ),
            ),
            VerticalDivider(
              color: ColorsConstant.dropShadowColor,
              thickness: 0.4.w,
            ),
            GestureDetector(
              onTap: onTapIconThree,
              child: SvgPicture.asset(
                iconThreePath,
                height: 2.5.h,
                fit: BoxFit.fitHeight,
              ),
            ),
            VerticalDivider(
              color: ColorsConstant.dropShadowColor,
              thickness: 0.4.w,
            ),
            GestureDetector(
              onTap: onTapIconFour,
              child: SvgPicture.asset(
                iconFourPath,
                height: 2.5.h,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
