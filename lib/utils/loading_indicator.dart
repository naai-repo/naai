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
        contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.signal_wifi_statusbar_connected_no_internet_4,
                    size: 100,
                    color: Color(0xFFAA2F4C), // Change the color to your preference
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Weak Internet Connection',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                // const SizedBox(height: 10),
                SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text('Your internet connection seems to be weak or experiencing issues,'
                      'which may cause delays in loading. Please wait a moment and try again.', style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                //  const SizedBox(height: 20),
                SizedBox(height: 20),
              ],
            ),
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
//Weak Internet Connection
//Your internet connection seems to be weak or experiencing issues, '
//               'which may cause delays in loading. Please wait a moment and try again.',
//