import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/view/post_auth/explore/custom_app_bar.dart';
import 'package:naai/view/utils/colors_constant.dart';
import 'package:naai/view/utils/image_path_constant.dart';
import 'package:naai/view/utils/string_constant.dart';
import 'package:naai/view_model/post_auth/explore_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController homeScreenController;

  @override
  void initState() {
    homeScreenController = TabController(length: 1, vsync: this);
    context.read<ExploreProvider>().getSalonList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   leadingWidth: 0,
      //   toolbarHeight: 10.h,
      //   title: Text(
      //     StringConstant.exploreSalons,
      //     style: TextStyle(
      //       color: ColorsConstant.textDark,
      //       fontWeight: FontWeight.w600,
      //       fontSize: 18.sp,
      //     ),
      //   ),
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      // ),
      // body: Consumer<ExploreProvider>(builder: (context, provider, child) {
      //   return CustomScrollView(
      //     controller: homeScreenController,
      //     slivers: [
      //       SliverPersistentHeader(
      //         delegate: CustomAppBar(),
      //         pinned: true,
      //       ),
      //       SliverToBoxAdapter(
      //         child: Column(
      //           children: <Widget>[
      //             Padding(
      //               padding:
      //                   EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      //               child: Column(
      //                 children: <Widget>[
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: <Widget>[
      //                       Text.rich(
      //                         TextSpan(
      //                           children: [
      //                             WidgetSpan(
      //                               child: Padding(
      //                                 padding: EdgeInsets.only(right: 3.w),
      //                                 child: SvgPicture.asset(
      //                                   "assets/images/location_icon.svg",
      //                                 ),
      //                               ),
      //                             ),
      //                             TextSpan(
      //                               text: "Delhi, India",
      //                               style: TextStyle(
      //                                 color: Color(0xFF333333),
      //                                 fontSize: 13.sp,
      //                                 fontWeight: FontWeight.w500,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                         overflow: TextOverflow.ellipsis,
      //                       ),
      //                       Row(
      //                         children: [
      //                           Text(
      //                             "Tap here to change location",
      //                             style: TextStyle(
      //                               color: ColorsConstant.appColor,
      //                               fontSize: 8.sp,
      //                               fontWeight: FontWeight.w500,
      //                               decoration: TextDecoration.underline,
      //                             ),
      //                           ),
      //                           Padding(
      //                             padding: EdgeInsets.only(left: 1.w),
      //                             child: SvgPicture.asset(
      //                               "assets/images/down_arrow.svg",
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ],
      //                   ),
      //                   SizedBox(height: 3.h),
      //                   TextFormField(
      //                     decoration: InputDecoration(
      //                       hintText: 'Search for Salons or Service',
      //                       border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(8),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Divider(
      //               thickness: 1.5,
      //               color: Color(0xFFC8C8C8),
      //             ),
      //             Padding(
      //               padding: EdgeInsets.symmetric(
      //                   vertical: 1.h, horizontal: 4.w),
      //               child: ListView.builder(
      //                 physics: NeverScrollableScrollPhysics(),
      //                 shrinkWrap: true,
      //                 itemCount: provider.salonData.length,
      //                 itemBuilder: (context, index) => Container(
      //                   decoration: BoxDecoration(
      //                       borderRadius: BorderRadius.circular(5)),
      //                   child: Column(
      //                     children: <Widget>[
      //                       Stack(
      //                         children: <Widget>[
      //                           ClipRRect(
      //                             borderRadius: BorderRadius.circular(5),
      //                             child: Image.asset(
      //                                 provider.salonData[index].imagePath ??
      //                                     ''),
      //                           )
      //                         ],
      //                       ),
      //                       SizedBox(height: 2.h),
      //                       Column(
      //                         crossAxisAlignment: CrossAxisAlignment.start,
      //                         children: <Widget>[
      //                           Row(
      //                             mainAxisAlignment:
      //                                 MainAxisAlignment.spaceBetween,
      //                             children: <Widget>[
      //                               Text(
      //                                 provider.salonData[index].name ?? '',
      //                                 style: TextStyle(
      //                                   color: Color(0xFF373737),
      //                                   fontSize: 14.sp,
      //                                   fontWeight: FontWeight.w500,
      //                                 ),
      //                               ),
      //                               Container(
      //                                 padding: EdgeInsets.symmetric(
      //                                     horizontal: 2.w, vertical: 2.w),
      //                                 decoration: BoxDecoration(
      //                                     borderRadius:
      //                                         BorderRadius.circular(2),
      //                                     color: Colors.grey.shade200),
      //                                 child: Row(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment.center,
      //                                   children: <Widget>[
      //                                     Text(
      //                                       '${provider.salonData[index].rating}',
      //                                       style: TextStyle(
      //                                         fontSize: 12.sp,
      //                                         fontWeight: FontWeight.w500,
      //                                         color: Color(0xFF373737),
      //                                       ),
      //                                     ),
      //                                     SvgPicture.asset(
      //                                         'assets/images/star_icon.svg',
      //                                         height: 2.h),
      //                                   ],
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                           SizedBox(height: 1.h),
      //                           Row(
      //                             crossAxisAlignment:
      //                                 CrossAxisAlignment.center,
      //                             children: <Widget>[
      //                               SvgPicture.asset(
      //                                   'assets/images/location_icon_alt.svg'),
      //                               SizedBox(width: 1.w),
      //                               Text(
      //                                 '1.3 Km',
      //                                 style: TextStyle(
      //                                   color: ColorsConstant.appColor,
      //                                   fontWeight: FontWeight.w500,
      //                                 ),
      //                               ),
      //                             ],
      //                           ),
      //                           SizedBox(height: 1.2.h),
      //                           Text(
      //                             '${provider.salonData[index].address}',
      //                             style: TextStyle(
      //                               color: Color(0xFFA4A4A4),
      //                               fontWeight: FontWeight.w500,
      //                             ),
      //                           ),
      //                           SizedBox(height: 1.h),
      //                         ],
      //                       ),
      //                       Divider(
      //                         thickness: 1.5,
      //                         color: Color(0xFFC8C8C8),
      //                       ),
      //                       SizedBox(height: 1.h),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   );
      // }),
      body: Consumer<ExploreProvider>(builder: (context, provider, child) {
        return NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              floating: true,
              // snap: true,
              title: Text(
                StringConstant.exploreSalons,
                style: TextStyle(
                  color: ColorsConstant.textDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              ),
              centerTitle: false,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(13.h),
                child: TabBar(
                  controller: homeScreenController,
                  indicatorColor: Colors.white,
                  tabs: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 55.w,
                            height: 5.5.h,
                            child: TextFormField(
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorsConstant.graphicFillDark,
                                contentPadding: EdgeInsets.all(0),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 3.5.w),
                                  child: SvgPicture.asset(
                                    ImagePathConstant.searchIcon,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                prefixIconConstraints:
                                    BoxConstraints(minWidth: 11.w),
                                hintText: StringConstant.search,
                                hintStyle: TextStyle(
                                  color: ColorsConstant.textLight,
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.h),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(1.h),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    // borderRadius: BorderRadius.circular(5.h),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(2, 2),
                                        color: Colors.grey.shade300,
                                        spreadRadius: 0.5,
                                        blurRadius: 15,
                                      ),
                                    ],
                                  ),
                                  child: SvgPicture.asset(
                                    ImagePathConstant.locationIcon,
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(
                                      "Delhi, India",
                                      style: TextStyle(
                                        color: Color(0xFF333333),
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          StringConstant.changeLocation,
                                          style: TextStyle(
                                            color: ColorsConstant.appColor,
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 1.w),
                                          child: SvgPicture.asset(
                                            ImagePathConstant.downArrow,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
            ),
          ],
          body: TabBarView(
            controller: homeScreenController,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.salonData.length,
                  itemBuilder: (context, index) => Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                  provider.salonData[index].imagePath ?? ''),
                            )
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  provider.salonData[index].name ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF373737),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.5.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.h),
                                    color: ColorsConstant.graphicFill,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${provider.salonData[index].rating}',
                                        style: TextStyle(
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: ColorsConstant.textDark,
                                        ),
                                      ),
                                      SizedBox(width: 1.w),
                                      SvgPicture.asset(
                                        ImagePathConstant.starIcon,
                                        height: 2.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset(
                                    'assets/images/location_icon_alt.svg'),
                                SizedBox(width: 1.w),
                                Text(
                                  '1.3 Km',
                                  style: TextStyle(
                                    color: ColorsConstant.appColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.2.h),
                            Text(
                              '${provider.salonData[index].address}',
                              style: TextStyle(
                                color: Color(0xFFA4A4A4),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 1.h),
                          ],
                        ),
                        Divider(
                          thickness: 1.5,
                          color: Color(0xFFC8C8C8),
                        ),
                        SizedBox(height: 1.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
