import 'package:flutter/material.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
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
      body: Stack(
        children: <Widget>[
          ReusableWidgets.appScreenCommonBackground(),
          Positioned(
            top: 8.h,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.h),
                topRight: Radius.circular(3.h),
              ),
              child: Container(
                width: 100.w,
                height: 100.h,
                color: Colors.white,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      NamedRoutes.setHomeLocationRoute,
                    ),
                    child: Text('Home'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
