import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';

class Loader {
  static late Timer _timer;
  static showLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.3),
        builder: (BuildContext context) {
          _timer = Timer(const Duration(seconds: 12), () {
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
    showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child:  SvgPicture.asset(
                    "assets/images/salon_location_marker.svg",
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Finding Your Perfect Salon Match...",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "We're currently pinpointing your location to connect you with the best salon experiences nearby. This may take a moment, but we promise it's worth the wait!",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  "Thank you for your patience. Sit back, relax, and get ready to discover your next favorite salon! ✨",
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: const Text("Continue", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsConstant.appColor, // Change the button's background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            NamedRoutes.bottomNavigationRoute,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
//Weak Internet Connection
//Your internet connection seems to be weak or experiencing issues, '
//               'which may cause delays in loading. Please wait a moment and try again.',
//