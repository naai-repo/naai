import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view/post_auth/home/home_screen.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/pre_auth/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/routing/named_routes.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Perform your actions before closing the app (if any)
        // You can add conditions here if you want to handle back press differently
        SystemNavigator.pop(animated: true);
        return true; // Return true to allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Consumer<AuthenticationProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                      child: Column(
                        children: <Widget>[
                          SvgPicture.asset(ImagePathConstant.inAppLogo),
                          SizedBox(height: 3.h),
                          Text(
                            StringConstant.splashScreenText,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          mobileNumberTextField(),
                          SizedBox(height: 4.h),
                          ReusableWidgets.redFullWidthButton(
                            buttonText: StringConstant.getOtp,
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              provider.phoneNumberLogin(context);
                            },
                            isActive: provider.isGetOtpButtonActive,
                          ),
                          SizedBox(height: 4.h),
                          if(Platform.isIOS)
                          authenticationOptionsDivider(),
                         if(Platform.isIOS)
                          SizedBox(height: 4.h),
                         if(Platform.isIOS)
                          ElevatedButton(
                            onPressed: () => {
                            Navigator.pushReplacementNamed(
                            context,
                            NamedRoutes.bottomNavigationRoute2,
                            ),
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                const StadiumBorder(),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * 0.1,
                              ),
                            child:Text(
                              "Continue as a Guest",
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white
                              ),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                    if (provider.isOtpLoaderActive)

                      Container(
                        height: 80.h,
                        width: 100.h,
                        color: Colors.white.withOpacity(0.3),
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget authenticationOptionsDivider() {
    return Row(
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
              fontSize: 13.sp,
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
    );
  }

  Widget mobileNumberTextField() {
    return Consumer<AuthenticationProvider>(
      builder: (context, provider, child) {
        return TextFormField(
          controller: provider.mobileNumberController,
          keyboardType: TextInputType.phone,
          cursorColor: ColorsConstant.appColor,
          maxLength: 10,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
          ],
          onChanged: (value) {
            if (value.length == 10) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
            provider.setIsGetOtpButtonActive(value);
          },
          style: TextStyle(
            fontSize: 12.sp,
            letterSpacing: 3.0,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.3.h),
            filled: true,
            fillColor: ColorsConstant.appColorAccent,
            hintText: StringConstant.enterMobileNumber,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: ColorsConstant.enterMobileTextColor,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            counterText: '',
          ),
        );
      },
    );
  }
}

class AuthenticationScreen2 extends StatelessWidget {
  const AuthenticationScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Perform your actions before closing the app (if any)
        // You can add conditions here if you want to handle back press differently
        SystemNavigator.pop(animated: true);
        return true; // Return true to allow back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Consumer<AuthenticationProvider>(
          builder: (context, provider, child) {
            return SingleChildScrollView(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                      child: Column(
                        children: <Widget>[
                          SvgPicture.asset(ImagePathConstant.inAppLogo),
                          SizedBox(height: 3.h),
                          Text(
                            StringConstant.splashScreenText,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          mobileNumberTextField(),
                          SizedBox(height: 4.h),
                          ReusableWidgets.redFullWidthButton(
                            buttonText: StringConstant.getOtp,
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              provider.phoneNumberLogin(context);
                            },
                            isActive: provider.isGetOtpButtonActive,
                          ),
                        ],
                      ),
                    ),
                    if (provider.isOtpLoaderActive)
                      Container(
                        height: 80.h,
                        width: 100.h,
                        color: Colors.white.withOpacity(0.3),
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget authenticationOptionsDivider() {
    return Row(
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
              fontSize: 13.sp,
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
    );
  }

  Widget mobileNumberTextField() {
    return Consumer<AuthenticationProvider>(
      builder: (context, provider, child) {
        return TextFormField(
          controller: provider.mobileNumberController,
          keyboardType: TextInputType.phone,
          cursorColor: ColorsConstant.appColor,
          maxLength: 10,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp('[0-9]'))
          ],
          onChanged: (value) {
            if (value.length == 10) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
            provider.setIsGetOtpButtonActive(value);
          },
          style: TextStyle(
            fontSize: 12.sp,
            letterSpacing: 3.0,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.3.h),
            filled: true,
            fillColor: ColorsConstant.appColorAccent,
            hintText: StringConstant.enterMobileNumber,
            hintStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: ColorsConstant.enterMobileTextColor,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            counterText: '',
          ),
        );
      },
    );
  }
}