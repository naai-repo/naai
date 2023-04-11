import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/review.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class BarberProfileScreen extends StatefulWidget {
  BarberProfileScreen({Key? key}) : super(key: key);

  @override
  State<BarberProfileScreen> createState() => _BarberProfileScreenState();
}

class _BarberProfileScreenState extends State<BarberProfileScreen> {
  int selectedTab = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BarberProvider>().setArtistData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BarberProvider>(
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
                  SliverAppBar(
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
                    leadingWidth: 0,
                    title: Container(
                      padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => Navigator.pop(context),
                            child: Padding(
                              padding: EdgeInsets.all(1.h),
                              child: SvgPicture.asset(
                                ImagePathConstant.leftArrowIcon,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            StringConstant.barberProfile,
                            style: StyleConstant.headingTextStyle,
                          ),
                        ],
                      ),
                    ),
                    centerTitle: false,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: 4.h, right: 4.w, left: 4.w),
                                padding: EdgeInsets.all(1.h),
                                decoration: BoxDecoration(
                                  color: ColorsConstant.lightAppColor,
                                  borderRadius: BorderRadius.circular(2.h),
                                ),
                                child: barberOverview(),
                              ),
                              SizedBox(height: 2.h),
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
                ],
              ),
            ],
          ),
          bottomNavigationBar: servicesAndReviewTabBar(),
        );
      },
    );
  }

  Widget barberOverview() {
    return Consumer<BarberProvider>(builder: (context, provider, child) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(0.5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9.5.h),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 2),
                      color: Colors.grey.shade300,
                      spreadRadius: 0.5,
                      blurRadius: 15,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 9.h,
                  backgroundImage: AssetImage(
                    'assets/images/salon_dummy_image.png',
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            provider.artist.name ?? '',
                            style: TextStyle(
                              color: ColorsConstant.blackAvailableStaff,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                            ),
                            overflow: TextOverflow.fade,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            StringConstant.worksAt,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ColorsConstant.worksAtColor,
                              fontSize: 10.sp,
                            ),
                          ),
                          Text(
                            context
                                    .read<SalonDetailsProvider>()
                                    .selectedSalonData
                                    .name ??
                                '',
                            style: TextStyle(
                              color: ColorsConstant.blackAvailableStaff,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 3.w),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.h),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 38.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        StringConstant.rating,
                        style: TextStyle(
                          color: ColorsConstant.textDark,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<Widget>.generate(
                          5,
                          (i) => (i >
                                  int.parse(provider.artist.rating
                                              ?.round()
                                              .toString() ??
                                          "0") -
                                      1)
                              ? SvgPicture.asset(
                                  ImagePathConstant.starIcon,
                                  color: ColorsConstant.greyStar,
                                  height: 2.2.h,
                                )
                              : SvgPicture.asset(
                                  ImagePathConstant.starIcon,
                                  color: ColorsConstant.yellowStar,
                                  height: 2.2.h,
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.white,
                  thickness: 0.5.w,
                ),
                SizedBox(
                  width: 38.w,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.2.h,
                        horizontal: 5.w,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.h),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 10,
                              spreadRadius: 0.1,
                            ),
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            StringConstant.viewSalon,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorsConstant.appColor,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          SvgPicture.asset(
                            ImagePathConstant.rightArrowIcon,
                            color: ColorsConstant.appColor,
                            height: 1.5.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          Row(
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
            ],
          ),
          SizedBox(height: 1.h),
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
}
