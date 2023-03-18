import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/keys.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/explore_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

class SetupHome extends StatefulWidget {
  const SetupHome({Key? key}) : super(key: key);

  @override
  State<SetupHome> createState() => _SetupHomeState();
}

class _SetupHomeState extends State<SetupHome> {
  @override
  void initState() {
    super.initState();
    context.read<ExploreProvider>().initializeSymbol();
  }

  @override
  Widget build(BuildContext context) {
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
                Text(
                  StringConstant.setLocationSubtext,
                  style: StyleConstant.greySemiBoldTextStyle,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.w,
                        height: 5.h,
                        child: TextFormField(
                          cursorColor: ColorsConstant.appColor,
                          style: StyleConstant.searchTextStyle,
                          textInputAction: TextInputAction.done,
                          decoration: StyleConstant.searchBoxInputDecoration,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ReusableWidgets.circularLocationWidget(),
                            Flexible(
                              flex: 1,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Delhi, India",
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
                                      decoration: TextDecoration.underline,
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
                  ),
                ),
                // Consumer<ExploreProvider>(
                //     builder: (context, provider, child) {
                //   return TypeAheadField(
                //     debounceDuration: Duration(milliseconds: 500),
                //     hideSuggestionsOnKeyboardHide: false,
                //     hideOnLoading: true,
                //     textFieldConfiguration: TextFieldConfiguration(
                //         // controller: provider.searchPlaceController,
                //         autofocus: false,
                //         decoration: InputDecoration(
                //           suffixIcon: Padding(
                //             padding: const EdgeInsets.only(right: 14.0),
                //             // child: provider.searchPlaceController.text.length ==
                //             //         0
                //             //     ? SvgPicture.asset("assets/images/search.svg",
                //             //         fit: BoxFit.scaleDown)
                //             //     : GestureDetector(
                //             //         onTap: () =>
                //             //             provider.clearSearchHistory(context),
                //             //         child: Icon(
                //             //           Icons.close,
                //             //           color: Colors.grey,
                //             //         ),
                //             //       ),
                //           ),
                //           contentPadding: const EdgeInsets.symmetric(
                //               horizontal: 14.0, vertical: 15.0),
                //           focusedBorder: const UnderlineInputBorder(
                //             borderSide: BorderSide(color: Color(0xFFD9E2EC)),
                //           ),
                //           enabledBorder: const UnderlineInputBorder(
                //             borderSide: BorderSide(
                //               color: Color(0xFFD9E2EC),
                //             ),
                //           ),
                //           labelText: 'Search',
                //           labelStyle: TextStyle(
                //             fontSize: 14.0,
                //             // color: ColorsConstant.greyishTextColor,
                //             fontWeight: FontWeight.w400,
                //           ),
                //         ),
                //         onChanged: (String value) {
                //           //print("On changed value -----> $value");
                //         }),
                //     suggestionsCallback: (pattern) async {
                //       print("Printing pattern ---> $pattern");
                //       // return await provider.getAddress();
                //     },
                //     // itemBuilder: (context, Feature suggestion) {
                //     //   return ListTile(
                //     //     title: Text(suggestion.placeName ?? ""),
                //     //   );
                //     // },
                //     onSuggestionSelected: (Feature suggestion) {
                //       // DO NOT REMOVE THIS PRINT STATEMENT OTHERWISE THE FUNCTION
                //       // WILL NOT BE TRIGGERED
                //       print("\t\tNOTE: Do not remove this print statement.");
                //       provider.selectingPlace(suggestion, context, true);
                //       //To dismiss the keyboard upon selecting a place
                //       FocusManager.instance.primaryFocus?.unfocus();
                //     },
                //   );
                // }),
                SizedBox(height: 1.h),
              ],
            ),
          ),
          Expanded(
            child: _mapBox(),
          )
        ],
      ),
    );
  }

  Widget _mapBox() {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return MapboxMap(
        accessToken: Keys.mapbox_public_key,
        initialCameraPosition:
            const CameraPosition(target: LatLng(51.5072, 0.1276), zoom: 15.0),
        onMapCreated: (MapboxMapController mapController) async {
          await provider.onMapCreated(mapController, context);
        },
        onMapClick: (Point<double> point, LatLng coordinates) {
          FocusManager.instance.primaryFocus?.unfocus();
          // provider.onMapClick(coordinates, context, true);
        },
      );
    });
  }
}
