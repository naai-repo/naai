import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/pre_auth/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UsernameScreen extends StatelessWidget {
  const UsernameScreen({Key? key}) : super(key: key);

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
              provider.clearUsernameController();
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
                  StringConstant.addName,
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3.h),
                userNameTextField(),
                Spacer(),
                ReusableWidgets.redFullWidthButon(
                  buttonText: StringConstant.continueText,
                  onTap: () => provider.storePhoneAuthDataInDb(context),
                  isActive: provider.isUsernameButtonActive,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget userNameTextField() {
    return Consumer<AuthenticationProvider>(
      builder: (context, provider, child) {
        return TextFormField(
          controller: provider.userNameController,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          cursorColor: ColorsConstant.appColor,
          maxLength: 20,
          onChanged: (value) => provider.isUsernameValid(),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.deny(RegExp('[0-9]'))
          ],
          style: TextStyle(
            fontSize: 12.sp,
            letterSpacing: 3.0,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            filled: true,
            fillColor: ColorsConstant.appColorAccent,
            hintText: StringConstant.enterYourName,
            hintStyle: TextStyle(
              fontSize: 11.sp,
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
