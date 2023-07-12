import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:naai/models/user.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/exception/exception_handling.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/shared_preferences/shared_preferences_helper.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider with ChangeNotifier {
  bool _isGetOtpButtonActive = false;
  bool _isVerifyOtpButtonActive = false;
  bool _isOtpLoaderActive = false;
  bool _isUsernameButtonActive = false;

  String _verificationId = "";
  String _enteredOtp = "000000";
  String? _phoneNumber;
  String? _userId;
  String _selectedGender = '';

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _otpDigitOneController = TextEditingController();
  TextEditingController _otpDigitTwoController = TextEditingController();
  TextEditingController _otpDigitThreeController = TextEditingController();
  TextEditingController _otpDigitFourController = TextEditingController();
  TextEditingController _otpDigitFiveController = TextEditingController();
  TextEditingController _otpDigitSixController = TextEditingController();

  bool get isGetOtpButtonActive => _isGetOtpButtonActive;
  bool get isVerifyOtpButtonActive => _isVerifyOtpButtonActive;
  bool get isOtpLoaderActive => _isOtpLoaderActive;
  bool get isUsernameButtonActive => _isUsernameButtonActive;

  String get verificationId => _verificationId;
  String get enteredOtp => _enteredOtp;
  String get selectedGender => _selectedGender;
  String? get userId => _userId;

  TextEditingController get userNameController => _userNameController;
  TextEditingController get mobileNumberController => _mobileNumberController;
  TextEditingController get otpDigitOneController => _otpDigitOneController;
  TextEditingController get otpDigitTwoController => _otpDigitTwoController;
  TextEditingController get otpDigitThreeController => _otpDigitThreeController;
  TextEditingController get otpDigitFourController => _otpDigitFourController;
  TextEditingController get otpDigitFiveController => _otpDigitFiveController;
  TextEditingController get otpDigitSixController => _otpDigitSixController;

  /// Method to trigger the social login flow depending upon which social login method is chosen
  void socialLogin({
    required bool isGoogle,
    required BuildContext context,
  }) async {
    Loader.showLoader(context);
    try {
      isGoogle ? await googleLogIn(context) : await appleLogin(context);
      Loader.hideLoader(context);
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.pushNamed(context, NamedRoutes.bottomNavigationRoute);
      }
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
  }

  /// Triggers Google authentication flow
  Future<void> googleLogIn(BuildContext context) async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    final GoogleSignInAccount? googleUser = GoogleSignIn().currentUser ??
        await GoogleSignIn(scopes: <String>['email'])
            .signIn()
            .onError((error, stackTrace) {
          throw Exception('Something went wrong!');
        });

    if (googleUser == null) {
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User? user = (await FirebaseAuth.instance
            .signInWithCredential(credential)
            .onError((error, stackTrace) {
      throw Exception('Something went wrong!');
    }))
        .user;
    if ((await DatabaseService().checkUserExists(uid: user!.uid)) == false) {
      setUserId(userId: user.uid);

      storeUserDataInCollection(
        context: context,
        userData: UserModel(
          name: user.displayName,
          gmailId: user.email,
        ),
      );
    }
    notifyListeners();
  }

  Future<String> getGender(GoogleSignInAccount googleSignIn) async {
    final headers = await googleSignIn.authHeaders;
    final r = await http.get(
      Uri.parse(
          "https://people.googleapis.com/v1/people/me?personFields=genders&key="),
      headers: {
        "Authorization": '${headers["Authorization"]}',
      },
    );
    final response = jsonDecode(r.body);
    print(response);
    return response["genders"][0]["formattedValue"];
  }

  /// Triggers Apple authentication flow
  Future<void> appleLogin(BuildContext context) async {
    if (Platform.isIOS) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      ).onError((error, stackTrace) {
        print(error);
        throw Exception('$error');
      });

      print(
          "Apple credential ===>\nEmail - ${credential.email}\nid_Token - ${credential.identityToken}\nAuthorization code - ${credential.authorizationCode}\nUser identifier - ${credential.userIdentifier}");
    }
  }

  /// Method to verify the entered phone number and send an OTP to the user if the
  /// entered phone number is valid.
  void phoneNumberLogin(BuildContext context) async {
    _isOtpLoaderActive = true;
    notifyListeners();
    try {
      _phoneNumber = "+91${_mobileNumberController.text}";

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseException e) {
          _isOtpLoaderActive = false;
          notifyListeners();
          print("ERROR \t ${e.message}");
          if (e.message!
              .contains('format of the phone number provided is incorrect')) {
            ReusableWidgets.showFlutterToast(context, 'Invalid phone number!');
          }
          throw ExceptionHandling(message: e.message ?? "");
        },
        codeSent: (String verificationId, int? resendCode) {
          setVerificationId(value: verificationId);
          resetOtpControllers();
          _isOtpLoaderActive = false;
          notifyListeners();
          Navigator.pushNamed(context, NamedRoutes.verifyOtpRoute);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      _isOtpLoaderActive = false;
      notifyListeners();
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
  }

  /// Verify the OTP entered by user.
  void verifyOtp(BuildContext context) async {
    Loader.showLoader(context);
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _enteredOtp,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .onError((FirebaseException error, stackTrace) {
        throw ExceptionHandling(message: error.message ?? "");
      });

      resetMobielNumberController();
      resetOtpControllers();

      User? user = FirebaseAuth.instance.currentUser;

      Loader.hideLoader(context);

      if (await DatabaseService().checkUserExists(uid: user!.uid) == false) {
        _userId = user.uid;
        Navigator.pushReplacementNamed(context, NamedRoutes.addUserNameRoute);
      } else {
        context.read<HomeProvider>().checkUserIdInSharedPref(
            FirebaseAuth.instance.currentUser?.uid ?? "");
        Navigator.pushReplacementNamed(
            context, NamedRoutes.bottomNavigationRoute);
      }
    } catch (e) {
      Loader.hideLoader(context);
      print('ERROR \t $e');
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
  }

  /// Trigger [storeUserDataInCollection] method to store the data in database
  /// Specifically for phone authentication
  void storePhoneAuthDataInDb(BuildContext context) async {
    setUserId(userId: _userId);

    bool wasLoginSuccessful = await storeUserDataInCollection(
      context: context,
      userData: UserModel(
        name: _userNameController.text,
        phoneNumber: _phoneNumber,
        gender: _selectedGender,
        homeLocation: HomeLocation(),
      ),
    );

    // Reset all the text controllers
    resetMobielNumberController();
    resetOtpControllers();
    clearUsernameController();

    if (wasLoginSuccessful) {
      Navigator.pushReplacementNamed(
          context, NamedRoutes.bottomNavigationRoute);
    } else {
      FirebaseAuth.instance.signOut();
      Navigator.pop(context);
    }
  }

  /// Store user data in the [FirebaseFirestore]
  Future<bool> storeUserDataInCollection({
    required BuildContext context,
    required UserModel userData,
  }) async {
    Loader.showLoader(context);
    try {
      await DatabaseService().setUserData(userData: userData.toMap()).onError(
            (FirebaseException error, stackTrace) =>
                throw ExceptionHandling(message: error.message ?? ""),
          );
      return true;
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
    return false;
  }

  /// Method to set user's gender
  void setGender(String value) {
    _selectedGender = value;
    setUsernameButtonActive();
    notifyListeners();
  }

  /// Method to check the validity of mobile number
  void setIsGetOtpButtonActive(String value) {
    _isGetOtpButtonActive = value.length == 10;
    notifyListeners();
  }

  /// Set the retrieved [_verificationId]. If nothing is sent, the [_verificationId] will
  /// be reset to an empty [String]
  void setVerificationId({
    String value = "",
    bool resetVerificationId = false,
  }) {
    resetVerificationId ? _verificationId = "" : _verificationId = value;
    notifyListeners();
  }

  /// Check if the entered username is valid and set the value of [_isUsernameButtonActive]
  void setUsernameButtonActive() {
    _isUsernameButtonActive = _userNameController.text.trim().length > 0 &&
        _selectedGender.isNotEmpty;
    notifyListeners();
  }

  /// Set the otp string as the user enters the otp digits
  void setOtp({required int index, required String digit}) {
    bool didDeleteDigit = digit == "";
    digit = digit == "" ? "0" : digit;

    _enteredOtp = _enteredOtp.substring(0, index) +
        digit +
        _enteredOtp.substring(index + 1);

    // Change the focus to next otp text box if the user has typed something in the otp box
    if (!didDeleteDigit) {
      if (index != 5) {
        FocusManager.instance.primaryFocus!.nextFocus();
      } else {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    } else {
      if (index != 0) {
        FocusManager.instance.primaryFocus!.previousFocus();
      } else {
        FocusManager.instance.primaryFocus!.unfocus();
      }
    }

    _isVerifyOtpButtonActive = (otpDigitOneController.text.isNotEmpty &&
        otpDigitTwoController.text.isNotEmpty &&
        otpDigitThreeController.text.isNotEmpty &&
        otpDigitFourController.text.isNotEmpty &&
        otpDigitFiveController.text.isNotEmpty &&
        otpDigitSixController.text.isNotEmpty);
    notifyListeners();
  }

  /// Trigger logout event
  Future<void> logout(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    SharedPreferenceHelper.clearAll();
    Phoenix.rebirth(context);
  }

  /// Save the [_userId] after authentication in [SharedPreferences]
  /// and in [AuthenticationProvider]
  void setUserId({required String? userId}) async {
    _userId = userId;
    await SharedPreferenceHelper.setUserId(userId ?? '');
  }

  /// Get the [_userId] from [SharedPreferences]
  Future<String?> getUserId() async {
    return await SharedPreferenceHelper.getUserId();
  }

  /// Reset the value of [_mobileNumberController] and [_isGetOtpButtonActive]
  void resetMobielNumberController() {
    _mobileNumberController.clear();
    _isGetOtpButtonActive = false;
    notifyListeners();
  }

  /// Reset otp text controllers and [_isVerifyOtpButtonActive]
  void resetOtpControllers() {
    _otpDigitOneController.clear();
    _otpDigitTwoController.clear();
    _otpDigitThreeController.clear();
    _otpDigitFourController.clear();
    _otpDigitFiveController.clear();
    _otpDigitSixController.clear();
    _isVerifyOtpButtonActive = false;
    notifyListeners();
  }

  /// Clear the value of [_userNameController]
  void clearUsernameController() {
    _userNameController.clear();
    _selectedGender = '';
    notifyListeners();
  }
}
