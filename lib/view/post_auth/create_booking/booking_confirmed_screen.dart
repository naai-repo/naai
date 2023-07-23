import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/routing/named_routes.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BookingConfirmedSreen extends StatelessWidget {
  const BookingConfirmedSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.h),
                Image.asset(
                  width: 80.w,
                  ImagePathConstant.bookingConfirmationImage,
                ),
                Text(
                  StringConstant.bookingConfirmed,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsConstant.textDark,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  StringConstant.bookingConfirmedSubtext,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: ColorsConstant.textLight,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  provider.selectedSalonData.name ?? '',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsConstant.textDark,
                  ),
                ),
                SizedBox(height: 1.h),
                SizedBox(
                  width: 75.w,
                  child: Text(
                    provider.selectedSalonData.address?.addressString ?? '',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: ColorsConstant.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  StringConstant.timeSlot,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorsConstant.blackAvailableStaff,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  provider.convertSecondsToTimeString(
                      provider.currentBooking.startTime ?? 0),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorsConstant.textDark,
                  ),
                ),
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () {
                    provider.resetCurrentBooking();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(1.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.h),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 1,
                          color: ColorsConstant.dropShadowColor,
                        ),
                      ],
                      color: ColorsConstant.appColor,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SvgPicture.asset(
                          height: 1.5.h,
                          ImagePathConstant.backArrowIos,
                          color: Colors.white,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'Back to salon page',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
