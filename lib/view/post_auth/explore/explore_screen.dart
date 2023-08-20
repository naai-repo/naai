import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/red_button_with_text.dart';
import 'package:naai/utils/components/time_date_card.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/colorful_information_card.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ExploreProvider>().initExploreScreen(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            ReusableWidgets.appScreenCommonBackground(),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                ReusableWidgets.transparentFlexibleSpace(),
                titleSearchBarWithLocation(),
                provider.filteredSalonData.length == 0
                    ? SliverFillRemaining(
                        child: Container(
                          color: Colors.white,
                          height: 100.h,
                          width: 100.w,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          <Widget>[
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: <InlineSpan>[
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.baseline,
                                              baseline:
                                                  TextBaseline.ideographic,
                                              child: SvgPicture.asset(
                                                ImagePathConstant.scissorIcon,
                                                color: ColorsConstant.appColor,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(width: 1.w),
                                            ),
                                            TextSpan(
                                              text: StringConstant.artistNearMe,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13.sp,
                                                color: ColorsConstant.textLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          NamedRoutes.exploreStylistRoute,
                                        ),
                                        child: Text(
                                          'more>>',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: ColorsConstant.appColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxHeight: 30.h),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: provider.artistList.length,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        Artist artist =
                                            provider.artistList[index];
                                        return Padding(
                                          padding: EdgeInsets.only(right: 4.w),
                                          child: GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<BarberProvider>()
                                                  .setArtistDataFromHome(
                                                    artist,
                                                  );
                                              Navigator.pushNamed(
                                                context,
                                                NamedRoutes.barberProfileRoute,
                                              );
                                            },
                                            child: CurvedBorderedCard(
                                              borderColor:
                                                  const Color(0xFFDBDBDB),
                                              fillColor: index.isEven
                                                  ? const Color(0xFF212121)
                                                  : Colors.white,
                                              child: Container(
                                                padding: EdgeInsets.all(3.w),
                                                constraints: BoxConstraints(
                                                    maxWidth: 45.w),
                                                width: 45.w,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4.w),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Column(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(0.5
                                                                            .h),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 5.h,
                                                                  backgroundImage:
                                                                      AssetImage(
                                                                    'assets/images/salon_dummy_image.png',
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                artist.name ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: index
                                                                          .isOdd
                                                                      ? ColorsConstant
                                                                          .textDark
                                                                      : Colors
                                                                          .white,
                                                                  fontSize:
                                                                      13.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              Text(
                                                                artist.salonName ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: ColorsConstant
                                                                      .textLight,
                                                                  fontSize:
                                                                      10.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <Widget>[
                                                                Text.rich(
                                                                  TextSpan(
                                                                    children: <InlineSpan>[
                                                                      WidgetSpan(
                                                                        alignment:
                                                                            PlaceholderAlignment.baseline,
                                                                        baseline:
                                                                            TextBaseline.ideographic,
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          ImagePathConstant
                                                                              .locationIconAlt,
                                                                          color:
                                                                              ColorsConstant.purpleDistance,
                                                                          height:
                                                                              2.h,
                                                                        ),
                                                                      ),
                                                                      WidgetSpan(
                                                                        child: SizedBox(
                                                                            width:
                                                                                1.w),
                                                                      ),
                                                                      TextSpan(
                                                                        text:
                                                                            '1.3 km',
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              10.sp,
                                                                          color:
                                                                              ColorsConstant.purpleDistance,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Text.rich(
                                                                  TextSpan(
                                                                    children: <InlineSpan>[
                                                                      WidgetSpan(
                                                                        alignment:
                                                                            PlaceholderAlignment.baseline,
                                                                        baseline:
                                                                            TextBaseline.ideographic,
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          ImagePathConstant
                                                                              .starIcon,
                                                                          color:
                                                                              ColorsConstant.greenRating,
                                                                        ),
                                                                      ),
                                                                      WidgetSpan(
                                                                        child: SizedBox(
                                                                            width:
                                                                                1.w),
                                                                      ),
                                                                      TextSpan(
                                                                        text: artist
                                                                            .rating
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontSize:
                                                                              10.sp,
                                                                          color:
                                                                              ColorsConstant.greenRating,
                                                                        ),
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
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (context
                                                              .read<
                                                                  HomeProvider>()
                                                              .userData
                                                              .preferredArtist!
                                                              .contains(
                                                                  artist.id)) {
                                                            provider
                                                                .removePreferedArtist(
                                                              context,
                                                              artist.id,
                                                            );
                                                          } else {
                                                            provider
                                                                .addPreferedArtist(
                                                              context,
                                                              artist.id,
                                                            );
                                                          }
                                                        },
                                                        child: SvgPicture.asset(
                                                          ImagePathConstant
                                                              .saveIcon,
                                                          color: context
                                                                  .read<
                                                                      HomeProvider>()
                                                                  .userData
                                                                  .preferredArtist!
                                                                  .contains(
                                                                      artist.id)
                                                              ? ColorsConstant
                                                                  .appColor
                                                              : index.isOdd
                                                                  ? const Color(
                                                                      0xFF212121)
                                                                  : Colors
                                                                      .white,
                                                          height: 3.h,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text.rich(
                                        TextSpan(
                                          children: <InlineSpan>[
                                            WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.baseline,
                                              baseline:
                                                  TextBaseline.ideographic,
                                              child: SvgPicture.asset(
                                                ImagePathConstant.scissorIcon,
                                                color: ColorsConstant.appColor,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(width: 1.w),
                                            ),
                                            TextSpan(
                                              text: StringConstant.salon,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13.sp,
                                                color: ColorsConstant.textLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: RedButtonWithText(
                                          buttonText: 'Filter',
                                          textColor: ColorsConstant.appColor,
                                          fontSize: 10.sp,
                                          border: Border.all(
                                              color: ColorsConstant.appColor),
                                          icon: SvgPicture.asset(
                                              ImagePathConstant.filterIcon),
                                          fillColor:
                                              ColorsConstant.lightAppColor,
                                          borderRadius: 3.h,
                                          onTap: () {},
                                          shouldShowBoxShadow: false,
                                          isIconSuffix: true,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 1.5.w,
                                            horizontal: 2.5.w,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) =>
                                        salonCard(index),
                                    itemCount:
                                        provider.filteredSalonData.length,
                                  )
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

  Widget titleSearchBarWithLocation() {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SliverAppBar(
        elevation: 10,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(3.h),
            topRight: Radius.circular(3.h),
          ),
        ),
        backgroundColor: Colors.white,
        pinned: true,
        floating: true,
        title: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Container(
            padding: EdgeInsets.only(top: 3.h),
            child: Text(
              StringConstant.exploreSalons,
              style: StyleConstant.headingTextStyle,
            ),
          ),
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(13.h),
          child: Consumer<ExploreProvider>(builder: (context, provider, child) {
            return TabBar(
              controller: homeScreenController,
              indicatorColor: Colors.white,
              tabs: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 4.3.h, bottom: 2.h),
                    child: TextFormField(
                      controller: provider.salonSearchController,
                      cursorColor: ColorsConstant.appColor,
                      style: StyleConstant.searchTextStyle,
                      textInputAction: TextInputAction.done,
                      onChanged: (searchText) =>
                          provider.filterSalonList(searchText),
                      decoration: StyleConstant.searchBoxInputDecoration(
                        context,
                        hintText: StringConstant.search,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget salonCard(int index) {
    return Consumer<ExploreProvider>(
      builder: (context, provider, child) {
        return Container(
          color: Colors.white,
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus!.unfocus();
              provider.setSelectedSalonIndex(context, index: index);
              Navigator.pushNamed(context, NamedRoutes.salonDetailsRoute);
            },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.asset(
                            provider.filteredSalonData[index].imagePath ?? ''),
                      ),
                      Positioned(
                        top: 1.h,
                        right: 1.h,
                        child: InkWell(
                          onTap: () {
                            if (!context
                                .read<HomeProvider>()
                                .userData
                                .preferredSalon!
                                .contains(
                                    provider.filteredSalonData[index].id)) {
                              provider.addPreferedSalon(context,
                                  provider.filteredSalonData[index].id);
                            } else {
                              provider.removePreferedSalon(context,
                                  provider.filteredSalonData[index].id);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              context
                                      .read<HomeProvider>()
                                      .userData
                                      .preferredSalon!
                                      .contains(
                                          provider.filteredSalonData[index].id)
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              size: 2.5.h,
                              color: ColorsConstant.appColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.4.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        provider.filteredSalonData[index].name ?? '',
                        style: TextStyle(
                          color: ColorsConstant.textDark,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${provider.filteredSalonData[index].address?.addressString}',
                        style: TextStyle(
                          color: ColorsConstant.greySalonAddress,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(height: 1.2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ColorfulInformationCard(
                            imagePath: ImagePathConstant.locationIconAlt,
                            text:
                                '${provider.filteredSalonData[index].distanceFromUserAsString}',
                            color: ColorsConstant.purpleDistance,
                          ),
                          SizedBox(width: 3.w),
                          ColorfulInformationCard(
                            imagePath: ImagePathConstant.starIcon,
                            text: '${provider.filteredSalonData[index].rating}',
                            color: ColorsConstant.greenRating,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Row(
                    children: <Widget>[
                      TimeDateCard(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Mon - Fri",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "  |  ",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "10 AM-11 PM",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      TimeDateCard(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Tues",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "  |  ",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: "Closed",
                                style: TextStyle(
                                  color: ColorsConstant.textDark,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.2.h),
                  index == (provider.filteredSalonData.length - 1)
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
    );
  }

  Widget appScreenCommonBackground() {
    return Container(
      color: ColorsConstant.appBackgroundColor,
      alignment: Alignment.topCenter,
      child: SvgPicture.asset(
        ImagePathConstant.appBackgroundImage,
        color: ColorsConstant.graphicFill,
      ),
    );
  }
}
