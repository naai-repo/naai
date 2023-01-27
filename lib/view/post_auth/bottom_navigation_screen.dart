import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naai/view/utils/colors_constant.dart';
import 'package:naai/view/utils/routing/named_routes.dart';
import 'package:sizer/sizer.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: false,
        elevation: 0,
        backgroundColor: ColorsConstant.appColor,
      ),
      body: GestureDetector(
        onTap: () {
          FirebaseAuth.instance.signOut();
          Navigator.pushNamedAndRemoveUntil(
            context,
            NamedRoutes.authenticationRoute,
            (route) => false,
          );
        },
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
            decoration: BoxDecoration(
              color: ColorsConstant.appColor,
              borderRadius: BorderRadius.circular(2.h),
            ),
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
