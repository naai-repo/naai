import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/red_button_with_text.dart';
import 'package:naai/utils/components/time_date_card.dart';
import 'package:naai/utils/enums.dart';
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
                                        return artistCard(
                                          artist,
                                          index,
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
                                      RedButtonWithText(
                                        buttonText: StringConstant.filter,
                                        textColor: ColorsConstant.appColor,
                                        fontSize: 10.sp,
                                        border: Border.all(
                                            color: ColorsConstant.appColor),
                                        icon: provider.selectedFilterTypeList
                                                .isNotEmpty
                                            ? Text(
                                                '${provider.selectedFilterTypeList.length}',
                                                style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      ColorsConstant.appColor,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                ImagePathConstant.filterIcon),
                                        fillColor: ColorsConstant.lightAppColor,
                                        borderRadius: 3.h,
                                        onTap: () => showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(2.h),
                                            ),
                                          ),
                                          builder: (context) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  StringConstant.filter,
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        ColorsConstant.appColor,
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 2,
                                                  color:
                                                      ColorsConstant.textLight,
                                                ),
                                                SizedBox(height: 2.h),
                                                SizedBox(
                                                  width: 30.w,
                                                  child: RedButtonWithText(
                                                    buttonText:
                                                        StringConstant.rating,
                                                    icon: CircleAvatar(
                                                      radius: 1.5.h,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Icon(
                                                        Icons.close,
                                                        color: ColorsConstant
                                                            .appColor,
                                                        size: 2.h,
                                                      ),
                                                    ),
                                                    textColor: provider
                                                            .selectedFilterTypeList
                                                            .contains(FilterType
                                                                .Rating)
                                                        ? Colors.white
                                                        : ColorsConstant
                                                            .appColor,
                                                    fontSize: 10.sp,
                                                    border: Border.all(
                                                        color: ColorsConstant
                                                            .appColor),
                                                    fillColor: provider
                                                            .selectedFilterTypeList
                                                            .contains(FilterType
                                                                .Rating)
                                                        ? ColorsConstant
                                                            .appColor
                                                        : ColorsConstant
                                                            .lightAppColor,
                                                    borderRadius: 3.h,
                                                    onTap: () {
                                                      provider
                                                          .setSelectedFilter(
                                                              FilterType
                                                                  .Rating);
                                                      Navigator.pop(context);
                                                    },
                                                    shouldShowBoxShadow: false,
                                                    isIconSuffix: true,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      vertical: 1.5.w,
                                                      horizontal: 2.5.w,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                              ],
                                            );
                                          },
                                        ),
                                        shouldShowBoxShadow: false,
                                        isIconSuffix: true,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 1.5.w,
                                          horizontal: 2.5.w,
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

  Widget artistCard(
    Artist artist,
    int index,
  ) {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.only(right: 4.w),
        child: GestureDetector(
          onTap: () {
            context.read<BarberProvider>().setArtistDataFromHome(
                  artist,
                );
            Navigator.pushNamed(
              context,
              NamedRoutes.barberProfileRoute,
            );
          },
          child: CurvedBorderedCard(
            borderColor: const Color(0xFFDBDBDB),
            fillColor: index.isEven ? const Color(0xFF212121) : Colors.white,
            child: Container(
              padding: EdgeInsets.all(3.w),
              constraints: BoxConstraints(maxWidth: 45.w),
              width: 45.w,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(0.5.h),
                              child: CircleAvatar(
                                radius: 5.h,
                                backgroundImage: NetworkImage(
                                  artist.imagePath!,
                                ),
                              ),
                            ),
                            Text(
                              artist.name ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: index.isOdd
                                    ? ColorsConstant.textDark
                                    : Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              artist.salonName ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorsConstant.textLight,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.ideographic,
                                      child: SvgPicture.asset(
                                        ImagePathConstant.locationIconAlt,
                                        color: ColorsConstant.purpleDistance,
                                        height: 2.h,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 1.w),
                                    ),
                                    TextSpan(
                                      text: provider.filteredSalonData
                                          .firstWhere(
                                            (element) =>
                                                element.id == artist.salonId,
                                          )
                                          .distanceFromUserAsString,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: ColorsConstant.purpleDistance,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.ideographic,
                                      child: SvgPicture.asset(
                                        ImagePathConstant.starIcon,
                                        color: ColorsConstant.greenRating,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 1.w),
                                    ),
                                    TextSpan(
                                      text: artist.rating.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: ColorsConstant.greenRating,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.ideographic,
                                      child: SvgPicture.asset(
                                        ImagePathConstant.starIcon,
                                        color: ColorsConstant.greenRating,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 1.w),
                                    ),
                                    TextSpan(
                                      text: artist.rating.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: ColorsConstant.greenRating,
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
                          provider.removePreferedArtist(
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
                            ? ImagePathConstant.saveIconFill
                            : ImagePathConstant.saveIcon,
                        color: context
                                .read<HomeProvider>()
                                .userData
                                .preferredArtist!
                                .contains(artist.id)
                            ? ColorsConstant.appColor
                            : index.isOdd
                                ? const Color(0xFF212121)
                                : Colors.white,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn),
                    items: provider.filteredSalonData[index].imageList!
                        .map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  imageUrl,
                                  height: 35.h,
                                  width: SizerUtil.width,
                                  fit: BoxFit.fill,
                                  // When image is loading from the server it takes some time
                                  // So we will show progress indicator while loading
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
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
                                        .contains(provider
                                            .filteredSalonData[index].id)) {
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
                                              .contains(provider
                                                  .filteredSalonData[index].id)

                                         ?  CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      size: 2.5.h,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                  // Stack(
                  //   children: <Widget>[
                  //     ClipRRect(
                  //       borderRadius: BorderRadius.circular(5),
                  //       child: Image.network(
                  //         provider.filteredSalonData[index].imageList![0],
                  //         height: 35.h,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //     Positioned(
                  //       top: 1.h,
                  //       right: 1.h,
                  //       child: InkWell(
                  //         onTap: () {
                  //           if (!context
                  //               .read<HomeProvider>()
                  //               .userData
                  //               .preferredSalon!
                  //               .contains(
                  //               provider.filteredSalonData[index].id)) {
                  //             provider.addPreferedSalon(context,
                  //                 provider.filteredSalonData[index].id);
                  //           } else {
                  //             provider.removePreferedSalon(context,
                  //                 provider.filteredSalonData[index].id);
                  //           }
                  //         },
                  //         child: Container(
                  //           padding: EdgeInsets.all(1.w),
                  //           decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             shape: BoxShape.circle,
                  //           ),
                  //           child: Icon(
                  //             context
                  //                 .read<HomeProvider>()
                  //                 .userData
                  //                 .preferredSalon!
                  //                 .contains(
                  //                 provider.filteredSalonData[index].id)
                  //                 ? CupertinoIcons.heart_fill
                  //                 : CupertinoIcons.heart,
                  //             size: 2.5.h,
                  //             color: ColorsConstant.appColor,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                          SizedBox(width: 3.w),
                          provider.filteredSalonData[index].discountPercentage==0||provider.filteredSalonData[index].discountPercentage==null?SizedBox():Container(
                            constraints: BoxConstraints(minWidth: 13.w),
                            padding: EdgeInsets.symmetric(
                              vertical: 0.3.h,
                              horizontal: 2.w,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsConstant.appColor,
                              borderRadius: BorderRadius.circular(0.5.h),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF000000).withOpacity(0.14),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${provider.filteredSalonData[index].discountPercentage} %off',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TimeDateCard(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: StringConstant.timings,
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
                                text:
                                    "${provider.formatTime(provider.filteredSalonData[index].timing!.opening ?? 0)} - ${provider.formatTime(provider.filteredSalonData[index].timing!.closing ?? 0)}",
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
                      SizedBox(height: 2.w),
                      TimeDateCard(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: StringConstant.closed,
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
                                text: provider
                                    .filteredSalonData[index].closingDay,
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

class ExploreScreen2 extends StatefulWidget {
  const ExploreScreen2({Key? key}) : super(key: key);

  @override
  State<ExploreScreen2> createState() => _ExploreScreen2State();
}

class _ExploreScreen2State extends State<ExploreScreen2>
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
                                    NamedRoutes.exploreStylistRoute2,
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
                                  return artistCard(
                                    artist,
                                    index,
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
                                RedButtonWithText(
                                  buttonText: StringConstant.filter,
                                  textColor: ColorsConstant.appColor,
                                  fontSize: 10.sp,
                                  border: Border.all(
                                      color: ColorsConstant.appColor),
                                  icon: provider.selectedFilterTypeList
                                      .isNotEmpty
                                      ? Text(
                                    '${provider.selectedFilterTypeList.length}',
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color:
                                      ColorsConstant.appColor,
                                    ),
                                  )
                                      : SvgPicture.asset(
                                      ImagePathConstant.filterIcon),
                                  fillColor: ColorsConstant.lightAppColor,
                                  borderRadius: 3.h,
                                  onTap: () => showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(2.h),
                                      ),
                                    ),
                                    builder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            StringConstant.filter,
                                            style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600,
                                              color:
                                              ColorsConstant.appColor,
                                            ),
                                          ),
                                          Divider(
                                            thickness: 2,
                                            color:
                                            ColorsConstant.textLight,
                                          ),
                                          SizedBox(height: 2.h),
                                          SizedBox(
                                            width: 30.w,
                                            child: RedButtonWithText(
                                              buttonText:
                                              StringConstant.rating,
                                              icon: CircleAvatar(
                                                radius: 1.5.h,
                                                backgroundColor:
                                                Colors.white,
                                                child: Icon(
                                                  Icons.close,
                                                  color: ColorsConstant
                                                      .appColor,
                                                  size: 2.h,
                                                ),
                                              ),
                                              textColor: provider
                                                  .selectedFilterTypeList
                                                  .contains(FilterType
                                                  .Rating)
                                                  ? Colors.white
                                                  : ColorsConstant
                                                  .appColor,
                                              fontSize: 10.sp,
                                              border: Border.all(
                                                  color: ColorsConstant
                                                      .appColor),
                                              fillColor: provider
                                                  .selectedFilterTypeList
                                                  .contains(FilterType
                                                  .Rating)
                                                  ? ColorsConstant
                                                  .appColor
                                                  : ColorsConstant
                                                  .lightAppColor,
                                              borderRadius: 3.h,
                                              onTap: () {
                                                provider
                                                    .setSelectedFilter(
                                                    FilterType
                                                        .Rating);
                                                Navigator.pop(context);
                                              },
                                              shouldShowBoxShadow: false,
                                              isIconSuffix: true,
                                              padding:
                                              EdgeInsets.symmetric(
                                                vertical: 1.5.w,
                                                horizontal: 2.5.w,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2.h),
                                        ],
                                      );
                                    },
                                  ),
                                  shouldShowBoxShadow: false,
                                  isIconSuffix: true,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 1.5.w,
                                    horizontal: 2.5.w,
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

  Widget artistCard(
      Artist artist,
      int index,
      ) {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.only(right: 4.w),
        child: GestureDetector(
          onTap: () {
            context.read<BarberProvider>().setArtistDataFromHome(
              artist,
            );
            Navigator.pushNamed(
              context,
              NamedRoutes.barberProfileRoute,
            );
          },
          child: CurvedBorderedCard(
            borderColor: const Color(0xFFDBDBDB),
            fillColor: index.isEven ? const Color(0xFF212121) : Colors.white,
            child: Container(
              padding: EdgeInsets.all(3.w),
              constraints: BoxConstraints(maxWidth: 45.w),
              width: 45.w,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(0.5.h),
                              child: CircleAvatar(
                                radius: 5.h,
                                backgroundImage: NetworkImage(
                                  artist.imagePath!,
                                ),
                              ),
                            ),
                            Text(
                              artist.name ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: index.isOdd
                                    ? ColorsConstant.textDark
                                    : Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              artist.salonName ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorsConstant.textLight,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.ideographic,
                                      child: SvgPicture.asset(
                                        ImagePathConstant.locationIconAlt,
                                        color: ColorsConstant.purpleDistance,
                                        height: 2.h,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 1.w),
                                    ),
                                    TextSpan(
                                      text: provider.filteredSalonData
                                          .firstWhere(
                                            (element) =>
                                        element.id == artist.salonId,
                                      )
                                          .distanceFromUserAsString,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: ColorsConstant.purpleDistance,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.ideographic,
                                      child: SvgPicture.asset(
                                        ImagePathConstant.starIcon,
                                        color: ColorsConstant.greenRating,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: SizedBox(width: 1.w),
                                    ),
                                    TextSpan(
                                      text: artist.rating.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                        color: ColorsConstant.greenRating,
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
                         showSignInDialog(context);
                      },
                      child: SvgPicture.asset(
                             ImagePathConstant.saveIcon,
                        color:
                             ColorsConstant.appColor,
                           //  index.isOdd
                         //   const Color(0xFF212121)
                         //   Colors.white,
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
    });
  }
  void showSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                    "assets/images/app_logo.png",
                    height: 60,
                    width:60
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Please Sign In",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                "You need to sign in first to see our conditionals",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        const StadiumBorder(),
                      ),
                    ),
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: 8.0),
                  TextButton(
                    child: Text("OK",style: TextStyle( color:Colors.black,)),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        NamedRoutes.authenticationRoute2,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
              Navigator.pushNamed(context, NamedRoutes.salonDetailsRoute2);
            },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: 1.0,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn),
                    items: provider.filteredSalonData[index].imageList!
                        .map((imageUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  imageUrl,
                                  height: 35.h,
                                  width: SizerUtil.width,
                                  fit: BoxFit.fill,
                                  // When image is loading from the server it takes some time
                                  // So we will show progress indicator while loading
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                            .expectedTotalBytes !=
                                            null
                                            ? loadingProgress
                                            .cumulativeBytesLoaded /
                                            loadingProgress
                                                .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 1.h,
                                right: 1.h,
                                child: InkWell(
                                  onTap: () {
                                   showSignInDialog(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                     /* context
                                          .read<HomeProvider>()
                                          .userData
                                          .preferredSalon!
                                          .contains(provider
                                          .filteredSalonData[index].id)
*/
                                           CupertinoIcons.heart,
                                          //: CupertinoIcons.heart,
                                      size: 2.5.h,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                  // Stack(
                  //   children: <Widget>[
                  //     ClipRRect(
                  //       borderRadius: BorderRadius.circular(5),
                  //       child: Image.network(
                  //         provider.filteredSalonData[index].imageList![0],
                  //         height: 35.h,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //     Positioned(
                  //       top: 1.h,
                  //       right: 1.h,
                  //       child: InkWell(
                  //         onTap: () {
                  //           if (!context
                  //               .read<HomeProvider>()
                  //               .userData
                  //               .preferredSalon!
                  //               .contains(
                  //               provider.filteredSalonData[index].id)) {
                  //             provider.addPreferedSalon(context,
                  //                 provider.filteredSalonData[index].id);
                  //           } else {
                  //             provider.removePreferedSalon(context,
                  //                 provider.filteredSalonData[index].id);
                  //           }
                  //         },
                  //         child: Container(
                  //           padding: EdgeInsets.all(1.w),
                  //           decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             shape: BoxShape.circle,
                  //           ),
                  //           child: Icon(
                  //             context
                  //                 .read<HomeProvider>()
                  //                 .userData
                  //                 .preferredSalon!
                  //                 .contains(
                  //                 provider.filteredSalonData[index].id)
                  //                 ? CupertinoIcons.heart_fill
                  //                 : CupertinoIcons.heart,
                  //             size: 2.5.h,
                  //             color: ColorsConstant.appColor,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                          SizedBox(width: 3.w),
                          provider.filteredSalonData[index].discountPercentage==0||provider.filteredSalonData[index].discountPercentage==null?SizedBox():Container(
                            constraints: BoxConstraints(minWidth: 13.w),
                            padding: EdgeInsets.symmetric(
                              vertical: 0.3.h,
                              horizontal: 2.w,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsConstant.appColor,
                              borderRadius: BorderRadius.circular(0.5.h),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF000000).withOpacity(0.14),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '${provider.filteredSalonData[index].discountPercentage} %off',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TimeDateCard(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: StringConstant.timings,
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
                                text:
                                "${provider.formatTime(provider.filteredSalonData[index].timing!.opening ?? 0)} - ${provider.formatTime(provider.filteredSalonData[index].timing!.closing ?? 0)}",
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
                      SizedBox(height: 2.w),
                      TimeDateCard(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: StringConstant.closed,
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
                                text: provider
                                    .filteredSalonData[index].closingDay,
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