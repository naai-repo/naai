import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/models/review.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/view/utils/colors_constant.dart';
import 'package:naai/view/utils/image_path_constant.dart';
import 'package:naai/view/utils/string_constant.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';

class SalonDetailsScreen extends StatefulWidget {
  const SalonDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SalonDetailsScreen> createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen> {
  int selectedTab = 0;
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    print('Aaya');
    context.read<SalonDetailsProvider>().setSelectedSalonData(context);
    print('Gaya');
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
        return Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: 'Salon${provider.selectedSalonIndex}',
                child: Stack(
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
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: SmoothPageIndicator(
                              controller: provider.salonImageCarouselController,
                              count: provider.imagePaths.length,
                              effect: ScaleEffect(
                                activeDotColor: Colors.white,
                                dotHeight: 1.w,
                                dotWidth: 1.w,
                                spacing: 5.w,
                                scale: 2,
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.h),
                  topRight: Radius.circular(5.h),
                ),
                child: Container(
                  height: 70.h,
                  padding: EdgeInsets.only(top: 1.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.h),
                      topRight: Radius.circular(5.h),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        salonDetailOverview(),
                        Divider(
                          thickness: 5,
                          color: ColorsConstant.graphicFillDark,
                        ),
                        availableStaffList(),
                        SizedBox(height: 3.h),
                        Divider(
                          thickness: 5,
                          height: 0,
                          color: ColorsConstant.graphicFillDark,
                        ),
                        selectedTab == 0
                            ? Column(
                                children: <Widget>[
                                  Container(
                                    height: 10.h,
                                    decoration: BoxDecoration(
                                      color: ColorsConstant.graphicFillDark,
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Container(),
                                                Container(),
                                              ],
                                            ),
                                            // TODO: Search bar
                                            // Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: provider
                                        .selectedSalonData.services?.length,
                                    itemBuilder: (context, index) {
                                      ServiceDetail? serviceDetail = provider
                                          .selectedSalonData.services?[index];
                                      return Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 1.h),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 3.w,
                                          vertical: 1.5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(1.h),
                                          border: Border.all(
                                              color: ColorsConstant
                                                  .reviewBoxBorderColor),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            SvgPicture.asset(ImagePathConstant
                                                .hairstyleWomenIcon),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  serviceDetail?.serviceTitle ??
                                                      "",
                                                  style: TextStyle(
                                                    color:
                                                        ColorsConstant.textDark,
                                                    fontSize: 11.sp,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 2.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    addReviewContainer(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 2.h, bottom: 1.h),
                                      child: Text(
                                        StringConstant.userReviews,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: ColorsConstant
                                              .blackAvailableStaff,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    (provider.selectedSalonData.reviewList
                                                    ?.length ??
                                                0) >
                                            0
                                        ? reviewList()
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: servicesAndReviewTabBar(),
    );
  }

  Widget reviewList() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: provider.selectedSalonData.reviewList?.length,
        itemBuilder: (context, index) {
          Review? reviewItem = provider.selectedSalonData.reviewList?[index];

          return Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.5.h,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1.h),
              border: Border.all(color: ColorsConstant.reviewBoxBorderColor),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 229, 229, 229),
                  spreadRadius: 0.1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                reviewerImageAndName(
                  imageUrl: reviewItem?.imagePath,
                  userName: reviewItem?.userName ?? "",
                ),
                SizedBox(width: 2.w),
                Container(
                  constraints: BoxConstraints(maxWidth: 60.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ...List.generate(
                            5,
                            (i) => SvgPicture.asset(
                              ImagePathConstant.starIcon,
                              color: i < (reviewItem?.rating as int)
                                  ? ColorsConstant.appColor
                                  : ColorsConstant.greyStar,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 0.5.h, bottom: 1.h),
                        child: Text(
                          '${DateFormat.yMMMM().format(reviewItem?.createdAt ?? DateTime.now())}',
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Text(
                        reviewItem?.reviewText ?? "",
                        style: TextStyle(
                          fontSize: 10.sp,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget reviewerImageAndName({String? imageUrl, required String userName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 5.h,
          backgroundImage: AssetImage('assets/images/salon_dummy_image.png'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 0.5.h),
          child: Text(
            userName,
            style: TextStyle(
              fontSize: 10.sp,
              color: ColorsConstant.textDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget addReviewContainer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
      decoration: BoxDecoration(
          color: ColorsConstant.graphicFillDark,
          borderRadius: BorderRadius.circular(2.h)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                ImagePathConstant.addYourReviewIcon,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(width: 5.w),
              Text(
                StringConstant.addYourReview,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(width: 5.w),
              ...List.generate(
                5,
                (index) => SvgPicture.asset(ImagePathConstant.reviewStarIcon),
              ),
              SizedBox(width: 5.w),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 6.h,
            child: TextFormField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 5.w,
                  right: 5.w,
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: StringConstant.summarizeYourReview,
                hintStyle: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorsConstant.textLight,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(1.5.h),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 1.5.h,
              horizontal: 10.w,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1.5.h),
            ),
            child: Text(
              StringConstant.submitReview,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12.sp,
                color: ColorsConstant.appColor,
              ),
            ),
          ),
        ],
      ),
    );
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
                    child: Text(StringConstant.reviews),
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
        padding: EdgeInsets.only(left: 6.w, right: 6.w, top: 2.h),
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
            Container(
              height: 20.h,
              child: ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: provider.selectedSalonData.artist?.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(2.h),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 2.5.w,
                        top: 0.5.h,
                        bottom: 0.5.h,
                        left: index == 0 ? 0 : 2.5.w,
                      ),
                      width: 30.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2.h),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            spreadRadius: 0.1,
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 1.h, horizontal: 3.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.h),
                              child: Container(
                                height: 8.h,
                                width: 8.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/salon_dummy_image.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              provider.selectedSalonData.artist?[index].name ??
                                  "",
                              style: TextStyle(fontSize: 11.sp),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List<Widget>.generate(
                                5,
                                (i) => (i >
                                        int.parse(provider.selectedSalonData
                                                    .artist?[index].rating
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
      return Padding(
        padding: EdgeInsets.only(top: 3.h, left: 6.w, right: 7.w, bottom: 2.h),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(ImagePathConstant.leftArrowIcon),
                ),
                SvgPicture.asset(ImagePathConstant.burgerIcon),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
              decoration: BoxDecoration(
                color: ColorsConstant.graphicFill,
                borderRadius: BorderRadius.circular(2.h),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    provider.selectedSalonData.salonType ?? "",
                    style: TextStyle(
                      color: ColorsConstant.greySalonType,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: 50.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              provider.selectedSalonData.name ?? "",
                              style: TextStyle(
                                color: ColorsConstant.textDark,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "${provider.selectedSalonData.address}, ",
                                    style: TextStyle(
                                      color: ColorsConstant.greySalonAddress,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 3.w, bottom: 1.w),
                                      child: SvgPicture.asset(
                                        ImagePathConstant.goToLocationIcon,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(minWidth: 15.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.8.h, horizontal: 1.5.h),
                        decoration: BoxDecoration(
                          color: ColorsConstant.greenRating,
                          borderRadius: BorderRadius.circular(3.h),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${provider.selectedSalonData.rating}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            SvgPicture.asset(
                              ImagePathConstant.starIcon,
                              color: Colors.white,
                              height: 2.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SvgPicture.asset(ImagePathConstant.phoneIcon),
                SvgPicture.asset(ImagePathConstant.shareIcon),
                SvgPicture.asset(ImagePathConstant.saveIcon),
              ],
            ),
          ],
        ),
      );
    });
  }
}
