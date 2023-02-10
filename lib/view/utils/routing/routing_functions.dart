import 'package:flutter/material.dart';
import 'package:naai/view/post_auth/bottom_navigation_screen.dart';
import 'package:naai/view/pre_auth/authentication_screen.dart';
import 'package:naai/view/post_auth/explore/explore_screen.dart';
import 'package:naai/view/pre_auth/username_screen.dart';
import 'package:naai/view/pre_auth/verify_otp_screen.dart';
import 'package:naai/view/splash_screen.dart';
import 'package:naai/view/utils/routing/named_routes.dart';

/// Class that contains string constants for all routes used in the app
class RoutingFunctions {
  /// Maps route names to [WidgetBuilder]s for corresponding [Widget]s,
  /// passed as the 'routes' param of [MaterialApp].
  static final Map<String, WidgetBuilder> routesMap = <String, WidgetBuilder>{
    NamedRoutes.splashRoute: (context) => SplashScreen(),
    NamedRoutes.authenticationRoute: (context) => AuthenticationScreen(),
    NamedRoutes.verifyOtpRoute: (context) => VerifyOtpScreen(),
    NamedRoutes.addUserNameRoute: (context) => UsernameScreen(),
    NamedRoutes.bottomNavigationRoute: (context) => BottomNavigationScreen(),
    NamedRoutes.exploreRoute: (context) => ExploreScreen(),
  };

  /// Handles routes that can't be handled using simple named routes map.
  static Route<dynamic>? generateRoutes(RouteSettings settings) {
    print("generateRoutes($settings)");
    Uri routeUri = Uri.parse(settings.name!);

    Widget? target;

    switch (routeUri.path) {
      case NamedRoutes.splashRoute:
        target = SplashScreen();
        break;
      case NamedRoutes.authenticationRoute:
        target = AuthenticationScreen();
        break;
      case NamedRoutes.verifyOtpRoute:
        target = VerifyOtpScreen();
        break;
      case NamedRoutes.addUserNameRoute:
        target = UsernameScreen();
        break;
      case NamedRoutes.bottomNavigationRoute:
        target = BottomNavigationScreen();
        break;
      case NamedRoutes.exploreRoute:
        target = ExploreScreen();
        break;
    }

    if (target != null) {
      print("Found route, opening it");
      return createRoute(target);
    } else {
      print("Unknown route found");
      return null;
    }
  }

  /// Function used to create custom animated route
  static Route createRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0, 0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
