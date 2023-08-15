import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/red_button_with_text.dart';
import 'package:naai/utils/components/text_with_prefix_icon.dart';
import 'package:naai/utils/components/time_date_card.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/booked_salon_and_artist_name.dart';
import 'package:naai/view/widgets/colorful_information_card.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view/widgets/stacked_image_text.dart';
import 'package:naai/view/widgets/title_with_line.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/bottom_navigation_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
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
                                  logoAndNotifications(),
                                  searchLocationBar(),
                                  dummyDeal(),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
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
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Visibility(
                                visible: provider.lastOrNextBooking != null &&
                                    provider.lastOrNextBooking!.isUpcoming,
                                child: upcomingBookingCard(),
                                replacement: previousBookingCard(),
                              ),
                            ),
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

  Widget previousBookingCard() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return CurvedBorderedCard(
        fillColor: const Color(0xFFFCF3F3),
        borderColor: const Color(0xFFF3D3DB),
        borderRadius: 2.h,
        child: Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextWithPrefixIcon(
                iconPath: ImagePathConstant.scissorIcon,
                text: StringConstant.previousBooking,
                textColor: ColorsConstant.textDark,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                iconHeight: 3.h,
              ),
              SizedBox(height: 3.h),
              Row(
                children: <Widget>[
                  BookedSalonAndArtistName(
                    headerText: StringConstant.salon,
                    headerIconPath: ImagePathConstant.salonChairIcon,
                    nameText: provider.lastOrNextBooking?.salonName ?? '',
                  ),
                  Visibility(
                    visible: provider.artistList.isNotEmpty,
                    child: BookedSalonAndArtistName(
                      headerText: StringConstant.artist,
                      headerIconPath: ImagePathConstant.artistIcon,
                      nameText: provider.lastOrNextBooking?.artistName ?? '',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                StringConstant.services,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsConstant.appColor,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 5.h),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Text(
                    provider.lastOrNextBooking?.bookedServiceNames?[index] ??
                        '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 11.sp,
                      color: const Color(0xFF212121),
                    ),
                  ),
                  separatorBuilder: (context, index) => Text(', '),
                  itemCount:
                      provider.lastOrNextBooking?.bookedServiceNames?.length ??
                          0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RedButtonWithText(
                    buttonText: StringConstant.bookAgain,
                    onTap: () => provider.populateBookingData(context),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    border: Border.all(color: ColorsConstant.appColor),
                    shouldShowBoxShadow: false,
                  ),
                  SizedBox(width: 5.w),
                  RedButtonWithText(
                    onTap: () => Navigator.pushNamed(
                      context,
                      NamedRoutes.appointmentDetailsRoute,
                    ),
                    buttonText: StringConstant.seeAllBookings,
                    fillColor: Colors.white,
                    textColor: ColorsConstant.appColor,
                    border: Border.all(color: ColorsConstant.appColor),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 1.h,
                    ),
                    shouldShowBoxShadow: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget upcomingBookingCard() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          NamedRoutes.appointmentDetailsRoute,
        ),
        child: Container(
          padding: EdgeInsets.all(1.5.h),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/upcoming_booking_card_bg.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
            color: ColorsConstant.appColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TitleWithLine(
                    lineHeight: 2.5.h,
                    lineWidth: 0.6.w,
                    fontSize: 12.sp,
                    lineColor: Colors.white,
                    textColor: Colors.white,
                    text: StringConstant.viewAllAppointments.toUpperCase(),
                  ),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(1.2.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 2.5.h,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 1.h),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.5.h),
                ),
                child: Padding(
                  padding: EdgeInsets.all(1.5.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        provider.lastOrNextBooking?.salonName ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '${StringConstant.appointment} :',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: <Widget>[
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getFormattedDate: true,
                                dateTimeString: provider
                                    .lastOrNextBooking?.bookingCreatedFor,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getAbbreviatedDay: true,
                                dateTimeString: provider
                                    .lastOrNextBooking?.bookingCreatedFor,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          TimeDateCard(
                            fillColor: ColorsConstant.textDark,
                            child: Text(
                              provider.getFormattedDateOfBooking(
                                getTimeScheduled: true,
                                dateTimeString: provider
                                    .lastOrNextBooking?.bookingCreatedFor,
                              ),
                              style: StyleConstant.bookingDateTimeTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget logoAndNotifications() {
    return Row(
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
                cursorColor: ColorsConstant.appColor,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
                textInputAction: TextInputAction.done,
                onChanged: (searchText) => print(searchText),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorsConstant.graphicFillDark,
                  contentPadding: EdgeInsets.symmetric(horizontal: 3.5.w),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: SvgPicture.asset(
                      ImagePathConstant.searchIcon,
                      height: 2.h,
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 9.w),
                  hintText: StringConstant.search,
                  hintStyle: TextStyle(
                    color: ColorsConstant.textLight,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.h),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.all(1.h),
              decoration: BoxDecoration(
                color: ColorsConstant.graphicFillDark,
                borderRadius: BorderRadius.circular(4.h),
              ),
              child: SvgPicture.asset(ImagePathConstant.appointmentIcon),
            ),
          ],
        )
      ],
    );
  }

  Widget searchLocationBar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        NamedRoutes.setHomeLocationRoute,
      ),
      child: Container(
        margin: EdgeInsets.only(top: 4.h, bottom: 2.h),
        padding: EdgeInsets.all(0.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.h),
          color: ColorsConstant.graphicFillDark,
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          bool _shouldScroll = (TextPainter(
                text: TextSpan(
                    text: Provider.of<HomeProvider>(context, listen: true)
                            .userData
                            .homeLocation
                            ?.addressString ??
                        "",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    )),
                maxLines: 1,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
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
                child: SvgPicture.asset(ImagePathConstant.homeLocationIcon),
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
                        pauseAfterRound: const Duration(seconds: 1),
                        blankSpace: 30.0,
                        style: TextStyle(
                          color: ColorsConstant.textLight,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : Text(
                        "${context.read<HomeProvider>().getHomeAddressText()}",
                        style: TextStyle(
                          color: ColorsConstant.textLight,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
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
    );
  }

  Widget ourStylist() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
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
            SizedBox(height: 2.h),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (provider.artistList.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        index = 2 * index;

                        Artist artist = provider.artistList[index];
                        return artistCard(
                          isThin: (index / 2).floor().isEven,
                          name: artist.name ?? '',
                          rating: artist.rating ?? 0,
                          salonName: artist.salonName ?? '',
                          artistId: artist.id ?? '',
                          color: ColorsConstant.artistListColors[index % 6],
                          onTap: () {
                            context
                                .read<BarberProvider>()
                                .setArtistDataFromHome(artist);
                            Navigator.pushNamed(
                              context,
                              NamedRoutes.barberProfileRoute,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: (provider.artistList.length / 2).floor(),
                      itemBuilder: (context, index) {
                        index = 2 * index + 1;
                        Artist artist = provider.artistList[index];
                        return artistCard(
                          isThin: ((index - 1) / 2).floor().isOdd,
                          name: artist.name ?? '',
                          rating: artist.rating ?? 0,
                          salonName: artist.salonName ?? '',
                          artistId: artist.id ?? '',
                          color: ColorsConstant.artistListColors[index % 6],
                          onTap: () {
                            context
                                .read<BarberProvider>()
                                .setArtistDataFromHome(artist);
                            Navigator.pushNamed(
                              context,
                              NamedRoutes.barberProfileRoute,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget artistCard({
    bool isThin = true,
    required String name,
    required double rating,
    required String salonName,
    required String artistId,
    required Color color,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            margin: isThin
                ? EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  )
                : EdgeInsets.symmetric(
                    horizontal: 1.5.w,
                    vertical: 1.h,
                  ),
            // height: isThin ? 25.h : 33.h,
            decoration: BoxDecoration(
              color: color,
              boxShadow: <BoxShadow>[
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
                        name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        salonName.toUpperCase(),
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
                SizedBox(height: isThin ? 3.h : 5.h),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                if (!context
                    .read<HomeProvider>()
                    .userData
                    .preferredArtist!
                    .contains(artistId)) {
                  context
                      .read<HomeProvider>()
                      .addPreferedArtist(context, artistId);
                } else {
                  context.read<HomeProvider>().removePreferedArtist(
                        context,
                        artistId,
                      );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  context
                          .read<HomeProvider>()
                          .userData
                          .preferredArtist!
                          .contains(artistId)
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  size: 20,
                  color: ColorsConstant.appColor,
                ),
              ),
            ),
          )
        ],
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
              padding: EdgeInsets.only(top: 2.h),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: provider.salonList.length,
                itemBuilder: (context, index) {
                  SalonData salon = provider.salonList[index];

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
                                        text: provider.salonList[index]
                                            .getDistanceAsString(
                                          provider.userCurrentLatLng,
                                        ),
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
        vertical: 1.h,
        horizontal: 3.w,
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
            margin: EdgeInsets.symmetric(vertical: 2.h),
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
                        appliedService: Services.HAIR,
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
                        appliedService: Services.MAKEUP,
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
                        appliedService: Services.SPA,
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
