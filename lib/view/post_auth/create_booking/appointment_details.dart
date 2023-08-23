import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/red_button_with_text.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AppointmentDetails extends StatelessWidget {
  final int index;

  const AppointmentDetails({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                splashRadius: 0.1,
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.arrow_back,
                  color: ColorsConstant.textDark,
                ),
              ),
              Text(
                StringConstant.appointmentDetails,
                style: StyleConstant.textDark15sp600Style,
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 1.h),
                padding: EdgeInsets.symmetric(
                  vertical: 1.h,
                  horizontal: 3.w,
                ),
                decoration: BoxDecoration(
                  color: provider.lastOrNextBooking[index].isUpcoming
                      ? const Color(0xFFF6DE86)
                      : const Color(0xFF52D185).withOpacity(0.08),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      provider.lastOrNextBooking[index].isUpcoming
                          ? StringConstant.upcoming.toUpperCase()
                          : StringConstant.completed.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                        color: provider.lastOrNextBooking[index].isUpcoming
                            ? ColorsConstant.textDark
                            : const Color(0xFF52D185),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                              text: '${StringConstant.booked}: ',
                              style: StyleConstant.textLight11sp400Style),
                          TextSpan(
                            text: provider
                                .lastOrNextBooking[index].createdOnString,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    appointmentOverview(provider),
                    SizedBox(height: 7.h),
                    textInRow(
                      textOne: StringConstant.customerName,
                      textTwo: provider.userData.name ?? '',
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Visibility(
                          visible: provider.userData.phoneNumber != null,
                          child: Text(
                            StringConstant.mobileNumber,
                            style: StyleConstant.textLight11sp400Style,
                          ),
                          replacement: Text(
                            StringConstant.email,
                            style: StyleConstant.textLight11sp400Style,
                          ),
                        ),
                        Visibility(
                          visible: provider.userData.phoneNumber != null,
                          child: Text(
                            provider.userData.phoneNumber ?? '',
                            style: StyleConstant.textDark12sp500Style,
                          ),
                          replacement: Text(
                            provider.userData.gmailId ?? '',
                            style: StyleConstant.textDark12sp500Style,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: RedButtonWithText(
                            fontSize: 10.sp,
                            fillColor: Colors.white,
                            buttonText: StringConstant.callCustomer,
                            textColor: Colors.black,
                            onTap: () {},
                            shouldShowBoxShadow: false,
                            border: Border.all(),
                            icon: SvgPicture.asset(ImagePathConstant.phoneIcon),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          flex: 1,
                          child: RedButtonWithText(
                            fontSize: 10.sp,
                            fillColor: Colors.white,
                            buttonText: StringConstant.addToFavourites,
                            textColor: Colors.black,
                            onTap: () {},
                            shouldShowBoxShadow: false,
                            border: Border.all(),
                            icon: Icon(Icons.star_border),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      StringConstant.invoice,
                      style: StyleConstant.textDark11sp600Style,
                    ),
                    SizedBox(height: 1.h),
                    textInRow(
                      textOne: StringConstant.subtotal,
                      textTwo:
                          'Rs ${provider.lastOrNextBooking[index].totalPrice}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Visibility(
            visible: provider.lastOrNextBooking[index].isUpcoming,
            replacement: Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: RedButtonWithText(
                buttonText: StringConstant.askForReview,
                onTap: () {},
                fillColor: Colors.white,
                textColor: ColorsConstant.textDark,
                border: Border.all(),
                shouldShowBoxShadow: false,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RedButtonWithText(
                  buttonText: StringConstant.startAppointment,
                  onTap: () {},
                  fillColor: ColorsConstant.textDark,
                  shouldShowBoxShadow: false,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  border: Border.all(color: ColorsConstant.textDark),
                ),
                SizedBox(height: 1.h),
                RedButtonWithText(
                  buttonText: StringConstant.cancel,
                  onTap: () {},
                  fillColor: Colors.white,
                  textColor: ColorsConstant.textDark,
                  border: Border.all(),
                  shouldShowBoxShadow: false,
                  icon: Icon(Icons.close),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                SizedBox(height: 1.h),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget textInRow({
    required String textOne,
    required String textTwo,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          textOne,
          style: StyleConstant.textLight11sp400Style,
        ),
        Text(
          textTwo,
          style: StyleConstant.textDark12sp500Style,
        ),
      ],
    );
  }

  Widget appointmentOverview(HomeProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CurvedBorderedCard(
          fillColor: const Color(0xFFE9EDF7),
          removeBottomPadding: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  StringConstant.barber,
                  style: StyleConstant.textLight11sp400Style,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${provider.lastOrNextBooking[index].artistName}',
                  style: StyleConstant.textDark12sp600Style,
                ),
                SizedBox(height: 1.5.h),
                Text(
                  StringConstant.appointmentDateAndTime,
                  style: StyleConstant.textLight11sp400Style,
                ),
                SizedBox(height: 0.5.h),
                Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                        text: provider.getFormattedDateOfBooking(
                          secondaryDateFormat: true,
                          dateTimeString: provider
                              .lastOrNextBooking[index].bookingCreatedFor,
                          index: index,
                        ),
                        style: StyleConstant.textDark12sp600Style,
                      ),
                      TextSpan(
                        text: ' | ',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: ColorsConstant.textLight,
                        ),
                      ),
                      TextSpan(
                        text: provider.getFormattedDateOfBooking(
                          getTimeScheduled: true,
                          dateTimeString: provider
                              .lastOrNextBooking[index].bookingCreatedFor,
                          index: index,
                        ),
                        style: StyleConstant.textDark12sp600Style,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 1.5.h),
                Text(
                  StringConstant.services,
                  style: StyleConstant.textLight11sp400Style,
                ),
                SizedBox(height: 0.5.h),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 5.h),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Text(
                      provider
                          .lastOrNextBooking[index].bookedServiceNames![index],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 11.sp,
                        color: const Color(0xFF212121),
                      ),
                    ),
                    separatorBuilder: (context, index) => Text(', '),
                    itemCount: provider.lastOrNextBooking[index]
                            .bookedServiceNames?.length ??
                        0,
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
