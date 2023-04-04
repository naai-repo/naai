import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController homeScreenController;

  @override
  void initState() {
    homeScreenController = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ExploreProvider>().initExploreScreen(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: true,
                    stretch: true,
                    expandedHeight: 5.h,
                    collapsedHeight: 0,
                    flexibleSpace: const FlexibleSpaceBar(
                      stretchModes: [StretchMode.zoomBackground],
                    ),
                    toolbarHeight: 0,
                  ),
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: SliverAppBar(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3.h),
                          topRight: Radius.circular(3.h),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      pinned: true,
                      floating: true,
                      title: Container(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Text(
                          StringConstant.exploreSalons,
                          style: StyleConstant.headingTextStyle,
                        ),
                      ),
                      centerTitle: false,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(13.h),
                        child: Consumer<ExploreProvider>(
                            builder: (context, provider, child) {
                          return TabBar(
                            controller: homeScreenController,
                            indicatorColor: Colors.white,
                            tabs: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 4.h, bottom: 2.h),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 50.w,
                                      child: TextFormField(
                                        controller:
                                            provider.salonSearchController,
                                        cursorColor: ColorsConstant.appColor,
                                        style: StyleConstant.searchTextStyle,
                                        textInputAction: TextInputAction.done,
                                        onChanged: (searchText) => provider
                                            .filterSalonList(searchText),
                                        decoration: StyleConstant
                                            .searchBoxInputDecoration(
                                                hintText:
                                                    StringConstant.search),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                            context, NamedRoutes.mapRoute),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            ReusableWidgets
                                                .circularLocationWidget(),
                                            Flexible(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 3.h,
                                                    child: Marquee(
                                                      text: context
                                                              .read<
                                                                  UserProvider>()
                                                              .getHomeAddressText() ??
                                                          "",
                                                      velocity: 40.0,
                                                      pauseAfterRound:
                                                          const Duration(
                                                              seconds: 1),
                                                      blankSpace: 30.0,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF333333),
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    StringConstant
                                                        .changeLocation,
                                                    style: TextStyle(
                                                      color: ColorsConstant
                                                          .appColor,
                                                      fontSize: 9.sp,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          color: Colors.white,
                          child: GestureDetector(
                            onTap: () {
                              provider.setSelectedSalonIndex(context,
                                  index: index);
                              Navigator.pushNamed(
                                  context, NamedRoutes.salonDetailsRoute);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.asset(provider
                                                .filteredSalonData[index]
                                                .imagePath ??
                                            ''),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            provider.filteredSalonData[index]
                                                    .name ??
                                                '',
                                            style: TextStyle(
                                              color: ColorsConstant.textDark,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 3.w,
                                                vertical: 1.5.w),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.h),
                                              color: ColorsConstant.graphicFill,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '${provider.filteredSalonData[index].rating}',
                                                  style: TextStyle(
                                                    fontSize: 11.5.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        ColorsConstant.textDark,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          SvgPicture.asset(ImagePathConstant
                                              .locationIconAlt),
                                          SizedBox(width: 1.w),
                                          Text(
                                            '1.3 Km',
                                            style: TextStyle(
                                              color: ColorsConstant.textDark,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 1.2.h),
                                      Text(
                                        '${provider.filteredSalonData[index].address?.addressString}',
                                        style: TextStyle(
                                          color:
                                              ColorsConstant.greySalonAddress,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                    ],
                                  ),
                                  index ==
                                          (provider.filteredSalonData.length -
                                              1)
                                      ? SizedBox(height: 10.h)
                                      : Divider(
                                          thickness: 1,
                                          color: ColorsConstant.divider,
                                        ),
                                  SizedBox(height: 1.h),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: provider.filteredSalonData.length,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}