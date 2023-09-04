import 'package:flutter/material.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/text_with_prefix_icon.dart';
import 'package:sizer/sizer.dart';

class BookedSalonAndArtistName extends StatelessWidget {
  final String nameText;
  final String headerText;
  final String headerIconPath;

  const BookedSalonAndArtistName({
    super.key,
    required this.nameText,
    required this.headerText,
    required this.headerIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextWithPrefixIcon(
            iconPath: headerIconPath,
            iconHeight: 2.h,
            text: headerText,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            textColor: ColorsConstant.appColor,
          ),
          SizedBox(height: 0.5.h),
          Text(
            nameText,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: ColorsConstant.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
