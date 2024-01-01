import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';

class Loader {
  static late Timer _timer;
  static showLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.3),
        builder: (BuildContext context) {
          _timer = Timer(const Duration(seconds: 15), () {
            hideLoader(context);
            showWeakInternetPopup(context);
          });
          return WillPopScope(
            onWillPop: () async => false,
            child: const Center(
              child: CupertinoActivityIndicator()
            ),
          );
        });
  }

  static hideLoader(BuildContext context) {
    Navigator.pop(context);
  }
  static void showWeakInternetPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
          ),
          title: const Text('Weak Internet Connection'),
          content: const Text( 'Your internet connection seems to be weak or experiencing issues, '
              'which may cause delays in loading. Please wait a moment and try again.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Try Again',
              style: TextStyle(
                color: ColorsConstant.appColor
              ),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  NamedRoutes.bottomNavigationRoute,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
