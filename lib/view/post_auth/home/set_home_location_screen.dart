import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/user_location.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/keys.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

class SetHomeLocationScreen extends StatefulWidget {
  const SetHomeLocationScreen({Key? key}) : super(key: key);

  @override
  State<SetHomeLocationScreen> createState() => _SetHomeLocationScreenState();
}

class _SetHomeLocationScreenState extends State<SetHomeLocationScreen> {
  bool _isSearchBoxActive = false;

  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().initializeSymbol();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, provider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leadingWidth: 0,
          titleSpacing: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                splashRadius: 0.1,
                splashColor: Colors.transparent,
                icon: SvgPicture.asset(
                  ImagePathConstant.backArrowIos,
                ),
              ),
              Text(
                StringConstant.setLocation,
                style: StyleConstant.headingTextStyle,
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  screenSubtitle(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: <Widget>[
                            AnimatedContainer(
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 200),
                              width: _isSearchBoxActive
                                  ? constraints.maxWidth
                                  : 50.w,
                              child: Focus(
                                onFocusChange: (value) => setState(() {
                                  _isSearchBoxActive = value;
                                }),
                                child: TypeAheadField(
                                  debounceDuration: Duration(milliseconds: 300),
                                  hideSuggestionsOnKeyboardHide: false,
                                  suggestionsCallback: (pattern) async {
                                    return await provider
                                        .getPlaceSuggestions(context);
                                  },
                                  minCharsForSuggestions: 1,
                                  noItemsFoundBuilder: (context) => ListTile(
                                    tileColor: Colors.white,
                                    title: Text(
                                      "Can't find anything!",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.appColor,
                                      ),
                                    ),
                                  ),
                                  itemBuilder: (context, Feature suggestion) {
                                    return ListTile(
                                      tileColor: Colors.white,
                                      title: Text(
                                        suggestion.placeName ?? "",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: ColorsConstant.appColor,
                                        ),
                                      ),
                                    );
                                  },
                                  onSuggestionSelected: (Feature suggestion) {
                                    // DO NOT REMOVE THIS PRINT STATEMENT OTHERWISE THE FUNCTION
                                    // WILL NOT BE TRIGGERED
                                    print(
                                        "\t\tNOTE: Do not remove this print statement.");
                                    provider.handlePlaceSelectionEvent(
                                        suggestion, context);
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    textInputAction: TextInputAction.done,
                                    cursorColor: ColorsConstant.appColor,
                                    style: StyleConstant.searchTextStyle,
                                    controller: provider.mapSearchController,
                                    decoration:
                                        StyleConstant.searchBoxInputDecoration,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SizedBox(width: 2.w),
                                  ReusableWidgets.circularLocationWidget(),
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          provider.userData.homeLocation
                                                  ?.addressString ??
                                              "Loading",
                                          style: TextStyle(
                                            color: Color(0xFF333333),
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          StringConstant.changeLocation,
                                          style: TextStyle(
                                            color: ColorsConstant.appColor,
                                            fontSize: 9.sp,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
            Expanded(
              child: _mapBox(),
            ),
          ],
        ),
      );
    });
  }

  GestureDetector screenSubtitle() {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Text(
        StringConstant.setLocationSubtext,
        style: StyleConstant.greySemiBoldTextStyle,
      ),
    );
  }

  Widget _mapBox() {
    return Consumer<UserProvider>(builder: (context, provider, child) {
      return MapboxMap(
        accessToken: Keys.mapbox_public_key,
        initialCameraPosition:
            const CameraPosition(target: LatLng(28.6304, 77.2177), zoom: 15.0),
        onMapCreated: (MapboxMapController mapController) async {
          await provider.onMapCreated(mapController, context);
        },
        onMapClick: (Point<double> point, LatLng coordinates) {
          FocusManager.instance.primaryFocus?.unfocus();
          provider.onMapClick(coordinates: coordinates, context: context);
        },
      );
    });
  }
}
