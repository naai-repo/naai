import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/icon_text_selector_component.dart';
import 'package:naai/utils/components/process_status_indicator_text.dart';
import 'package:naai/utils/components/variable_width_cta.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CreateBookingScreen extends StatelessWidget {
  const CreateBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
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
                          StringConstant.yourAppointment,
                          style: StyleConstant.headingTextStyle,
                        ),
                      ],
                    ),
                  ),
                  centerTitle: false,
                ),
                SliverFillRemaining(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                    ),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        salonOverviewCard(),
                        SizedBox(height: 2.h),
                        CurvedBorderedCard(
                          child: Column(
                            children: <Widget>[
                              schedulingStatus(),
                              SizedBox(height: 2.h),
                              Padding(
                                padding: EdgeInsets.all(2.h),
                                child: Column(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () =>
                                          provider.setStaffSelectionMethod(
                                              selectedSingleStaff: true),
                                      child: selectSingleStaffCard(),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.h),
                                      child: Text(
                                        StringConstant.or,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          provider.setStaffSelectionMethod(
                                              selectedSingleStaff: false),
                                      child: selectMultipleStaffCard(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(bottom: 3.h),
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
                                onTap: () {},
                                buttonText: StringConstant.next,
                                horizontalPadding: 7.w,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget schedulingStatus() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ProcessStatusIndicatorText(
              text: StringConstant.selectStaff,
              isActive: provider.isOnSelectStaffType,
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.selectSlot,
              isActive: provider.isOnSelectSlot,
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.payment,
              isActive: provider.isOnPaymentPage,
            ),
          ],
        );
      },
    );
  }

  Widget selectMultipleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return CurvedBorderedCard(
          cardSelected: provider.selectedMultipleStaff,
          child: Container(
            padding: EdgeInsets.fromLTRB(3.w, 0.5.h, 3.w, 2.h),
            child: IconTextSelectorComponent(
              text: StringConstant.multipleStaffText,
              iconPath: ImagePathConstant.multipleStaffIcon,
              isSelected: provider.selectedMultipleStaff,
            ),
          ),
        );
      },
    );
  }

  Widget selectSingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return CurvedBorderedCard(
          cardSelected: provider.selectedSingleStaff,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: IconTextSelectorComponent(
                  text: StringConstant.singleStaffText,
                  iconPath: ImagePathConstant.singleStaffIcon,
                  isSelected: provider.selectedSingleStaff,
                ),
              ),
              SizedBox(height: 1.5.h),
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: Color(0xFFEA8BA1),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(1.h),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  StringConstant.useThisToSaveTime,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget salonOverviewCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: EdgeInsets.all(1.h),
          margin: EdgeInsets.symmetric(vertical: 1.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1.h),
            color: ColorsConstant.lightAppColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(1.h),
                child: Image.asset(
                  provider.selectedSalonData.imagePath ?? '',
                  height: 15.h,
                  width: 15.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.salon,
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      provider.selectedSalonData.name ?? '',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontWeight: FontWeight.w700,
                        fontSize: 18.sp,
                      ),
                    ),
                    Text(
                      provider.selectedSalonData.address?.addressString ?? '',
                      style: TextStyle(
                        color: ColorsConstant.textDark,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
