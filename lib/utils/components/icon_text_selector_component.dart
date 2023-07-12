import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:sizer/sizer.dart';

class IconTextSelectorComponent extends StatelessWidget {
  final String text;
  final String iconPath;
  final bool isSelected;

  const IconTextSelectorComponent({
    super.key,
    required this.text,
    required this.iconPath,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            SvgPicture.asset(
              iconPath,
              color: isSelected ? ColorsConstant.appColor : null,
            ),
            SizedBox(width: 2.w),
            Text(
              text,
              style: TextStyle(
                color: isSelected
                    ? ColorsConstant.appColor
                    : ColorsConstant.textDark,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SvgPicture.asset(
          isSelected
              ? ImagePathConstant.selectedOption
              : ImagePathConstant.unselectedOption,
          width: 5.w,
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }
}
