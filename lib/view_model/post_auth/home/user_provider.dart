import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as location;
import 'package:logger/logger.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/user.dart';
import 'package:naai/models/user_location.dart';
import 'package:naai/services/api_service/base_client.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/api_endpoint_constant.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/exception/exception_handling.dart';
import 'package:naai/utils/keys.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/utility_functions.dart';
// import 'package:naai/utils/shared_preferences/shared_preferences_helper.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:sizer/sizer.dart';

class UserProvider with ChangeNotifier {
  late Symbol _symbol;

  late MapboxMapController _controller;

  String _addressText = '';

  TextEditingController _mapSearchController = TextEditingController();

  UserModel _userData = UserModel();

  String get addressText => _addressText;

  TextEditingController get mapSearchController => _mapSearchController;

  UserModel get userData => _userData;

  final _mapLocation = location.Location();

  /// Fetch the user details from [FirebaseFirestore]
  void getUserDetails(BuildContext context) async {
    Loader.showLoader(context);
    try {
      // await SharedPreferenceHelper.setUserId('Bkor6YYboRZZTQah45N6hVYqDuJ2');
      _userData = await DatabaseService().getUserDetails();

      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      print(e);
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Initialising map related values as soon as the map  is rendered on screen.
  Future<void> onMapCreated(
    MapboxMapController mapController,
    BuildContext context,
  ) async {
    this._controller = mapController;

    var _serviceEnabled = await _mapLocation.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _mapLocation.requestPermission();
    }

    Loader.showLoader(context);
    var _locationData = await _mapLocation.getLocation().timeout(
          const Duration(seconds: 7),
          onTimeout: () => UtilityFunctions.locationApiTimeout(context,
              message: 'Fetching location took too long!'),
        );

    LatLng _currentLatLng =
        LatLng(_locationData.latitude!, _locationData.longitude!);

    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentLatLng,
          zoom: 16,
        ),
      ),
    );

    _symbol = await this._controller.addSymbol(
          UtilityFunctions.getLocationSymbolOptions(latLng: _currentLatLng),
        );

    Loader.hideLoader(context);
    UserLocationModel model =
        await getAddressFromCoordinates(context, coordinates: _currentLatLng) ??
            UserLocationModel();
    _addressText = getAddressText(model);

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.h),
        ),
        height: 20.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _addressText,
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
              onPressed: () => updateUserLocation(context, _currentLatLng),
              child: Text('Confirm Location'),
            ),
          ],
        ),
      ),
    );
  }

  /// Dispose [_controller] when the map is unmounted
  void disposeMapController() {
    _controller.dispose();
  }

  /// Initialising [_symbol]
  void initializeSymbol() {
    _symbol = Symbol(
      'marker',
      SymbolOptions(),
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
      UtilityFunctions.getLocationSymbolOptions(latLng: selectedLatLng),
    );

    notifyListeners();
  }

  /// Get place suggestions according to the search text
  Future<List<Feature>> getPlaceSuggestions(BuildContext context) async {
    List<Feature> _data = [];
    Map<String, dynamic> param = {
      'proximity': 'ip',
      'limit': '10',
      'language': 'en-gb',
      'autocomplete': 'true',
      'fuzzyMatch': 'true',
      'access_token': Keys.mapbox_public_key
    };

    Uri uri = Uri.parse(
            "${ApiEndpointConstant.mapboxPlacesApi}${_mapSearchController.text}.json")
        .replace(queryParameters: param);

    try {
      var response = await BaseClient()
          .get(baseUrl: '', api: uri.toString())
          .onError((error, stackTrace) => throw Exception(error));

      UserLocationModel responseData =
          UserLocationModel.fromJson(jsonDecode(response.body));

      _data = responseData.features ?? [];
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
      UtilityFunctions.getLocationSymbolOptions(latLng: coordinates),
    );

    this._controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: coordinates, zoom: 16),
          ),
        );

    Loader.showLoader(context);

    UserLocationModel model =
        await getAddressFromCoordinates(context, coordinates: coordinates) ??
            UserLocationModel();
    _addressText = getAddressText(model);

    Loader.hideLoader(context);

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(2.h),
        ),
        height: 20.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _addressText,
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
              onPressed: () => updateUserLocation(context, coordinates),
              child: Text('Confirm Location'),
            ),
          ],
        ),
      ),
    );

    notifyListeners();
  }

  /// Fetches the complete address for the provided coordinates.
  Future<UserLocationModel?> getAddressFromCoordinates(
    BuildContext context, {
    required LatLng coordinates,
  }) async {
    Map<String, dynamic> param = {
      'types': 'locality,neighborhood,place,district,region',
      'access_token': Keys.mapbox_public_key
    };

    Uri uri = Uri.parse(
            "${ApiEndpointConstant.mapboxPlacesApi}${coordinates.longitude},${coordinates.latitude}.json")
        .replace(queryParameters: param);

    try {
      var response = await BaseClient().get(
        baseUrl: '',
        api: uri.toString(),
      );
      return UserLocationModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      Logger().d(e);
      ReusableWidgets.showFlutterToast(context, e.toString());
      return null;
    }
  }

  /// Formats the address text for the provided location.
  /// The address format is [x, y] where the precedence of x and y is
  /// Neighborhood, Locality, Place, District, Region
  String getAddressText(UserLocationModel locationModel) {
    String address = '';
    for (int i = 0; i < (locationModel.features?.length ?? 0); i++) {
      var element = locationModel.features?[i];

      switch (element?.placeType?[0]) {
        case 'neighborhood':
          address += '${element?.text}, ';
          break;
        case 'locality':
          address += '${element?.text}, ';
          break;
        case 'place':
          address += '${element?.text}, ';
          break;
        case 'district':
          address += '${element?.text}, ';
          break;
        case 'region':
          address += '${element?.text}';
          break;
      }
    }
    var addressArray = address.split(',');
    address = addressArray.first + ',' + addressArray.last;
    return address;
  }

  /// Update the user's location related data in [FirebaseFirestore]
  void updateUserLocation(
    BuildContext context,
    LatLng latLng,
  ) async {
    Map<String, dynamic> data = UserModel(
        homeLocation: HomeLocation(
      addressString: _addressText,
      geoLocation: GeoPoint(
        latLng.latitude,
        latLng.longitude,
      ),
    )).toMap();

    Loader.showLoader(context);
    try {
      await DatabaseService().updateUserData(data: data).onError(
          (FirebaseException error, stackTrace) =>
              throw ExceptionHandling(message: error.message ?? ""));
      getUserDetails(context);
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }

    Navigator.pop(context);
  }
}
