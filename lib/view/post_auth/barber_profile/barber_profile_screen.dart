import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/review.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/add_review_component.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/contact_and_interaction_widget.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
      context.read<BarberProvider>().initArtistData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BarberProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  ReusableWidgets.transparentFlexibleSpace(),
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
                                height: 2.h,
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
                                    top: 1.h, right: 4.w, left: 4.w),
                                padding: EdgeInsets.all(1.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.h),
                                ),
                                child: barberOverview(),
                              ),
                              SizedBox(height: 2.h),
                              Divider(
                                thickness: 2,
                                height: 0,
                                color: ColorsConstant.graphicFillDark,
                              ),
                              servicesAndReviewTabBar(),
                              selectedTab == 0
                                  ? ReusableWidgets.servicesTab()
                                  : reviewColumn(),
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
      },
    );
  }

  Widget reviewColumn() {
    return Consumer<BarberProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AddReviewComponent(),
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
              provider.artistReviewList.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: provider.artistReviewList.length,
                      itemBuilder: (context, index) {
                        Review? reviewItem = provider.artistReviewList[index];

                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 1.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1.h),
                            border: Border.all(
                                color: ColorsConstant.reviewBoxBorderColor),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(
                                  255,
                                  229,
                                  229,
                                  229,
                                ),
                                spreadRadius: 0.1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              reviewerImageAndName(
                                imageUrl: reviewItem.imagePath,
                                userName: reviewItem.userName ?? "",
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
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
                                            color: i <
                                                    (int.parse(provider
                                                            .artistReviewList[
                                                                index]
                                                            .rating
                                                            ?.round()
                                                            .toString() ??
                                                        "0"))
                                                ? ColorsConstant.appColor
                                                : ColorsConstant.greyStar,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 0.5.h, bottom: 1.h),
                                      child: Text(
                                        '${DateFormat.yMMMM().format(reviewItem.createdAt ?? DateTime.now())}',
                                        style: TextStyle(
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      reviewItem.comment ?? "",
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
                    )
                  : SizedBox(),
            ],
          ),
        );
      },
    );
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

  Widget barberOverview() {
    return Consumer<BarberProvider>(builder: (context, provider, child) {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                child: Container(
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
                    radius: 7.h,
                    backgroundImage: AssetImage(
                      'assets/images/salon_dummy_image.png',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      provider.artist.name ?? '',
                      style: TextStyle(
                        color: ColorsConstant.blackAvailableStaff,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    SizedBox(height: 0.6.h),
                    Text(
                      StringConstant.worksAt,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.worksAtColor,
                        fontSize: 8.sp,
                      ),
                    ),
                    Text(
                      provider.artist.salonName ?? '',
                      style: TextStyle(
                        color: ColorsConstant.blackAvailableStaff,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
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
                        fontSize: 10.sp,
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
                                            ?.floor()
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
                    ),
                  ],
                ),
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
                            fontWeight: FontWeight.w600,
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
          SizedBox(height: 3.h),
          ContactAndInteractionWidget(
            iconOnePath: ImagePathConstant.phoneIcon,
            iconTwoPath: ImagePathConstant.shareIcon,
            iconThreePath: ImagePathConstant.saveIcon,
            iconFourPath: ImagePathConstant.instagramIcon,
            onTapIconOne: () => launchUrl(
              Uri(
                scheme: 'tel',
                path: '+919717950608',
              ),
            ),
            onTapIconTwo: () => print('Two'),
            onTapIconThree: () => print('Three'),
            onTapIconFour: () => print('Four'),
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
              padding: EdgeInsets.symmetric(horizontal: 3.w),
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
