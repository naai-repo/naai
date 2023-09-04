import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/pre_auth/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class VerifyOtpScreen extends StatelessWidget {
  const VerifyOtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: IconButton(
            onPressed: () {
              provider.resetOtpControllers();
              Navigator.pop(context);
            },
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
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  StringConstant.enterVerificationCode,
                  style: TextStyle(
                    fontSize: 19.sp,
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
                      '+91-${provider.mobileNumberController.text}',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                otpTextBoxRow(),
                ReusableWidgets.redFullWidthButton(
                  buttonText: StringConstant.verifyNumber,
                  onTap: () => provider.verifyOtp(context),
                  isActive: provider.isVerifyOtpButtonActive,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget otpTextBoxRow() {
    return Consumer<AuthenticationProvider>(
        builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            otpTextBox(
              controller: provider.otpDigitOneController,
              onChanged: (value) => provider.setOtp(index: 0, digit: value),
            ),
            otpTextBox(
              controller: provider.otpDigitTwoController,
              onChanged: (value) => provider.setOtp(index: 1, digit: value),
            ),
            otpTextBox(
              controller: provider.otpDigitThreeController,
              onChanged: (value) => provider.setOtp(index: 2, digit: value),
            ),
            otpTextBox(
              controller: provider.otpDigitFourController,
              onChanged: (value) => provider.setOtp(index: 3, digit: value),
            ),
            otpTextBox(
              controller: provider.otpDigitFiveController,
              onChanged: (value) => provider.setOtp(index: 4, digit: value),
            ),
            otpTextBox(
              controller: provider.otpDigitSixController,
              onChanged: (value) => provider.setOtp(index: 5, digit: value),
            ),
          ],
        ),
      );
    });
  }

  Widget otpTextBox({
    required TextEditingController controller,
    required Function(String) onChanged,
  }) {
    return Container(
      width: 6.h,
      child: TextFormField(
        controller: controller,
        textInputAction: TextInputAction.next,
        textAlign: TextAlign.center,
        cursorColor: ColorsConstant.appColor,
        keyboardType: TextInputType.phone,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: ColorsConstant.appColorAccent,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorsConstant.appColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          counterText: '',
        ),
        onChanged: onChanged,
      ),
    );
  }
}
