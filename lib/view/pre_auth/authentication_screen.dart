import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/view/utils/colors_constant.dart';
import 'package:naai/view/utils/image_path_constant.dart';
import 'package:naai/view/utils/routing/named_routes.dart';
import 'package:naai/view/utils/string_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:sizer/sizer.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: <Widget>[
                SvgPicture.asset(ImagePathConstant.inAppLogo),
                SizedBox(height: 2.h),
                Text(
                  StringConstant.splashScreenText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  cursorColor: ColorsConstant.appColor,
                  maxLength: 10,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                  ],
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorsConstant.appColorAccent,
                    hintText: StringConstant.enterMobileNumber,
                    hintStyle: TextStyle(
                      fontSize: 12.sp,
                      color: ColorsConstant.enterMobileTextColor,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    counterText: ''
                  ),
                ),
                SizedBox(height: 4.h),
                ReusableWidgets.redFullWidthButon(
                  buttonText: StringConstant.getOtp,
                  onTap: () => print('OTP TAPPED'),
                  isActive: false,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: <Widget>[
                    SizedBox(width: 5.w),
                    Expanded(
                      child: Divider(
                        thickness: 2.0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        StringConstant.or,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2.0,
                      ),
                    ),
                    SizedBox(width: 5.w),
                  ],
                ),
                SizedBox(height: 3.h),
                ReusableWidgets.socialSigninButton(
                  isAppleLogin: false,
                  onTap: () => Navigator.pushNamed(context, NamedRoutes.verifyOtpRoute),
                ),
                SizedBox(height: 2.h),
                ReusableWidgets.socialSigninButton(
                  isAppleLogin: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
