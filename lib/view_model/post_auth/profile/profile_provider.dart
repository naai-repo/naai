import 'package:flutter/material.dart';
import 'package:naai/models/user.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/pre_auth/authentication_provider.dart';
import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  UserModel _userData = UserModel();

  //============= GETTERS =============//
  UserModel get userData => _userData;

  /// Get user data from [UserProvider]
  void getUserDataFromUserProvider(BuildContext context) {
    _userData = context.read<HomeProvider>().userData;
    notifyListeners();
  }

  /// Handle the logout button click event
  void handleLogoutClick(BuildContext context) {
    context.read<AuthenticationProvider>().logout(context);
  }
}
