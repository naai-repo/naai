import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/red_button_with_text.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ExploreStylist extends StatefulWidget {
  const ExploreStylist({Key? key}) : super(key: key);

  @override
  State<ExploreStylist> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreStylist>
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
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(3.w, 0, 3.w, 2.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      WidgetSpan(
                                        alignment:
                                            PlaceholderAlignment.baseline,
                                        baseline: TextBaseline.ideographic,
                                        child: SvgPicture.asset(
                                          ImagePathConstant.scissorIcon,
                                          color: ColorsConstant.appColor,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 1.w),
                                      ),
                                      TextSpan(
                                        text: StringConstant.stylists,
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
                                    buttonText: StringConstant.filter,
                                    textColor: ColorsConstant.appColor,
                                    fontSize: 10.sp,
                                    border: Border.all(
                                        color: ColorsConstant.appColor),
                                    icon: SvgPicture.asset(
                                        ImagePathConstant.filterIcon),
                                    fillColor: ColorsConstant.lightAppColor,
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
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: provider.artistList.length,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 7.5 / 10.0,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (context, index) {
                                Artist artist = provider.artistList[index];
                                return Container(
                                  margin: EdgeInsets.only(bottom: 2.5.h),
                                  padding: EdgeInsets.only(
                                    left: index.isEven ? 0 : 2.5.w,
                                    right: index.isEven ? 2.5.w : 0,
                                  ),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      context
                                          .read<BarberProvider>()
                                          .setArtistDataFromHome(artist);
                                      Navigator.pushNamed(
                                        context,
                                        NamedRoutes.barberProfileRoute,
                                      );
                                    },
                                    child: CurvedBorderedCard(
                                      borderColor: const Color(0xFFDBDBDB),
                                      fillColor: Colors.white,
                                      child: Container(
                                        padding: EdgeInsets.all(3.w),
                                        constraints:
                                            BoxConstraints(maxWidth: 30.w),
                                        child: Stack(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.w),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            0.5.h),
                                                        child: CircleAvatar(
                                                          radius: 5.h,
                                                          backgroundImage:
                                                              AssetImage(
                                                            'assets/images/salon_dummy_image.png',
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        artist.name ?? '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: ColorsConstant
                                                              .textDark,
                                                          fontSize: 13.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      Text(
                                                        artist.salonName ?? '',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: ColorsConstant
                                                              .textLight,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
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
                                                                    PlaceholderAlignment
                                                                        .baseline,
                                                                baseline:
                                                                    TextBaseline
                                                                        .ideographic,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  ImagePathConstant
                                                                      .locationIconAlt,
                                                                  color: ColorsConstant
                                                                      .purpleDistance,
                                                                  height: 2.h,
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                child: SizedBox(
                                                                    width: 1.w),
                                                              ),
                                                              TextSpan(
                                                                text: provider
                                                                    .salonData
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .id ==
                                                                        artist
                                                                            .salonId)
                                                                    .distanceFromUserAsString,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: ColorsConstant
                                                                      .purpleDistance,
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
                                                                    PlaceholderAlignment
                                                                        .baseline,
                                                                baseline:
                                                                    TextBaseline
                                                                        .ideographic,
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  ImagePathConstant
                                                                      .starIcon,
                                                                  color: ColorsConstant
                                                                      .greenRating,
                                                                ),
                                                              ),
                                                              WidgetSpan(
                                                                child: SizedBox(
                                                                    width: 1.w),
                                                              ),
                                                              TextSpan(
                                                                text: artist
                                                                    .rating
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: ColorsConstant
                                                                      .greenRating,
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
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  if (context
                                                      .read<HomeProvider>()
                                                      .userData
                                                      .preferredArtist!
                                                      .contains(artist.id)) {
                                                    provider
                                                        .removePreferedArtist(
                                                      context,
                                                      artist.id,
                                                    );
                                                  } else {
                                                    provider.addPreferedArtist(
                                                      context,
                                                      artist.id,
                                                    );
                                                  }
                                                },
                                                child: SvgPicture.asset(
                                                  context
                                                          .read<HomeProvider>()
                                                          .userData
                                                          .preferredArtist!
                                                          .contains(artist.id)
                                                      ? ImagePathConstant
                                                          .saveIconFill
                                                      : ImagePathConstant
                                                          .saveIcon,
                                                  color: context
                                                          .read<HomeProvider>()
                                                          .userData
                                                          .preferredArtist!
                                                          .contains(artist.id)
                                                      ? ColorsConstant.appColor
                                                      : const Color(0xFF212121),
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

  MediaQuery titleSearchBarWithLocation() {
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
              StringConstant.exploreStylists,
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
