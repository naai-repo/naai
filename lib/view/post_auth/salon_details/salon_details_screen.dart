import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/variable_width_cta.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SalonDetailsScreen extends StatefulWidget {
  const SalonDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen> {
  int selectedTab = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SalonDetailsProvider>().initSalonDetailsData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<SalonDetailsProvider>().clearSelectedGendersFilter();
        context.read<SalonDetailsProvider>().clearSearchController();
        context.read<SalonDetailsProvider>().clearSelectedServiceCategories();
        return true;
      },
      child:
          Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                imageCarousel(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      salonDetailOverview(),
                      Divider(
                        thickness: 5,
                        height: 0,
                        color: ColorsConstant.graphicFillDark,
                      ),
                      selectedTab == 0
                          ? ReusableWidgets.servicesTab()
                          : ReusableWidgets.reviewsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              servicesAndReviewTabBar(),
              provider.totalPrice > 0
                  ? Container(
                      margin: EdgeInsets.only(
                        bottom: 2.h,
                        right: 5.w,
                        left: 5.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 3.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.h),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            offset: Offset(0, 2.0),
                            color: Colors.grey,
                            spreadRadius: 0.2,
                            blurRadius: 15,
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                StringConstant.total,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10.sp,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                              Text(
                                'Rs. ${provider.totalPrice}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ],
                          ),
                          VariableWidthCta(
                            onTap: () => Navigator.pushNamed(
                              context,
                              NamedRoutes.createBookingRoute,
                            ),
                            buttonText: StringConstant.confirmBooking,
                          )
                        ],
                      ),
                    )
                  : SizedBox()
            ],
          ),
        );
      }),
    );
  }

  Widget imageCarousel() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SizedBox(
            height: 35.h,
            child: PageView(
              physics: BouncingScrollPhysics(),
              controller: provider.salonImageCarouselController,
              children: <Widget>[
                ...provider.imagePaths.map((imageUrl) {
                  return Image.asset(
                    imageUrl,
                    fit: BoxFit.cover,
                  );
                }),
              ],
            ),
          ),
          (provider.imagePaths.length) > 1
              ? Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: SmoothPageIndicator(
                    controller: provider.salonImageCarouselController,
                    count: provider.imagePaths.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: ColorsConstant.appColor,
                      dotHeight: 2.w,
                      dotWidth: 2.w,
                      spacing: 2.w,
                    ),
                  ),
                )
              : SizedBox(),
          Positioned(
            top: 5.h,
            right: 0,
            left: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.all(1.h),
                      child: SvgPicture.asset(
                        ImagePathConstant.leftArrowIcon,
                        color: Colors.white,
                        height: 2.5.h,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(1.h),
                    child: SvgPicture.asset(
                      ImagePathConstant.burgerIcon,
                      color: Colors.white,
                      height: 2.5.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget servicesAndReviewTabBar() {
    return Container(
      height: 7.h,
      color: Colors.white,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: Container(
            color: Colors.white,
            child: TabBar(
              labelColor: ColorsConstant.appColor,
              indicatorColor: ColorsConstant.appColor,
              unselectedLabelColor: ColorsConstant.divider,
              indicatorSize: TabBarIndicatorSize.tab,
              onTap: (tabIndex) => setState(() {
                selectedTab = tabIndex;
              }),
              tabs: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Tab(
                    child: Text(StringConstant.services),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Tab(
                    child: Text(StringConstant.reviews.toUpperCase()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget availableStaffList() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              StringConstant.availableStaff,
              style: TextStyle(
                fontSize: 11.sp,
                color: ColorsConstant.blackAvailableStaff,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              height: 11.h,
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: provider.artistList.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(1.5.h),
                    child: GestureDetector(
                      onTap: () {
                        provider.setSelectedArtistIndex(context, index: index);
                        Navigator.pushNamed(
                          context,
                          NamedRoutes.barberProfileRoute,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: 0.5.h,
                          left: index == 0 ? 0 : 2.5.w,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.5.h),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade100,
                              spreadRadius: 0.1,
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: Container(
                                height: 7.h,
                                width: 7.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/salon_dummy_image.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  provider.artistList[index].name ?? "",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorsConstant.textDark,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List<Widget>.generate(
                                    5,
                                    (i) => (i >
                                            int.parse(provider.artistList[index]
                                                        .rating
                                                        ?.round()
                                                        .toString() ??
                                                    "0") -
                                                1)
                                        ? SvgPicture.asset(
                                            ImagePathConstant.starIcon,
                                            color: ColorsConstant.greyStar,
                                            height: 2.h,
                                          )
                                        : SvgPicture.asset(
                                            ImagePathConstant.starIcon,
                                            color: ColorsConstant.yellowStar,
                                            height: 2.h,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget salonDetailOverview() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
        margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
        decoration: BoxDecoration(
          color: ColorsConstant.lightAppColor,
          borderRadius: BorderRadius.circular(1.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 50.w,
                  child: Text(
                    provider.selectedSalonData.name ?? "",
                    style: TextStyle(
                      color: ColorsConstant.textDark,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(minWidth: 15.w),
                  padding: EdgeInsets.symmetric(
                    vertical: 0.8.h,
                    horizontal: 1.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsConstant.greenRating,
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
                      SvgPicture.asset(
                        ImagePathConstant.starIcon,
                        color: Colors.white,
                        height: 2.h,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "${provider.selectedSalonData.rating}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
              provider.selectedSalonData.salonType ?? "",
              style: TextStyle(
                color: ColorsConstant.textLight,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            salonAddress(
                address:
                    provider.selectedSalonData.address?.addressString ?? ""),
            salonTiming(),
            salonContactDetails(),
            SizedBox(height: 2.h),
            availableStaffList(),
          ],
        ),
      );
    });
  }

  Widget salonTiming() {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(2.h),
            ),
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
                    text: " | ",
                    style: TextStyle(
                      color: ColorsConstant.textLight,
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
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 2.w),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(2.h),
            ),
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
                    text: " | ",
                    style: TextStyle(
                      color: ColorsConstant.textLight,
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
    );
  }

  Widget salonAddress({required String address}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        children: <Widget>[
          Flexible(
            child: Text(
              "$address,  ",
              style: TextStyle(
                color: ColorsConstant.textLight,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 3.w, bottom: 1.w),
            child: SvgPicture.asset(
              ImagePathConstant.goToLocationIcon,
            ),
          ),
        ],
      ),
    );
  }

  Widget salonContactDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ReusableWidgets.contactTypeWidget(
          onTap: () => print('Hello'),
          iconPath: ImagePathConstant.phoneIcon,
        ),
        ReusableWidgets.contactTypeWidget(
          onTap: () => print('Hello'),
          iconPath: ImagePathConstant.shareIcon,
        ),
        ReusableWidgets.contactTypeWidget(
          onTap: () => print('Hello'),
          iconPath: ImagePathConstant.saveIcon,
        ),
        ReusableWidgets.contactTypeWidget(
          onTap: () => print('Hello'),
          iconPath: ImagePathConstant.instagramIcon,
        ),
      ],
    );
  }
}