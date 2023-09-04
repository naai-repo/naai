import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/booking.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/text_with_prefix_icon.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/booked_salon_and_artist_name.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Scaffold(
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
                            onTap: () {
                              Navigator.pop(context);
                            },
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
                            StringConstant.bookingHistory,
                            style: StyleConstant.headingTextStyle,
                          ),
                        ],
                      ),
                    ),
                    centerTitle: false,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                            top: 0,
                            right: 5.w,
                            left: 5.w,
                            bottom: 100.h,
                          ),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: provider.allBookings.length,
                              itemBuilder: (context, index) {
                                Booking booking = provider.allBookings[index];
                                return Visibility(
                                  visible: DateTime.parse(
                                          booking.bookingCreatedFor ?? '')
                                      .isAfter(DateTime.now()),
                                  child: previousBookingCard(),
                                );
                              },
                            ),
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

  Widget previousBookingCard() {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.only(bottom: 2.h),
        child: CurvedBorderedCard(
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
                      nameText: provider.allBookings.last.salonName ?? '',
                    ),
                    Visibility(
                      visible: provider.artistList.isNotEmpty,
                      child: BookedSalonAndArtistName(
                        headerText: StringConstant.artist,
                        headerIconPath: ImagePathConstant.artistIcon,
                        nameText: provider.allBookings.last.artistName ?? '',
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
                      provider.allBookings.last.bookedServiceNames?[index] ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    separatorBuilder: (context, index) => Text(', '),
                    itemCount:
                        provider.allBookings.last.bookedServiceNames?.length ?? 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
