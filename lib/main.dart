import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:naai/view/utils/routing/named_routes.dart';
import 'package:naai/view/utils/routing/routing_functions.dart';
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
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Naai',
          theme: ThemeData(fontFamily: 'Poppins'),
          onGenerateRoute: RoutingFunctions.generateRoutes,
          routes: RoutingFunctions.routesMap,
          initialRoute: NamedRoutes.splashRoute,
        );
      }
    );
  }
}