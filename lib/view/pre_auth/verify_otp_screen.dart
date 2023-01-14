import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/view/utils/colors_constant.dart';
import 'package:naai/view/utils/image_path_constant.dart';
import 'package:naai/view/utils/string_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:sizer/sizer.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        title: IconButton(
          onPressed: () => Navigator.pop(context),
          splashRadius: 0.1,
          splashColor: Colors.transparent,
          icon: SvgPicture.asset(
            ImagePathConstant.backArrowIos,
          ),
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                StringConstant.enterVerificationCode,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                children: <Widget>[
                  Text(
                    StringConstant.enterOtpSubtext,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorsConstant.lightGreyText,
                    ),
                  ),
                  Text(
                    '+91-9873673057',
                    style: TextStyle(
                      color: ColorsConstant.darkGreyText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 7.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ReusableWidgets.otpTextBox(),
                    ReusableWidgets.otpTextBox(),
                    ReusableWidgets.otpTextBox(),
                    ReusableWidgets.otpTextBox(),
                  ],
                ),
              ),
              ReusableWidgets.redFullWidthButon(
                buttonText: StringConstant.verifyNumber,
                onTap: () {},
                isActive: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}
