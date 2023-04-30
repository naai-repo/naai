import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view/widgets/colorful_information_card.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view/widgets/stacked_image_text.dart';
import 'package:naai/view/widgets/title_with_line.dart';
import 'package:naai/view_model/post_auth/bottom_navigation_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HomeProvider>().initHome(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                ReusableWidgets.transparentFlexibleSpace(),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 2.5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(3.h),
                            topRight: Radius.circular(3.h),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        ImagePathConstant.inAppLogo,
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 5.h,
                                            width: 30.w,
                                            child: TextFormField(
                                              cursorColor:
                                                  ColorsConstant.appColor,
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textInputAction:
                                                  TextInputAction.done,
                                              onChanged: (searchText) =>
                                                  print(searchText),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: ColorsConstant
                                                    .graphicFillDark,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 3.5.w),
                                                prefixIcon: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2.w),
                                                  child: SvgPicture.asset(
                                                    ImagePathConstant
                                                        .searchIcon,
                                                    height: 2.h,
                                                  ),
                                                ),
                                                prefixIconConstraints:
                                                    BoxConstraints(
                                                        minWidth: 9.w),
                                                hintText: StringConstant.search,
                                                hintStyle: TextStyle(
                                                  color:
                                                      ColorsConstant.textLight,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.h),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          Container(
                                            padding: EdgeInsets.all(1.h),
                                            decoration: BoxDecoration(
                                              color: ColorsConstant
                                                  .graphicFillDark,
                                              borderRadius:
                                                  BorderRadius.circular(4.h),
                                            ),
                                            child: SvgPicture.asset(
                                                ImagePathConstant
                                                    .appointmentIcon),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 4.h, bottom: 2.h),
                                    padding: EdgeInsets.all(0.5.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.h),
                                      color: ColorsConstant.graphicFillDark,
                                    ),
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      bool _shouldScroll = (TextPainter(
                                            text: TextSpan(
                                                text: Provider.of<HomeProvider>(
                                                            context,
                                                            listen: true)
                                                        .userData
                                                        .homeLocation
                                                        ?.addressString ??
                                                    "",
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            maxLines: 1,
                                            textScaleFactor:
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            textDirection: TextDirection.ltr,
                                          )..layout())
                                              .size
                                              .width >
                                          constraints.maxWidth * 7 / 10;

                                      return Row(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(1.5.h),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: SvgPicture.asset(
                                                ImagePathConstant
                                                    .homeLocationIcon),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 2.w),
                                            width: 73.w,
                                            height: 4.h,
                                            alignment: Alignment.centerLeft,
                                            child: _shouldScroll
                                                ? Marquee(
                                                    text:
                                                        "${context.read<HomeProvider>().getHomeAddressText()}",
                                                    velocity: 40.0,
                                                    pauseAfterRound:
                                                        const Duration(
                                                            seconds: 1),
                                                    blankSpace: 30.0,
                                                    style: TextStyle(
                                                      color: ColorsConstant
                                                          .textLight,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                : Text(
                                                    "${context.read<HomeProvider>().getHomeAddressText()}",
                                                    style: TextStyle(
                                                      color: ColorsConstant
                                                          .textLight,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            ImagePathConstant.downArrow,
                                            color: ColorsConstant.textDark,
                                            width: 2.5.w,
                                          ),
                                          SizedBox(width: 1.w),
                                        ],
                                      );
                                    }),
                                  ),
                                  dummyDeal(),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          StringConstant.viewMore,
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.w600,
                                            color: ColorsConstant.textDark,
                                          ),
                                        ),
                                        SizedBox(width: 1.w),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 2.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            serviceCategories(),
                            salonNearMe(),
                            SizedBox(height: 5.h),
                            ourStylist(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget ourStylist() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: Column(
        children: <Widget>[
          TitleWithLine(
            lineHeight: 3.5.h,
            lineWidth: 1.w,
            fontSize: 15.sp,
            text: StringConstant.ourStylist.toUpperCase(),
          ),
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Padding(
              padding: EdgeInsets.only(
                top: 1.h,
                right: 2.w,
                left: 2.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        artistCard(
                          name: 'Test2'.toUpperCase(),
                          salonName: 'Billu Barber'.toUpperCase(),
                          rating: 4.0,
                          color: Color(0xFF2CA3C8),
                          onTap: () {
                            context
                                .read<ExploreProvider>()
                                .setSelectedSalonIndex(context, index: 0);

                            context
                                .read<SalonDetailsProvider>()
                                .setSelectedArtistIndex(context, index: 1);
                            Navigator.pushNamed(
                              context,
                              NamedRoutes.barberProfileRoute,
                            );
                          },
                        ),
                        artistCard(
                          name: 'Test1'.toUpperCase(),
                          salonName: 'Billu Barber'.toUpperCase(),
                          rating: 3.0,
                          color: Color(0xFF373737),
                          isThin: false,
                          onTap: () {
                            context
                                .read<ExploreProvider>()
                                .setSelectedSalonIndex(context, index: 0);
                            context
                                .read<SalonDetailsProvider>()
                                .setSelectedArtistIndex(context, index: 0);
                            Navigator.pushNamed(
                              context,
                              NamedRoutes.barberProfileRoute,
                            );
                          },
                        ),
                        artistCard(
                          name: 'Test6'.toUpperCase(),
                          salonName: 'Billu Barber'.toUpperCase(),
                          rating: 2.0,
                          color: Color(0xFF46C6A7),
                          onTap: () {
                            context
                                .read<ExploreProvider>()
                                .setSelectedSalonIndex(context, index: 0);
                            context
                                .read<SalonDetailsProvider>()
                                .setSelectedArtistIndex(context, index: 2);
                            Navigator.pushNamed(
                              context,
                              NamedRoutes.barberProfileRoute,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Flexible(
                    flex: 1,
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        artistCard(
                          name: 'Test5'.toUpperCase(),
                          salonName: 'Glemazone Unisex Salon'.toUpperCase(),
                          rating: 3.0,
                          color: Color(0xFF373737),
                          isThin: false,
                          onTap: () {
                            context
                                .read<ExploreProvider>()
                                .setSelectedSalonIndex(context, index: 1);
                            context
                                .read<SalonDetailsProvider>()
                                .setSelectedArtistIndex(context, index: 0);
                            Navigator.pushNamed(
                              context,
                              NamedRoutes.barberProfileRoute,
                            );
                          },
                        ),
                        artistCard(
                          name: 'Test7'.toUpperCase(),
                          salonName: 'Billu Barber'.toUpperCase(),
                          rating: 4.0,
                          color: Color(0xFFC64655),
                          isThin: false,
                          onTap: () {
                            context
                                .read<ExploreProvider>()
                                .setSelectedSalonIndex(context, index: 0);
                            context
                                .read<SalonDetailsProvider>()
                                .setSelectedArtistIndex(context, index: 3);
                            Navigator.pushNamed(
                              context,
                              NamedRoutes.barberProfileRoute,
                            );
                          },
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
    );
  }

  Widget artistCard({
    bool isThin = true,
    required String name,
    required double rating,
    required String salonName,
    required Color color,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: isThin
            ? EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.h,
              )
            : EdgeInsets.symmetric(
                horizontal: 0.w,
                vertical: 1.h,
              ),
        height: isThin ? 25.h : 33.h,
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              offset: Offset(2, 2),
              color: Colors.grey.shade500,
              spreadRadius: 1,
              blurRadius: 15,
            )
          ],
          borderRadius: BorderRadius.circular(3.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: isThin ? 14.h : 22.h,
              child: ClipRRect(
                borderRadius: isThin
                    ? BorderRadius.circular(3.h)
                    : BorderRadius.vertical(
                        top: Radius.circular(3.h),
                      ),
                child: Image.asset(
                  'assets/images/salon_dummy_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    salonName,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: List<Widget>.generate(
                      rating.floor(),
                      (i) => SvgPicture.asset(
                        ImagePathConstant.starIcon,
                        color: ColorsConstant.greyStar,
                        height: 1.3.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget salonNearMe() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.only(
          top: 3.h,
          right: 3.w,
          left: 3.w,
        ),
        child: Column(
          children: <Widget>[
            TitleWithLine(
              lineHeight: 2.5.h,
              lineWidth: 0.6.w,
              fontSize: 12.sp,
              text: StringConstant.salonsNearMe.toUpperCase(),
            ),
            Container(
              height: 17.h,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: provider.salonData.length,
                itemBuilder: (context, index) {
                  SalonData salon = provider.salonData[index];

                  return GestureDetector(
                    onTap: () {
                      context
                          .read<ExploreProvider>()
                          .setSelectedSalonIndex(context, index: index);
                      Navigator.pushNamed(
                          context, NamedRoutes.salonDetailsRoute);
                    },
                    child: Container(
                      width: 75.w,
                      margin: EdgeInsets.only(right: 5.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.h),
                        color: Color(0xFF0F0F0F),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 1.h,
                                horizontal: 3.w,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        salon.name ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 11.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        salon.salonType == 'Unisex'
                                            ? '${salon.salonType} Salon'
                                            : '${salon.salonType}\'s Salon',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.sp,
                                          color: ColorsConstant.textLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      ColorfulInformationCard(
                                        imagePath:
                                            ImagePathConstant.locationIconAlt,
                                        text: '1.3 km',
                                        color: ColorsConstant.purpleDistance,
                                      ),
                                      SizedBox(width: 3.w),
                                      ColorfulInformationCard(
                                        imagePath: ImagePathConstant.starIcon,
                                        text: '${salon.rating}',
                                        color: ColorsConstant.greenRating,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 17.h,
                            width: 28.w,
                            child: ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(1.h),
                              ),
                              child: Image.asset(
                                salon.imagePath ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }

  Widget serviceCategories() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 1.5.h,
        horizontal: 3.w,
      ),
      decoration: BoxDecoration(
        color: ColorsConstant.neutral,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TitleWithLine(
            lineHeight: 2.5.h,
            lineWidth: 0.6.w,
            fontSize: 12.sp,
            text: StringConstant.categories.toUpperCase(),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 15.h),
            margin: EdgeInsets.only(bottom: 3.h),
            child: ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                        context: context,
                        indexValue: 1,
                        applyServiceFilter: true,
                        appliedService: ServiceEnum.HAIR,
                      ),
                  imagePath: ImagePathConstant.hairColorImage,
                  text: StringConstant.hairColor,
                ),
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                        context: context,
                        indexValue: 1,
                        applyServiceFilter: true,
                        appliedService: ServiceEnum.MAKEUP,
                      ),
                  imagePath: ImagePathConstant.facialImage,
                  text: StringConstant.facial,
                ),
                StackedImageText(
                  onTap: () => context
                      .read<BottomNavigationProvider>()
                      .setCurrentScreenIndex(
                        context: context,
                        indexValue: 1,
                        applyServiceFilter: true,
                        appliedService: ServiceEnum.SPA,
                      ),
                  imagePath: ImagePathConstant.massageImage,
                  text: StringConstant.massage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget dummyDeal() {
    return Container(
      height: 20.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.h),
        color: Color(0xFF3F64E6),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: 95.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(
                    'assets/images/dummy_deal_background.png',
                    height: 10.h,
                  ),
                  Image.asset(
                    'assets/images/dummy_deal_woman.png',
                    height: 17.h,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 2.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '50%',
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'WOMAN HAIRCUT',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
