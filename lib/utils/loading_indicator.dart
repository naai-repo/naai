import 'package:flutter/material.dart';
import 'package:naai/utils/colors_constant.dart';

class Loader {
  static showLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.8),
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: CircularProgressIndicator(
                color: ColorsConstant.appColor,
              ),
            ),
          );
        });
  }

  static hideLoader(BuildContext context) {
    Navigator.pop(context);
  }
}
