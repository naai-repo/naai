import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader {
  static showLoader(BuildContext context) {
    showDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.3),
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: CupertinoActivityIndicator()
            ),
          );
        });
  }

  static hideLoader(BuildContext context) {
    Navigator.pop(context);
  }
}
