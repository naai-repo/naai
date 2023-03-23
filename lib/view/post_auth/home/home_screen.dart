import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/view_model/post_auth/home/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserProvider>().getUserDetails(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(
                context,
                NamedRoutes.setHomeLocationRoute,
              ),
              child: Text('Home'),
            ),
            SizedBox(height: 5.h),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, NamedRoutes.authenticationRoute, (route) => false);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
