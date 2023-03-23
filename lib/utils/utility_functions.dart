import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';

class UtilityFunctions {
  static String getImagePath({required String imageTitle}) {
    return StringConstant.imageBaseDirectory + imageTitle;
  }

  static SymbolOptions getLocationSymbolOptions({required LatLng latLng}) {
    return SymbolOptions(
      geometry: latLng,
      iconImage: ImagePathConstant.currentLocationPointer,
      iconSize: 0.2,
    );
  }

  static LocationData locationApiTimeout(
    BuildContext context, {
    required String message,
  }) {
    ReusableWidgets.showFlutterToast(
        context, StringConstant.locationApiTookTooLong);
    return LocationData.fromMap({});
  }
}
