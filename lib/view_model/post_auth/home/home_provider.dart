import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/booking.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/user.dart';
import 'package:naai/models/user_location.dart';
import 'package:naai/services/api_service/base_client.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/api_endpoint_constant.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/exception/exception_handling.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/shared_preferences/shared_preferences_helper.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/utility_functions.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/review.dart';
import '../../../models/service_detail.dart';
import '../../../view/post_auth/bottom_navigation_screen.dart';

class HomeProvider with ChangeNotifier {
  bool _changedLocation = false;

  final _mapLocation = location.Location();
  late LatLng _userCurrentLatLng;

  location.Location get mapLocation => _mapLocation;
  LatLng get userCurrentLatLng => _userCurrentLatLng;

  List<SalonData> _salonList = [];
  List<Artist> _artistList = [];
  List<Review> _allReviewList = [];
  List<ServiceDetail> _services = [];

  late Symbol _symbol;
  Position ? position;
String ?  _addressText;
  late MapboxMapController _controller;

 // String _addressText = StringConstant.loading;
  List<ServiceDetail> get filteredServiceList => _filteredServiceList;
  List<ServiceDetail> _filteredServiceList = [];

  TextEditingController _mapSearchController = TextEditingController();

  UserModel _userData = UserModel();

  List<Booking> _lastOrNextBooking = [];
  List<Booking> _allBookings = [];

  //============= GETTERS =============//
  List<SalonData> get salonList => _salonList;
  List<Artist> get artistList => _artistList;
  List<Review> get reviewList => _allReviewList;
  List<ServiceDetail> get service => _services;

  String? get addressText => _addressText;

  TextEditingController get mapSearchController => _mapSearchController;

  UserModel get userData => _userData;

  List<Booking> get lastOrNextBooking => _lastOrNextBooking;
  List<Booking> get allBookings => _allBookings;

  /// Check if there is a [uid] stored in [SharedPreferences] or not.
  /// If no [uid] is found, then get the userId of the currently logged in
  /// user and save it in [SharedPreferences].
  ///
  /// The [uid] is necessary to get the user data.
  void checkUserIdInSharedPref(String uid) async {
    String storedUid = await SharedPreferenceHelper.getUserId();
    if (storedUid.isEmpty) {
      await SharedPreferenceHelper.setUserId(uid);
    }
  }

  /// Initialising [_symbol]
  void initializeSymbol() {
    _symbol = Symbol(
      'marker',
      const SymbolOptions(),
    );
  }

