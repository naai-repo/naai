import 'package:location/location.dart' as location;

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';

class ExploreProvider with ChangeNotifier {
  late Symbol symbol;

  late MapboxMapController controller;

  TextEditingController _salonSearchController = TextEditingController();

  List<SalonData> _salonData = [];
  List<SalonData> _filteredSalonData = [];

  TextEditingController get salonSearchController => _salonSearchController;

  List<SalonData> get salonData => _salonData;
  List<SalonData> get filteredSalonData => _filteredSalonData;

  final _mapLocation = location.Location();

  /// Get the list of salons and save it in [_salonData] and [_filteredSalonData]
  void getSalonList(BuildContext context) async {
    Loader.showLoader(context);
    try {
      _salonData = await DatabaseService().getSalonData();
      _filteredSalonData.clear();
      _filteredSalonData.addAll(_salonData);
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Set the value of [_filteredSalonData] according to the search query entered by user.
  void filterSalonList(String searchText) {
    _filteredSalonData.clear();
    _salonData.forEach((salon) {
      if (salon.name!.toLowerCase().contains(searchText.toLowerCase())) {
        _filteredSalonData.add(salon);
      }
    });
    notifyListeners();
  }

  Future<void> onMapCreated(
      MapboxMapController mapController, BuildContext context) async {
    this.controller = mapController;

    var _serviceEnabled = await _mapLocation.serviceEnabled();
    
    if (!_serviceEnabled) {
      _serviceEnabled = await _mapLocation.requestService();
    }
    var _permissionGranted = await _mapLocation.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _mapLocation.requestPermission();
    }

    Loader.showLoader(context);
    var _locationData = await _mapLocation.getLocation();

    LatLng currentLatLng =
        LatLng(_locationData.latitude!, _locationData.longitude!);
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: currentLatLng,
          zoom: 16,
        ),
      ),
    );

    symbol = await this.controller.addSymbol(
      SymbolOptions(
        geometry: currentLatLng,
        iconImage: ImagePathConstant.currentLocationPointer,
        iconSize: 0.2,
      ),
    );

    Loader.hideLoader(context);
  }

  void initializeSymbol() {
    symbol = Symbol('marker', SymbolOptions());
  }
}
