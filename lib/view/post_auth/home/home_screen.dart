import 'package:flutter/material.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/view/post_auth/home/set_home_location_screen.dart';
import 'package:naai/view_model/post_auth/home/user_provider.dart';
import 'package:provider/provider.dart';

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
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            NamedRoutes.setHomeLocationRoute,
          ),
          child: Text('Home'),
        ),
      ),
    );
  }
}