  /// Method to trigger all the API functions of home screen
/*
  Future<void> initHome(BuildContext context) async {
    var _serviceEnabled = await _mapLocation.serviceEnabled();
    await locationPopUp(context);
    if (!_serviceEnabled) {
   //   _serviceEnabled = await _mapLocation.requestService();
    }
   // await requestLocationPermission(context);
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
     // _permissionGranted = await _mapLocation.requestPermission();
      await requestLocationPermission(context);
    }
  await Loader.showLoader(context);

    var _locationData = await _mapLocation.getLocation();

    _userCurrentLatLng =
        LatLng(_locationData.latitude!, _locationData.longitude!);

    await Future.wait(
      [
        getUserDetails(context).whenComplete(
              () async =>
          await context.read<ExploreProvider>().getSalonList(context),
        ),
        getAllArtists(context),
        getAllReviews(context),
      ],
    ).onError(
          (error, stackTrace) =>
          ReusableWidgets.showFlutterToast(context, '$error'),
    );

    _salonList = [...context.read<ExploreProvider>().salonData];
    changeRatings(context);


    if (_userData.homeLocation?.geoLocation == null) {
      Loader.hideLoader(context);
      Navigator.pushNamed(
        context,
        NamedRoutes.setHomeLocationRoute,
      );

    } else {

      await getUserBookings(context);
      await getServicesNamesAndPrice(context);
      Loader.hideLoader(context);
    }

    notifyListeners();
  }
  */
  Future<void> initHome(BuildContext context) async {
    var _serviceEnabled = await _mapLocation.serviceEnabled();
    await locationPopUp(context);
    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
      if (!_serviceEnabled) return;
    }
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      Navigator.pushNamed(context, NamedRoutes.setHomeLocationRoute);
      return; // Stop further execution
    }

   // _permissionGranted = await _mapLocation.requestPermission();
      if (_permissionGranted != location.PermissionStatus.granted) return;
       Loader.showLoader(context);

    try {
      var _locationData = await _mapLocation.getLocation();
      _userCurrentLatLng = LatLng(_locationData.latitude!, _locationData.longitude!);

      await Future.wait([
        getUserDetails(context).whenComplete(() async {
          await context.read<ExploreProvider>().getSalonList(context);
        }),
        getAllArtists(context),
        getAllReviews(context),
      ]);

      _salonList = [...context.read<ExploreProvider>().salonData];
      changeRatings(context);

      if (_userData.homeLocation?.geoLocation == null) {
        Loader.hideLoader(context);
        Navigator.pushNamed(context, NamedRoutes.setHomeLocationRoute);
      } else {
        await getUserBookings(context);
        await getServicesNamesAndPrice(context);
        Loader.hideLoader(context);
      }
    } catch (error) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(context, '$error');
    }

    notifyListeners();
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
            ),
            title: const Text('Discover Salons Near You 📍✨'),
            content: SingleChildScrollView( // Ensures the dialog is scrollable if the content is too long
              child: ListBody(
                children: const <Widget>[
                  Text('To provide you with a personalized experience and show you the best salons nearby, we kindly request access to your location. Your privacy is important to us, and your location data will be used solely to enhance your service.'),
                  SizedBox(height:10),
                  Text('Please tap \'Allow\' to grant location access and start exploring your local beauty destinations!'),
                  SizedBox(height:10),
                  Text('Thank you for helping us tailor your salon discovery journey. 💇‍♀️💇‍♂️'),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                child: const Text('Allow'),
                style: ElevatedButton.styleFrom(
                  primary: ColorsConstant.appColor, // Change the button's background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the pop-up.
                  // Request location permission again.
                  _mapLocation.requestPermission();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future locationPopUp(BuildContext context) async {
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      await showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/app_logo.png",
                      height: 80,
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "To provide you with a personalized experience and show you the best salons nearby,"
                          "Allow us to access your location to find nearby salons and offer personalized recommendations just for you.",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsConstant.appColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await Geolocator.requestPermission();
                          //  _mapLocation.requestService();
                       //    await _mapLocation.requestPermission();
                              Navigator.pop(context);

                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }


  Future<void> initHome2(BuildContext context) async {

    var _serviceEnabled = await _mapLocation.serviceEnabled();
    await locationPopUp(context);
    if (!_serviceEnabled) {
      //   _serviceEnabled = await _mapLocation.requestService();
    }
    // await requestLocationPermission(context);
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      // _permissionGranted = await _mapLocation.requestPermission();
      Navigator.pushNamed(context, NamedRoutes.setHomeLocationRoute2);
      return; // Stop further execution
    }
    await Loader.showLoader(context);

    var _locationData = await _mapLocation.getLocation();

    _userCurrentLatLng =
        LatLng(_locationData.latitude!, _locationData.longitude!);
    await Future.wait(
      [
        getUserDetails(context).whenComplete(
              () async =>
          await context.read<ExploreProvider>().getSalonList(context),
        ),
        getAllArtists(context),
        getAllReviews(context),
      ],
    );
    _salonList = [...context.read<ExploreProvider>().salonData];
    changeRatings(context);
      await getUserBookings(context);
      await getServicesNamesAndPrice(context);
      Loader.hideLoader(context);
    notifyListeners();
  }

  /// Fetch the user details from [FirebaseFirestore]
  Future<void> getUserDetails(BuildContext context) async {
    try {
      _userData = await DatabaseService().getUserDetails();
    } catch (e) {
    //  ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Fetch the user details from [FirebaseFirestore]
  Future<void> getAllArtists(BuildContext context) async {
    try {
      _artistList = await DatabaseService().getAllArtists();
      _artistList.sort((a, b) => ((a.rating ?? 0) - (b.rating ?? 0)).toInt());
      context.read<ExploreProvider>().setArtistList(_artistList);
    } catch (e) {
     // ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  Future<void> getAllReviews(context) async {
    try {
      _allReviewList = await DatabaseService().getAllReviews();
    } catch (e) {
     // ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Fetch the booking details of user from [FirebaseFirestore]
  Future<void> getUserBookings(BuildContext context) async {
    try {
      List<Booking> response =
      await DatabaseService().getUserBookings(userId: userData.id ?? '');
      _allBookings = response;
      _lastOrNextBooking.clear();
      for (int i = 0; i < response.length; i++) {
        if (DateTime.parse(response[i].bookingCreatedFor ?? '')
            .isAfter(DateTime.now())) {
          _lastOrNextBooking.add(response[i]);
          if (_salonList.isNotEmpty) {
            _lastOrNextBooking.last.salonName = _salonList
                .firstWhere(
                    (element) => element.id == _lastOrNextBooking.last.salonId)
                .name;
          }
          _lastOrNextBooking.last.createdOnString =
              getTimeAgoString(_lastOrNextBooking.last.bookingCreatedOn);
          if (_artistList.isNotEmpty) {
            _lastOrNextBooking.last.artistName = _artistList
                .firstWhere(
                    (element) => element.id == _lastOrNextBooking.last.artistId)
                .name;
          }
          _lastOrNextBooking.last.isUpcoming = true;
        }
      }

      if (_lastOrNextBooking.isEmpty && response.isNotEmpty) {
        _lastOrNextBooking.add(response.last);
        _lastOrNextBooking.last.isUpcoming = false;
        if (_salonList.isNotEmpty) {
          _lastOrNextBooking.last.salonName = _salonList
              .firstWhere(
                  (element) => element.id == _lastOrNextBooking.last.salonId)
              .name;
        }
        _lastOrNextBooking.last.createdOnString =
            getTimeAgoString(_lastOrNextBooking.last.bookingCreatedOn);
        if (_artistList.isNotEmpty) {
          _lastOrNextBooking.last.artistName = _artistList
              .firstWhere(
                  (element) => element.id == _lastOrNextBooking.last.artistId)
              .name;
        }
      }
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }


  String getTimeAgoString(String? dateTimeString) {
    DateTime dateTime =
    DateTime.parse(dateTimeString ?? DateTime.now().toString());
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    final daysAgo = difference.inDays;
    final weeksAgo = daysAgo ~/ 7;
    final monthsAgo =
        (now.year * 12 + now.month) - (dateTime.year * 12 + dateTime.month);

    if (monthsAgo >= 1) {
      return '$monthsAgo Month${monthsAgo > 1 ? 's' : ''} Ago';
    } else if (weeksAgo >= 1) {
      return '$weeksAgo Week${weeksAgo > 1 ? 's' : ''} Ago';
    } else if (daysAgo >= 1) {
      return '$daysAgo Day${daysAgo > 1 ? 's' : ''} Ago';
    } else {
      return 'Today';
    }
  }

  /// Fetch the service names from [FirebaseFirestore]
  Future<void> getServicesNamesAndPrice(BuildContext context) async {
    try {
      var response = await DatabaseService().getAllServices();
      for (int i = 0; i < _lastOrNextBooking.length; i++) {
        _lastOrNextBooking[i].bookedServiceNames = [];
        response.forEach((element) {
          if (_lastOrNextBooking[i].serviceIds?.contains(element.id) == true) {
            _lastOrNextBooking[i]
                .bookedServiceNames
                ?.add(element.serviceTitle ?? '');
            _lastOrNextBooking[i].totalPrice += element.price ?? 0;
          }
        });
      }
    } catch (e) {
      // ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Initialising map related values as soon as the map is rendered on screen.
  Future<void> onMapCreated(
      MapboxMapController mapController,
      BuildContext context,
      ) async {
    this._controller = mapController;
/*
    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    */
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      ReusableWidgets.showFlutterToast(
        context,
        'Location permission is required to proceed to find nearby salons and offer personalized recommendations just for you.😊',
      );
      LatLng dummyLocation = LatLng(28.7383,77.0822); // Set your desired dummy location
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: dummyLocation,
            zoom: 10,
          ),
        ),
      );
      return; // Exit the method
    }
    Loader.showLoader(context);
    var _locationData = await _mapLocation.getLocation();

    LatLng currentLatLng =
    LatLng(_locationData.latitude!, _locationData.longitude!);

    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLatLng,
          zoom: 16,
        ),
      ),
    );

    _symbol = await this._controller.addSymbol(
      UtilityFunctions.getCurrentLocationSymbolOptions(
          latLng: currentLatLng),
    );

    Loader.hideLoader(context);

    await getFormattedAddressConfirmation(
      context: context,
      coordinates: currentLatLng,
    );
  }

  Future<void> onMapCreated2(
      MapboxMapController mapController,
      BuildContext context,
      ) async {
    this._controller = mapController;
/*
    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    */
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      ReusableWidgets.showFlutterToast(
        context,
        'Location permission is required to proceed to find nearby salons and offer personalized recommendations just for you.😊2',
      );
      LatLng dummyLocation = LatLng(28.7383,77.0822); // Set your desired dummy location
      await mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: dummyLocation,
            zoom: 10,
          ),
        ),
      );
      return; // Exit the method
    }
    Loader.showLoader(context);
    var _locationData = await _mapLocation.getLocation();

    LatLng currentLatLng =
    LatLng(_locationData.latitude!, _locationData.longitude!);

    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLatLng,
          zoom: 16,
        ),
      ),
    );

    _symbol = await this._controller.addSymbol(
      UtilityFunctions.getCurrentLocationSymbolOptions(
          latLng: currentLatLng),
    );

    Loader.hideLoader(context);

    await getFormattedAddressConfirmation2(
      context: context,
      coordinates: currentLatLng,
    );
  }

  /// Take user to the place, selected from search suggestions
  Future<void> handlePlaceSelectionEvent(
      Feature place,
      BuildContext context,
      ) async {
    _mapSearchController.text = place.placeName ?? "";

    LatLng selectedLatLng =
    LatLng(place.center?[1] ?? 0.0, place.center?[0] ?? 0.0);

    await _controller.removeSymbol(_symbol);

    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: selectedLatLng, zoom: 16),
      ),
    );

    await _controller.addSymbol(
      UtilityFunctions.getCurrentLocationSymbolOptions(latLng: selectedLatLng),
    );

    clearMapSearchText();

    await getFormattedAddressConfirmation(
      context: context,
      coordinates: selectedLatLng,
    );
    notifyListeners();
  }

  /// Get place suggestions according to the search text
  Future<List<Feature>> getPlaceSuggestions(BuildContext context) async {
    List<Feature> _data = [];

    Uri uri = Uri.parse(
        "${ApiEndpointConstant.mapboxPlacesApi}${_mapSearchController.text}.json")
        .replace(queryParameters: UtilityFunctions.mapSearchQueryParameters());

    try {
      var response = await BaseClient()
          .get(baseUrl: '', api: uri.toString())
          .onError((error, stackTrace) => throw Exception(error));

      UserLocationModel responseData =
      UserLocationModel.fromJson(jsonDecode(response.body));
      _data = responseData.features ?? [];

      /// [Feature(id: StringConstant.yourCurrentLocation)] is added to show the current
      /// location card
      _data = [
        Feature(id: StringConstant.yourCurrentLocation),
        ..._data,
      ];
    } catch (e) {
      Logger().d(e);
      ReusableWidgets.showFlutterToast(context, e.toString());
    }

    return _data;
  }

  /// Handle the click event on the map.
  /// Fetches the coordinate of the point clicked by the user.
  Future<void> onMapClick({
    required BuildContext context,
    required LatLng coordinates,
  }) async {
    _mapSearchController.clear();
    print("Coordinates ===> $coordinates");
    await _controller.removeSymbol(_symbol);

    _symbol = await _controller.addSymbol(
      UtilityFunctions.getCurrentLocationSymbolOptions(latLng: coordinates),
    );

    this._controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: coordinates, zoom: 16),
      ),
    );

    await getFormattedAddressConfirmation(
      context: context,
      coordinates: coordinates,
    );

    notifyListeners();
  }
  Future<void> onMapClick2({
    required BuildContext context,
    required LatLng coordinates,
  }) async {
    _mapSearchController.clear();
    print("Coordinates ===> $coordinates");
    await _controller.removeSymbol(_symbol);

    _symbol = await _controller.addSymbol(
      UtilityFunctions.getCurrentLocationSymbolOptions(latLng: coordinates),
    );

    this._controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: coordinates, zoom: 16),
      ),
    );

    await getFormattedAddressConfirmation2(
      context: context,
      coordinates: coordinates,
    );

    notifyListeners();
  }

  /// Update the user's location related data in [FirebaseFirestore]
  void updateUserLocation(
      BuildContext context,
      LatLng latLng,
      ) async {
    UserModel user = UserModel.fromMap(_userData.toMap());

  //  user.homeLocation = HomeLocation();
    HomeLocation updatedHomeLocation = HomeLocation();
   // user.homeLocation?.addressString = _addressText;
  //  user.homeLocation?.geoLocation =
  //      GeoPoint(latLng.latitude, latLng.longitude);
    updatedHomeLocation.addressString = _addressText;
    updatedHomeLocation.geoLocation = GeoPoint(latLng.latitude, latLng.longitude);
    user.homeLocation = updatedHomeLocation;

  //  Map<String, dynamic> data = user.toMap();
    Map<String, dynamic> data = {
      'homeLocation': user.homeLocation?.toMap(), // Update only the home location
    };

    Loader.showLoader(context);
    try {
      await DatabaseService().updateUserData(data: data).onError(
              (FirebaseException error, stackTrace) =>
          throw ExceptionHandling(message: error.message ?? ""));
      _changedLocation = true;
      await getUserDetails(context);
      context.read<ExploreProvider>().getSalonList(context, justDistance: true);
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
    notifyListeners();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavigationScreen3(), // Replace NextScreen with your desired screen
      ),
    );

  }

  void updateUserLocation2(
      BuildContext context,
      LatLng latLng,
      ) async {
    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }

    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      ReusableWidgets.showFlutterToast(
        context,
        'Location permission is required to proceed to find nearby salons and offer personalized recommendations just for you.😊',
      );
      return ;
    }
    UserModel user = UserModel.fromMap(_userData.toMap());

    user.homeLocation = HomeLocation();

    user.homeLocation?.addressString = _addressText;
    user.homeLocation?.geoLocation =
        GeoPoint(latLng.latitude, latLng.longitude);

    Map<String, dynamic> data = user.toMap();
    Loader.showLoader(context);
    try {
      await DatabaseService().updateUserData(data: data).onError(
              (FirebaseException error, stackTrace) =>
          throw ExceptionHandling(message: error.message ?? ""));
      _changedLocation = true;
      await getUserDetails(context);
      context.read<ExploreProvider>().getSalonList(context, justDistance: true);
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
    }
    notifyListeners();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavigationScreen2(), // Replace NextScreen with your desired screen
      ),
    );

  }

  /// Get complete address from the provided coordinates
  /// Format the address according to the need.
  /// Show a bottom sheet with the formatted address text and a button to confirm
  /// the new address.
  Future<void> getFormattedAddressConfirmation({
    required BuildContext context,
    required LatLng coordinates,
  }) async {
    Loader.showLoader(context);

    _addressText = await UtilityFunctions.getAddressCoordinateAndFormatAddress(
      context: context,
      latLng: coordinates,
    );

    Loader.hideLoader(context);

    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(2.h),
          ),
        ),
        height: 20.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _addressText!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(ColorsConstant.appColor),
              ),
              onPressed: () async {
                  PermissionStatus status = await Permission.location.request();
                  if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
                    Geolocator.checkPermission();
                      ReusableWidgets.showFlutterToast(
                        context,
                        'Location permission is required to proceed.to find nearby salons and offer personalized recommendations just for you.😊',
                      );
                    openAppSettings();
                  //  updateUserLocation(context, coordinates);
                    }
                  else {
                    // Recheck permission status after returning from settings
                    PermissionStatus updatedStatus = await Permission.location.status;
                    if (updatedStatus.isGranted) {
                      updateUserLocation(context, coordinates);
                    }
                  }
                },
              child: const Text(StringConstant.confirmLocation),
            ),
          ],
        ),
      ),
    );
    if (_changedLocation) {
      Navigator.pop(context);
      _changedLocation = false;
    }
  }

  Future<void> getFormattedAddressConfirmation2({
    required BuildContext context,
    required LatLng coordinates,
  }) async {
    Loader.showLoader(context);

    _addressText = await UtilityFunctions.getAddressCoordinateAndFormatAddress(
      context: context,
      latLng: coordinates,
    );

    Loader.hideLoader(context);

    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(2.h),
          ),
        ),
        height: 20.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _addressText!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(ColorsConstant.appColor),
              ),
              onPressed: () async {
                PermissionStatus status = await Permission.location.request();
                if (status.isGranted) {
                  updateUserLocation(context, coordinates);
                } else if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
                  bool isOpened = await openAppSettings();
                  if (isOpened) {
                    // Check the permission status again after opening app settings
                    PermissionStatus updatedStatus = await Permission.location.status;
                    if (updatedStatus.isGranted) {
                      updateUserLocation(context, coordinates);
                    } else {
                      ReusableWidgets.showFlutterToast(
                        context,
                        'Location permission is required to proceed to find nearby salons and offer personalized recommendations just for you.😊',
                      );

                    }
                  }
                }
              },

              /*
              onPressed: () async {
  PermissionStatus status = await Permission.location.request();
  if (status.isGranted) {
    updateUserLocation(context, coordinates);
  } else if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
    bool isOpened = await openAppSettings();
    if (isOpened) {
      ReusableWidgets.showFlutterToast(
        context,
        'Location permission is required to proceed to find nearby salons and offer personalized recommendations just for you.😊',
      );
    }
  }
},

              */
              child: const Text(StringConstant.confirmLocation2),
            ),
          ],
        ),
      ),
    );
    if (_changedLocation) {
      Navigator.pop(context);
      _changedLocation = false;
    }
  }


  /// Method to fetch the current location of the user using [location] package
  Future<LatLng> fetchCurrentLocation(BuildContext context) async {
    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _mapLocation.requestPermission();
    }

    var _locationData = await _mapLocation.getLocation();

    return LatLng(_locationData.latitude!, _locationData.longitude!);
  }

  /// Animate the map to given [latLng]
  Future<void> animateToPosition(LatLng latLng) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16),
      ),
    );
  }

  void populateBookingData(BuildContext context, int index) async {
    await context.read<SalonDetailsProvider>().getSalonData(
      context,
      salonId: _lastOrNextBooking[index].salonId!,
    );

    await context.read<SalonDetailsProvider>().getArtistList(context);
    await context.read<SalonDetailsProvider>().getServiceList(context);

    context.read<SalonDetailsProvider>().setServiceIds(
      ids: _lastOrNextBooking[index].serviceIds!,
      totalPrice: _lastOrNextBooking[index].totalPrice,
    );

    context
        .read<SalonDetailsProvider>()
        .setStaffSelectionMethod(selectedSingleStaff: true);

    context.read<SalonDetailsProvider>().setBookingData(
      context,
      setArtistId: true,
      artistId: _lastOrNextBooking[index].artistId,
    );
    Navigator.pushNamed(
      context,
      NamedRoutes.createBookingRoute,
    );
  }

  /// Get date in the format [Month Date], abbreviated day of week or time schedule
  /// of the booking.
  String getFormattedDateOfBooking({
    bool getFormattedDate = false,
    bool getAbbreviatedDay = false,
    bool getTimeScheduled = false,
    bool getFullDate = false,
    bool secondaryDateFormat = false,
    String? dateTimeString,
    required int index,
  }) {
    DateTime dateTime =
    DateTime.parse(dateTimeString ?? DateTime.now().toString());
    _lastOrNextBooking[index].bookingCreatedFor ?? DateTime.now().toString();
    if (getFormattedDate) {
      return DateFormat('MMM dd').format(dateTime);
    } else if (getAbbreviatedDay) {
      return DateFormat('EEE').format(dateTime);
    } else if (getTimeScheduled) {
      return getTimeRangeString(_lastOrNextBooking[index].startTime ?? 0,
          _lastOrNextBooking[index].endTime ?? 0);
    } else if (getFullDate) {
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } else {
      return DateFormat('dd MMMM yyyy').format(dateTime);
    }
  }

  String formatTime(int timeInSeconds) {
    int hours = (timeInSeconds ~/ 3600) % 12;
    int minutes = ((timeInSeconds % 3600) ~/ 60);
    String amPm = (timeInSeconds ~/ 43200) == 0 ? 'AM' : 'PM';

    if (hours == 0) {
      hours = 12;
    }

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $amPm';
    return formattedTime;
  }

  String getTimeRangeString(int startTime, int endTime) {
    String formattedStartTime = formatTime(startTime);
    String formattedEndTime = formatTime(endTime);

    return '$formattedStartTime - $formattedEndTime';
  }

  /// Get the address text from the user's home location
  String? getHomeAddressText() {
    return userData.homeLocation?.addressString ;
  }
  String? getDummyHomeAddressText() {
    return userData.homeLocation?.addressString??"Your Location will be show when you Sign In" ;
  }

  /// Dispose [_controller] when the map is unmounted
  void disposeMapController() {
    _controller.dispose();
  }

  /// Clear the value of[_mapSearchController]
  void clearMapSearchText() {
    _mapSearchController.clear();
    notifyListeners();
  }

  Future<List<Review>> getUserReviews() async {
    return await DatabaseService().getUserReviewsList(userData.id);
  }

  void changeRatings(BuildContext context, {bool notify = false}) {
    salonList.forEach((salon) {
      num average = salon.originalRating ?? 0;
      final allReviews = _allReviewList.where(
            (review) => review.salonId == salon.id,
      );
      allReviews.forEach((review) {
        average += review.rating ?? 0;
      });
      average /= (allReviews.length + 1);
      final allArtist = artistList.where(
            (artist) => artist.salonId == salon.id,
      );
      allArtist.forEach((artist) {
        average += artist.originalRating ?? 0;
      });
      average /= (allArtist.length + 1);
      salon.rating = average;
    });
    artistList.forEach((artist) {
      double average = artist.originalRating ?? 0;
      final allReviews = _allReviewList.where(
            (review) => review.artistId != null && review.artistId == artist.id,
      );
      allReviews.forEach((review) {
        average += review.rating ?? 0;
      });
      average /= (allReviews.length + 1);
      artist.rating = average;
    });
    if (notify) notifyListeners();
  }

  void addReview(Review review) {
    _allReviewList.add(review);
  }
}