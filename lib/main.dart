import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/routing/routing_functions.dart';
import 'package:naai/view_model/post_auth/bottom_navigation_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/user_provider.dart';
import 'package:naai/view_model/post_auth/map/map_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:naai/view_model/pre_auth/authentication_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExploreProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SalonDetailsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MapProvider(),
        ),
      ],
      builder: (context, snapshot) {
        return Sizer(builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Naai',
            theme: ThemeData(fontFamily: 'Poppins'),
            onGenerateRoute: RoutingFunctions.generateRoutes,
            routes: RoutingFunctions.routesMap,
            initialRoute: NamedRoutes.splashRoute,
          );
        });
      },
    );
  }
}
