import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/models/review.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/view/utils/colors_constant.dart';
import 'package:naai/view/utils/enums.dart';
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
  bool isHover = false;
  @override
  void initState() {
    context.read<SalonDetailsProvider>().setSelectedSalonData(context);
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
      child: Scaffold(
        body:
            Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
          return SingleChildScrollView(
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
                        color: ColorsConstant.graphicFillDark,
                      ),
                      SizedBox(height: 3.h),
                      Divider(
                        thickness: 5,
                        height: 0,
                        color: ColorsConstant.graphicFillDark,
                      ),
                      selectedTab == 0 ? servicesTab() : reviewsTab(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        bottomNavigationBar: servicesAndReviewTabBar(),
      ),
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
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      ImagePathConstant.leftArrowIcon,
                      color: Colors.white,
                      height: 2.5.h,
                    ),
                  ),
                  SvgPicture.asset(
                    ImagePathConstant.burgerIcon,
                    color: Colors.white,
                    height: 2.5.h,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget reviewsTab() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            addReviewContainer(),
            Padding(
              padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
              child: Text(
                StringConstant.userReviews,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: ColorsConstant.blackAvailableStaff,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            (provider.selectedSalonData.reviewList?.length ?? 0) > 0
                ? reviewList()
                : SizedBox(),
          ],
        ),
      );
    });
  }

  Widget servicesTab() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
            child: Container(
              padding: EdgeInsets.all(2.h),
              decoration: BoxDecoration(
                color: ColorsConstant.graphicFillDark,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  genderAndSearchFilterWidget(),
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, bottom: 1.h),
                    child: Text(
                      "${StringConstant.selectCategory}:",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                  ),
                  serviceCategoryFilterWidget(),
                ],
              ),
            ),
          ),
          provider.filteredServiceList.length == 0
              ? Container(
                  height: 10.h,
                  child: Center(
                    child: Text('Nothing here :('),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: provider.filteredServiceList.length,
                  itemBuilder: (context, index) {
                    ServiceDetail? serviceDetail =
                        provider.filteredServiceList[index];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 1.5.h, horizontal: 5.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1.h),
                        border: Border.all(color: ColorsConstant.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SvgPicture.asset(
                              ImagePathConstant.hairstyleWomenIcon),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 52.w,
                                child: Text(
                                  serviceDetail.serviceTitle ?? "",
                                  style: TextStyle(
                                    color: ColorsConstant.textDark,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Rs. ${serviceDetail.price}",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                    SizedBox(width: 1.h),
                                    SvgPicture.asset(ImagePathConstant.tickBox),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
          SizedBox(height: 3.h),
        ],
      );
    });
  }

  Widget serviceCategoryFilterWidget() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Container(
        height: 4.2.h,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: ServiceEnum.values.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              provider.setSelectedServiceCategories(
                selectedServiceCategory: ServiceEnum.values[index],
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 2.w),
              height: 4.2.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.7.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.h),
                color: provider.selectedServiceCategories
                        .contains(ServiceEnum.values[index])
                    ? ColorsConstant.appColor
                    : Colors.white,
              ),
              child: Center(
                child: Text(
                  "${ServiceEnum.values[index].name}",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: provider.selectedServiceCategories
                            .contains(ServiceEnum.values[index])
                        ? Colors.white
                        : ColorsConstant.textDark,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget genderAndSearchFilterWidget() {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 5.h,
            child: Row(
              children: <Widget>[
                genderFilterTabs(isMen: true, isWomen: false),
                genderFilterTabs(isMen: false, isWomen: true),
              ],
            ),
          ),
          SizedBox(
            width: 30.w,
            height: 4.5.h,
            child: TextFormField(
              controller: provider.searchController,
              cursorColor: ColorsConstant.appColor,
              style: TextStyle(
                fontSize: 11.sp,
                color: ColorsConstant.textDark,
                fontWeight: FontWeight.w500,
              ),
              textInputAction: TextInputAction.done,
              onChanged: (searchText) =>
                  provider.filterOnSearchText(searchText),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 3.5.w),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 0.5.w),
                  child: SvgPicture.asset(
                    ImagePathConstant.searchIcon,
                    color: ColorsConstant.textDark,
                    height: 11.sp,
                  ),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 8.w),
                hintText: StringConstant.search,
                hintStyle: TextStyle(
                  color: ColorsConstant.textDark,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.h),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget genderFilterTabs({
    required bool isMen,
    required bool isWomen,
  }) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () => provider.setSelectedGendersFilter(
            selectedGender: isMen ? Gender.MEN : Gender.WOMEN),
        child: Container(
          margin: EdgeInsets.only(right: 2.w),
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: provider.selectedGendersFilter.isEmpty
                ? Colors.white
                : isMen
                    ? provider.selectedGendersFilter.contains(Gender.MEN)
                        ? ColorsConstant.selectedGenderFilterBoxColor
                        : Colors.white
                    : provider.selectedGendersFilter.contains(Gender.WOMEN)
                        ? ColorsConstant.selectedGenderFilterBoxColor
                        : Colors.white,
            borderRadius: BorderRadius.circular(1.5.w),
            border: Border.all(
              color: provider.selectedGendersFilter.isEmpty
                  ? ColorsConstant.divider
                  : isMen
                      ? provider.selectedGendersFilter.contains(Gender.MEN)
                          ? ColorsConstant.appColor
                          : ColorsConstant.divider
                      : provider.selectedGendersFilter.contains(Gender.WOMEN)
                          ? ColorsConstant.appColor
                          : ColorsConstant.divider,
            ),
            boxShadow: provider.selectedGendersFilter.isEmpty
                ? null
                : isMen
                    ? provider.selectedGendersFilter.contains(Gender.MEN)
                        ? [
                            BoxShadow(
                              color: Color(0xFF000000).withOpacity(0.14),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : null
                    : provider.selectedGendersFilter.contains(Gender.WOMEN)
                        ? [
                            BoxShadow(
                              color: ColorsConstant.dropShadowColor,
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 3.h,
                width: 3.h,
                margin: EdgeInsets.only(right: 1.5.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.w),
                  border: Border.all(
                    color: provider.selectedGendersFilter.isEmpty
                        ? ColorsConstant.unselectedGenderAbbrColor
                        : isMen
                            ? provider.selectedGendersFilter
                                    .contains(Gender.MEN)
                                ? ColorsConstant.selectedGenderAbbrColor
                                : ColorsConstant.unselectedGenderAbbrColor
                            : provider.selectedGendersFilter
                                    .contains(Gender.WOMEN)
                                ? ColorsConstant.selectedGenderAbbrColor
                                : ColorsConstant.unselectedGenderAbbrColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    isMen ? 'M' : 'W',
                    style: TextStyle(
                      color: provider.selectedGendersFilter.isEmpty
                          ? ColorsConstant.unselectedGenderAbbrColor
                          : isMen
                              ? provider.selectedGendersFilter
                                      .contains(Gender.MEN)
                                  ? ColorsConstant.selectedGenderAbbrColor
                                  : ColorsConstant.unselectedGenderAbbrColor
                              : provider.selectedGendersFilter
                                      .contains(Gender.WOMEN)
                                  ? ColorsConstant.selectedGenderAbbrColor
                                  : ColorsConstant.unselectedGenderAbbrColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Text(
                isMen ? StringConstant.men : StringConstant.women,
                style: TextStyle(
                  color: ColorsConstant.textDark,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    });
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
                  constraints: BoxConstraints(maxWidth: 55.w),
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
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
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
            GestureDetector(
              onHorizontalDragUpdate: (details) {
                print(details.localPosition.dx);
                provider.setColor(details.localPosition.dx);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(width: 5.w),
                  ...List.generate(
                    5,
                    (index) => SvgPicture.asset(
                      ImagePathConstant.reviewStarIcon,
                      color: provider.colors[index],
                    ),
                  ),
                  SizedBox(width: 5.w),
                ],
              ),
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
                itemCount: provider.selectedSalonData.artist?.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(1.5.h),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: 2.5.w,
                        top: 0.5.h,
                        bottom: 0.5.h,
                        left: index == 0 ? 0 : 2.5.w,
                      ),
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 1.h,
                          horizontal: 3.w,
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
                                  provider.selectedSalonData.artist?[index]
                                          .name ??
                                      "",
                                  style: TextStyle(fontSize: 11.sp),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
            salonAddress(address: provider.selectedSalonData.address ?? ""),
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
        salonContactImages(
          onTap: () => print('Hello'),
          iconPath: ImagePathConstant.phoneIcon,
        ),
        salonContactImages(
          onTap: () => print('Hello'),
          iconPath: ImagePathConstant.shareIcon,
        ),
        salonContactImages(
          onTap: () => print('Hello'),
          iconPath: ImagePathConstant.saveIcon,
        ),
        salonContactImages(
          onTap: () => print('Hello'),
          iconPath: ImagePathConstant.instagramIcon,
        ),
      ],
    );
  }

  Widget salonContactImages({
    required Function() onTap,
    required String iconPath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6),
        height: 5.h,
        width: 5.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.h),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 5),
              color: Color(0xFF000000).withOpacity(0.14),
              spreadRadius: 0.5,
              blurRadius: 15,
            ),
          ],
        ),
        child: SvgPicture.asset(
          iconPath,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
