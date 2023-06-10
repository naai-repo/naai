import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:sizer/sizer.dart';

class AddReviewComponent extends StatelessWidget {
  final String? userId;
  final String? salonId;
  final String? artistId;

  const AddReviewComponent({
    super.key,
    this.userId,
    this.salonId,
    this.artistId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 2.h,
        horizontal: 5.w,
      ),
      decoration: BoxDecoration(
        color: ColorsConstant.graphicFillDark,
        borderRadius: BorderRadius.circular(2.h),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                ImagePathConstant.addYourReviewIcon,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(width: 5.w),
              Text(
                StringConstant.addYourReview,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(width: 5.w),
              ...List.generate(
                5,
                (index) => SvgPicture.asset(
                  ImagePathConstant.reviewStarIcon,
                  color: Colors.grey.shade300,
                ),
              ),
              SizedBox(width: 5.w),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 6.h,
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: StringConstant.summarizeYourReview,
                hintStyle: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorsConstant.textLight,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(1.5.h),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 1.5.h,
              horizontal: 10.w,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1.5.h),
            ),
            child: Text(
              StringConstant.submitReview,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 11.sp,
                color: ColorsConstant.appColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
