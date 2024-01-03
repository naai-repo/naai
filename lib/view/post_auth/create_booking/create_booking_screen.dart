import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/components/curved_bordered_card.dart';
import 'package:naai/utils/components/icon_text_selector_component.dart';
import 'package:naai/utils/components/process_status_indicator_text.dart';
import 'package:naai/utils/components/rating_box.dart';
import 'package:naai/utils/components/variable_width_cta.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/keys.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/profile/profile_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../../../models/service_detail.dart';
import 'booking_confirmed_screen.dart';

class CreateBookingScreen extends StatefulWidget {


  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  bool singleStaffListExpanded = false;
  bool showArtistSlotDialogue = false;
  bool multipleStaffListExpanded = false;
  bool InsideMultipleStaffExpanded = false;
  int selectedRadio = 0; // Assuming 0 as the default value
 // Razorpay _razorpay = Razorpay();



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().getUserDataFromUserProvider(context);
    });
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("success");
    context.read<SalonDetailsProvider>().createBooking(
          context,
          "success",
          paymentId: response.paymentId,
          orderId: response.orderId,
        );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    context.read<SalonDetailsProvider>().createBooking(
          context,
          "error",
          errorMessage: response.message,
        );
    ReusableWidgets.showFlutterToast(context, '${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    String? walletName = response.walletName;
    ReusableWidgets.showFlutterToast(context, 'External Wallet: $walletName');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () async {
          provider.resetCurrentBooking();
          return true;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
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
                              provider.resetCurrentBooking();
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
                            StringConstant.yourAppointment,
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
                          height:MediaQuery.of(context).size.height,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                          ),
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              salonOverviewCard(),
                              SizedBox(height: 2.h),
                              //Code for MultiService
                              /*
                              if (provider.isOnPaymentPage) paymentComponent() else Column(
                                      children: <Widget>[
                                        schedulingStatus(),
                                        SizedBox(height: 2.h),
                                        if (provider.isOnSelectStaffType)
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal:2.h),
                                            child: selectSingleStaffCard(),
                                          ),
                                        if (provider.isOnSelectStaffType  && !singleStaffListExpanded  )
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2.h),
                                              child: Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(2.w),
                                                  color: const Color(
                                                      0xffFFB6C1),
                                                ),
                                                child: const Center(
                                                  child: Text(
                                                    StringConstant.Staff,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      //     fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        if (provider.isOnSelectStaffType)
                                        SizedBox(height: 2.h),
                                        if (provider.isOnSelectStaffType)
                                        authenticationOptionsDivider(),
                                        if (provider.isOnSelectStaffType)
                                        Padding(
                                          padding: EdgeInsets.all(2.h),
                                          child: selectMingleStaffCard(),
                                        ),
                                        if (provider.isOnSelectSlot)
                                          slotSelectionWidget(),
                                      ],
                                    ),
                              SizedBox(height: 35.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              */
                              provider.isOnPaymentPage
                                  ? paymentComponent()
                                  : Column(
                                children: <Widget>[
                                  schedulingStatus(),
                                  SizedBox(height: 2.h),
                                  if (provider.isOnSelectStaffType)
                                    Padding(
                                      padding: EdgeInsets.all(2.h),
                                      child: ForNowselectSingleStaffCard(),
                                    ),
                                  if (provider.isOnSelectSlot)
                                    slotSelectionWidget(),
                                ],
                              ),
                              SizedBox(height: 35.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              !provider.isOnPaymentPage
                  ? Positioned(
                      bottom: 3.h,
                      right: 3.h,
                      left: 3.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 1.h,
                          horizontal: 3.w,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.h),
                          boxShadow: <BoxShadow>[
                            const BoxShadow(
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
                                Text('Rs. ${provider.showPrice==null||provider.showPrice==0 ? provider.totalPrice:provider.showPrice}',
                                    style: StyleConstant.appColorBoldTextStyle),
                              ],
                            ),
                            VariableWidthCta(
                              onTap: () {
                                if (provider.isOnSelectStaffType) {
                                  provider.setSchedulingStatus(
                                      selectStaffFinished: true);
                                } else if (provider.isOnSelectSlot) {
                                  provider.setSchedulingStatus(
                                      selectSlotFinished: true);
                                }
                              },
                              isActive: provider.isNextButtonActive,
                              buttonText: StringConstant.next,
                              horizontalPadding: 7.w,
                            )
                          ],
                        ),
                      ),
                    )
                  : Positioned(
                      bottom: 2.h,
                      right: 2.h,
                      left: 2.h,
                      child: ReusableWidgets.redFullWidthButton(
                        buttonText: StringConstant.payNow,
                        onTap: () async{
                          await context.read<SalonDetailsProvider>().createBooking(
                            context,
                            "Paid not yet", // Set your desired transaction status
                            paymentId: null,
                            orderId: null,
                            errorMessage: null,
                            // Set your desired error message or null//      );
                          // After creating the booking, navigate to the BookingConfirmedScreen
                         // Navigator.of(context).push(
                         //   MaterialPageRoute(builder: (context) => BookingConfirmedScreen()),
                          );
                        },
                        isActive: true,
                      ),
                    ),
              Align(
                alignment: Alignment.center,
                child: showArtistSlotDialogue
                    ? artistSlotPickerDialogueBox()
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget authenticationOptionsDivider() {
    return Row(
      children: <Widget>[
        SizedBox(width: 5.w),
        const Expanded(
          child: Divider(
            thickness: 2.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            StringConstant.or,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 2.0,
          ),
        ),
        SizedBox(width: 5.w),
      ],
    );
  }

  Widget paymentComponent() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(1.h),
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.h),
                color: ColorsConstant.lightAppColor,
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    BookingOverviewPart(
                      title: StringConstant.bookingFor,
                      value: context.read<HomeProvider>().userData.name ?? '',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceDate,
                      value: provider.currentBooking.selectedDate ?? '',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceTime,
                      value:
                          '${provider.convertSecondsToTimeString(provider.currentBooking.startTime ?? 0)} Hrs',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),
            CurvedBorderedCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 2.w),
                    Text(
                      StringConstant.services.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorsConstant.textLight,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(provider.currentBooking.serviceIds?.map(
                          (element) => Container(
                            margin: EdgeInsets.symmetric(vertical: 2.w),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              provider.getServiceDetails(
                                                        serviceId: element,
                                                        getGender: true,
                                                      ) ==
                                                      Gender.MEN
                                                  ? ImagePathConstant.manIcon
                                                  : ImagePathConstant.womanIcon,
                                              height: 3.h,
                                            ),
                                            SizedBox(width: 2.w),
                                            Text(
                                              provider.getServiceDetails(
                                                serviceId: element,
                                                getServiceName: true,
                                              ),
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: ColorsConstant.textDark,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.w),
                                        Text(
                                          provider.getSelectedArtistName(
                                              provider.currentBooking.artistId ??
                                                  '',
                                              context),
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: ColorsConstant.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '+',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: ColorsConstant.textLight,
                                          ),
                                        ),
                                        Text(
                                          ' ₹ ${provider.getServiceDetails(
                                            serviceId: element,
                                            getServiceCharge: true,
                                          )}',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: ColorsConstant.textDark,
                                          ),
                                        ),
                                        SizedBox(width: 2.w),
                                        provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?GestureDetector(
                                          onTap: () => provider.setSelectedService(
                                            element,
                                            removeService: true,
                                          ),
                                          child: SvgPicture.asset(
                                            ImagePathConstant.deleteIcon,
                                            height: 2.5.h,
                                          ),
                                        ):const SizedBox(),
                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ) ??
                        []),
                    provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?const SizedBox():Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Text('Discount ',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            Text('(${provider.selectedSalonData.discountPercentage ?? 0}%)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?ColorsConstant.appBackgroundColor:ColorsConstant.appColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '-',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorsConstant.textLight,
                              ),
                            ),
                            Text(
                              ' ₹ ${provider.showPrice==null||provider.showPrice==0?"0":provider.totalPrice-provider.showPrice}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(width: 2.w),
                          ],
                        ),

                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Color(0xFFD3D3D3),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StringConstant.subtotal.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorsConstant.textLight,
                                ),
                              ),
                              Text(
                                ' ₹ ${provider.showPrice==null||provider.showPrice==0?provider.totalPrice:provider.showPrice}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 2.w),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             StringConstant.tax,
                    //             style: TextStyle(
                    //               fontSize: 10.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: ColorsConstant.textDark,
                    //             ),
                    //           ),
                    //           Text(
                    //             ' ${StringConstant.gst} 18%',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: Color(0xFF47CB7C),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             '+',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               color: ColorsConstant.textLight,
                    //             ),
                    //           ),
                    //           Text(
                    //             ' ₹ ${provider.totalPrice * 0.18}',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: ColorsConstant.textDark,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            CurvedBorderedCard(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 0,
                ),
                margin: EdgeInsets.symmetric(vertical: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.grandTotal,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                    Text(
                      ' ₹ ${provider.showPrice==null||provider.showPrice==0?provider.totalPrice:provider.showPrice}',
                      // ' ₹ ${provider.totalPrice * 0.18 + provider.totalPrice}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],
        );
      },
    );
  }

  Widget artistSlotPickerDialogueBox() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => setState(() {
            showArtistSlotDialogue = false;
          }),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.5.h),
                      child: Container(
                        width: 80.w,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: 3.w,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${DateFormat.E().format(provider.currentBooking.selectedDateInDateTimeFormat ?? DateTime.now())}, ${DateFormat.yMMMMd().format(provider.currentBooking.selectedDateInDateTimeFormat ?? DateTime.now())}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.morning,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                      visible: element <= 43200,
                                      child: GestureDetector(
                                        onTap: () => provider
                                                .artistAvailabilityToDisplay
                                                .contains(element)
                                            ? provider.setBookingData(
                                                context,
                                                setSelectedTime: true,
                                                startTime: element,
                                              )
                                            : null,
                                        child: timeCard(element),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.afternoon,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                      visible:
                                          element > 43200 && element <= 57600,
                                      child: GestureDetector(
                                        onTap: () => provider
                                                .artistAvailabilityToDisplay
                                                .contains(element)
                                            ? provider.setBookingData(
                                                context,
                                                setSelectedTime: true,
                                                startTime: element,
                                              )
                                            : null,
                                        child: timeCard(element),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.evening,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                      visible: element > 57600,
                                      child: GestureDetector(
                                        onTap: () => provider
                                                .artistAvailabilityToDisplay
                                                .contains(element)
                                            ? provider.setBookingData(
                                                context,
                                                setSelectedTime: true,
                                                startTime: element,
                                              )
                                            : null,
                                        child: timeCard(element),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => setState(() {
                                    showArtistSlotDialogue = false;
                                  }),
                                  child: Text(
                                     "Hi ok", //StringConstant.ok,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget timeCard(int element) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Container(
        width: 15.w,
        padding: EdgeInsets.symmetric(vertical: 1.w),
        margin: EdgeInsets.symmetric(
          horizontal: 1.w,
          vertical: 1.5.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.h),
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(255, 214, 214, 214),
          ),
          color: provider.artistAvailabilityToDisplay.contains(element)
              ? element == (provider.currentBooking.startTime)  // Previous in bracket provider.currentBooking.startTime ?? 0
                  ? ColorsConstant.appColor
                  : Colors.white
              : Colors.grey.shade200,
        ),
        alignment: Alignment.center,
        child: Text(
          provider.convertSecondsToTimeString(element),
          style: TextStyle(
            fontSize: 9.sp,
            color: provider.artistAvailabilityToDisplay.contains(element)
                ? element == (provider.currentBooking.startTime ?? 0)
                    ? Colors.white
                    : ColorsConstant.textDark
                : Colors.white,
          ),
        ),
      );
    });
  }

  Widget slotSelectionWidget() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: <Widget>[
              CurvedBorderedCard(
                removeBottomPadding: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: <Widget>[
                      Text(
                        StringConstant.selectData,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CurvedBorderedCard(
                        onTap: () => provider.showDialogue(
                          context,
                          SizedBox(
                            height: 35.h,
                            width: 40.h,
                            child: SfDateRangePicker(
                              view: DateRangePickerView.month,
                              selectionColor: ColorsConstant.appColor,
                              backgroundColor: Colors.white,
                              headerStyle: const DateRangePickerHeaderStyle(
                                textAlign: TextAlign.center,
                              ),
                              initialSelectedDate: provider.currentBooking
                                  .selectedDateInDateTimeFormat,
                              initialDisplayDate: DateTime.now().toLocal(),
                              showNavigationArrow: true,
                              enablePastDates: false,
                              onSelectionChanged: (date) {
                                provider.setBookingData(
                                  context,
                                  setSelectedDate: true,
                                  selectedDate: date.value,
                                );
                                provider.resetTime();
                                provider.getArtistBooking(context);
                                Navigator.pop(context);
                              },
                              selectionMode:
                              DateRangePickerSelectionMode.single,

                            ),
                          ),
                        ),
                        fillColor:
                        provider.currentBooking.selectedDate?.isNotEmpty ==
                            true
                            ? ColorsConstant.appColor
                            : null,
                        removeBottomPadding: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImagePathConstant.calendarIcon,
                              color: provider.currentBooking.selectedDate
                                  ?.isNotEmpty ==
                                  true
                                  ? Colors.white
                                  : null,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              provider.currentBooking.selectedDate ??
                                  StringConstant.datePlaceholder,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: provider.currentBooking.selectedDate
                                    ?.isNotEmpty ==
                                    true
                                    ? Colors.white
                                    : ColorsConstant.textLight,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              ImagePathConstant.downArrow,
                              color: provider.currentBooking.selectedDate
                                  ?.isNotEmpty ==
                                  true
                                  ? Colors.white
                                  : ColorsConstant.textLight,
                              height: 1.h,
                              fit: BoxFit.fitHeight,
                            )
                          ],
                        ),
                        cardSelected: true,
                      ),
                      if (provider.currentBooking.selectedDate?.isNotEmpty ==
                          true)
                        Column(
                          children: <Widget>[
                            SizedBox(height: 4.h),
                            Text(
                              StringConstant.selectTimeSlot, // This thing need to be correct.
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            CurvedBorderedCard(
                              onTap: () {
                                setState(() {
                                  showArtistSlotDialogue = true;
                                });
                              },
                              fillColor:
                              provider.currentBooking.startTime != null
                                  ? ColorsConstant.appColor
                                  : null,
                              removeBottomPadding: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    ImagePathConstant.timeIcon,
                                    color: provider.currentBooking.startTime !=
                                        null
                                        ? Colors.white
                                        : null,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    provider.currentBooking.startTime != null
                                        ? provider.convertSecondsToTimeString(
                                        provider.currentBooking
                                            .startTime ??
                                            0) +
                                        ' HRS'
                                        : StringConstant.timePlaceholder,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                      provider.currentBooking.startTime !=
                                          null
                                          ? Colors.white
                                          : ColorsConstant.textLight,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.downArrow,
                                    color: provider.currentBooking.startTime !=
                                        null
                                        ? Colors.white
                                        : ColorsConstant.textLight,
                                    height: 1.h,
                                    fit: BoxFit.fitHeight,
                                  )
                                ],
                              ),
                              cardSelected: true,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget slotSelectionWidget() {
  //   return Consumer<SalonDetailsProvider>(
  //     builder: (context, provider, child) {
  //       return Padding(
  //         padding: EdgeInsets.all(2.h),
  //         child: Column(
  //           children: <Widget>[
  //             CurvedBorderedCard(
  //               removeBottomPadding: false,
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 5.w),
  //                 child: Column(
  //                   children: <Widget>[
  //                     Text(
  //                       StringConstant.selectData,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 11.sp,
  //                         color: ColorsConstant.textDark,
  //                       ),
  //                     ),
  //                     SizedBox(height: 2.h),
  //                     CurvedBorderedCard(
  //                       onTap: () => provider.showDialogue(
  //                         context,
  //                         Container(
  //                           height: 50.h,
  //                           width: 100.w,
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(5.h),
  //                             child: SfDateRangePicker(
  //                               selectionColor: ColorsConstant.appColor,
  //                               backgroundColor: Colors.white,
  //                               headerStyle: DateRangePickerHeaderStyle(
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                               initialSelectedDate: provider.currentBooking
  //                                   .selectedDateInDateTimeFormat,
  //                               initialDisplayDate: DateTime.now().toLocal(),
  //                               showNavigationArrow: true,
  //                               enablePastDates: false,
  //                               onSelectionChanged: (date) {
  //                                 provider.setBookingData(
  //                                   context,
  //                                   setSelectedDate: true,
  //                                   selectedDate: date.value,
  //                                 );
  //                                 provider.resetTime();
  //                                 provider.getArtistBooking(context);
  //                                 Navigator.pop(context);
  //                               },
  //                               selectionMode:
  //                               DateRangePickerSelectionMode.single,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       fillColor:
  //                       provider.currentBooking.selectedDate?.isNotEmpty ==
  //                           true
  //                           ? ColorsConstant.appColor
  //                           : null,
  //                       removeBottomPadding: false,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: <Widget>[
  //                           SvgPicture.asset(
  //                             ImagePathConstant.calendarIcon,
  //                             color: provider.currentBooking.selectedDate
  //                                 ?.isNotEmpty ==
  //                                 true
  //                                 ? Colors.white
  //                                 : null,
  //                           ),
  //                           SizedBox(width: 3.w),
  //                           Text(
  //                             provider.currentBooking.selectedDate ??
  //                                 StringConstant.datePlaceholder,
  //                             style: TextStyle(
  //                               fontSize: 11.sp,
  //                               fontWeight: FontWeight.w500,
  //                               color: provider.currentBooking.selectedDate
  //                                   ?.isNotEmpty ==
  //                                   true
  //                                   ? Colors.white
  //                                   : ColorsConstant.textLight,
  //                             ),
  //                           ),
  //                           SizedBox(width: 3.w),
  //                           SvgPicture.asset(
  //                             ImagePathConstant.downArrow,
  //                             color: provider.currentBooking.selectedDate
  //                                 ?.isNotEmpty ==
  //                                 true
  //                                 ? Colors.white
  //                                 : ColorsConstant.textLight,
  //                             height: 1.h,
  //                             fit: BoxFit.fitHeight,
  //                           )
  //                         ],
  //                       ),
  //                       cardSelected: true,
  //                     ),
  //                     if (provider.currentBooking.selectedDate?.isNotEmpty ==
  //                         true)
  //                       Column(
  //                         children: <Widget>[
  //                           SizedBox(height: 4.h),
  //                           Text(
  //                             StringConstant.selectTimeSlot,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 11.sp,
  //                               color: ColorsConstant.textDark,
  //                             ),
  //                           ),
  //                           SizedBox(height: 2.h),
  //                           CurvedBorderedCard(
  //                             onTap: () {
  //                               setState(() {
  //                                 showArtistSlotDialogue = true;
  //                               });
  //                             },
  //                             fillColor:
  //                             provider.currentBooking.startTime != null
  //                                 ? ColorsConstant.appColor
  //                                 : null,
  //                             removeBottomPadding: false,
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: <Widget>[
  //                                 SvgPicture.asset(
  //                                   ImagePathConstant.timeIcon,
  //                                   color: provider.currentBooking.startTime !=
  //                                       null
  //                                       ? Colors.white
  //                                       : null,
  //                                 ),
  //                                 SizedBox(width: 3.w),
  //                                 Text(
  //                                   provider.currentBooking.startTime != null
  //                                       ? provider.convertSecondsToTimeString(
  //                                       provider.currentBooking
  //                                           .startTime ??
  //                                           0) +
  //                                       ' HRS'
  //                                       : StringConstant.timePlaceholder,
  //                                   style: TextStyle(
  //                                     fontSize: 11.sp,
  //                                     fontWeight: FontWeight.w500,
  //                                     color:
  //                                     provider.currentBooking.startTime !=
  //                                         null
  //                                         ? Colors.white
  //                                         : ColorsConstant.textLight,
  //                                   ),
  //                                 ),
  //                                 SizedBox(width: 3.w),
  //                                 SvgPicture.asset(
  //                                   ImagePathConstant.downArrow,
  //                                   color: provider.currentBooking.startTime !=
  //                                       null
  //                                       ? Colors.white
  //                                       : ColorsConstant.textLight,
  //                                   height: 1.h,
  //                                   fit: BoxFit.fitHeight,
  //                                 )
  //                               ],
  //                             ),
  //                             cardSelected: true,
  //                           ),
  //                         ],
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }



  Widget schedulingStatus() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ProcessStatusIndicatorText(
              text: StringConstant.selectStaff,
              isActive: provider.isOnSelectStaffType,
              onTap: () => provider.setSchedulingStatus(onSelectStaff: true),
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.selectSlot,
              isActive: provider.isOnSelectSlot,
              onTap: () =>
                  provider.setSchedulingStatus(selectStaffFinished: true),
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.payment,
              isActive: provider.isOnPaymentPage,
              onTap: () =>
                  provider.setSchedulingStatus(selectSlotFinished: true),
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
          removeBottomPadding: false,
          onTap: () =>
              provider.setStaffSelectionMethod(selectedSingleStaff: false),
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
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: IconTextSelectorComponent(
                text: StringConstant.singleStaffText,
                iconPath: ImagePathConstant.singleStaffIcon,
                isSelected: false,
              ),
            ),
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
                singleStaffListExpanded = !singleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        if(singleStaffListExpanded)
                        Text(
                          provider.currentBooking.artistId != null
                              ? provider.getSelectedArtistName(
                                  provider.currentBooking.artistId ?? '',
                                  context)
                              : StringConstant.chooseAStaff,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),

                        ),
                        if(!singleStaffListExpanded)
                          Text(
                            StringConstant.chooseAStaff,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          ),
                        Radio(
                          activeColor:  const Color(0xFFAA2F4C),
                          value: 1,
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value! as int;
                              // Handle logic for single staff selection
                              singleStaffListExpanded = true;
                              multipleStaffListExpanded = false;
                              provider.currentBooking.artistId = null;
                            });
                          },
                        ),
                        /*
                        Radio(
                          value:  singleStaffListExpanded, // Unique value for this radio button
                          groupValue: singleStaffListExpanded,
                          onChanged: (value) {
                            setState(() {
                              singleStaffListExpanded =  singleStaffListExpanded;
                              // Handle the logic when this radio button is selected
                            });
                          },
                        ),
                        */
                      ],
                    ),
                    singleStaffListExpanded
                        ? Container(
                            constraints: BoxConstraints(maxHeight: 20.h),
                            child: ListView.separated(
                              shrinkWrap: true,
                              /* itemCount: context
                                  .read<HomeProvider>()
                                  .artistList
                                  .where((artist) => artist.salonId == provider.selectedSalonData.id)
                                  .length,
                              itemBuilder: (context, index) {
                                Artist artist = context
                                    .read<HomeProvider>()
                                    .artistList
                                    .where((artist) => artist.salonId == provider.selectedSalonData.id)
                                  // .where((artist) => artist.category == provider.selectedServiceCategories) // Filter by selected category
                                    .toList()[index];*/
                              itemCount: provider.artistList.length,
                              itemBuilder: (context, index) {
                                Artist artist =
                                provider.artistList[index];
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (provider.currentBooking.artistId ==
                                        artist.id )
                                    {
                                      provider.setBookingData(
                                        context,
                                        setArtistId: true,
                                        artistId: null,
                                      );
                                    } else {
                                      provider.setBookingData(
                                        context,
                                        setArtistId: true,
                                        artistId: artist.id,
                                      );
                                    }
                                    provider.updateIsNextButtonActive();
                                    provider.resetSlotInfo();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              WidgetSpan(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 2.w),
                                                  child: SvgPicture.asset(
                                                    artist.id ==
                                                            provider
                                                                .currentBooking
                                                                .artistId
                                                        ? ImagePathConstant
                                                            .selectedOption
                                                        : ImagePathConstant
                                                            .unselectedOption,
                                                    width: 5.w,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                text: artist.name ?? '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10.sp,
                                                  color: const Color(0xFF727272),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RatingBox(
                                          rating: artist.rating ?? 0.0,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => const Divider(),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ],
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
                child: Image.network(
                  provider.selectedSalonData.imageList![0].toString(),
                  height: 15.h,//15.h
                  width: 28.w,//15.w
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.salon.toUpperCase(),
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


  Widget selectMingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            CurvedBorderedCard(
              onTap: () => setState(() {
              //  singleStaffListExpanded = !singleStaffListExpanded;
                multipleStaffListExpanded = !multipleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                          IconTextSelectorComponent(
                            text: StringConstant.multipleStaffText,
                            iconPath: ImagePathConstant.multipleStaffIcon,
                            isSelected: false,
                          ),
                        Radio(
                          activeColor:  const Color(0xFFAA2F4C),
                          value: 2,
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value! as int;
                               singleStaffListExpanded = false;
                              multipleStaffListExpanded = true;
                              provider.currentBooking.artistId = null;
                            });
                          },
                        ),
                      ],
                    ),
                    if(multipleStaffListExpanded)
                             ...(provider.currentBooking.serviceIds?.map(
                                       (element) => Container(
                                         constraints: BoxConstraints(maxHeight: 20.h),
                                    // margin: EdgeInsets.symmetric(vertical: 2.w),
                                     child: Column(
                                       children: [
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: <Widget>[
                                             Column(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: <Widget>[
                                                 Row(
                                                   children: <Widget>[
                                                     SvgPicture.asset(
                                                       provider.getServiceDetails(
                                                         serviceId: element,
                                                         getGender: true,
                                                       ) ==
                                                           Gender.MEN
                                                           ? ImagePathConstant.manIcon
                                                           : ImagePathConstant.womanIcon,
                                                       height: 3.h,
                                                     ),
                                                     SizedBox(width: 2.w),
                                                     Text(
                                                       provider.getServiceDetails(
                                                         serviceId: element,
                                                         getServiceName: true,
                                                       ),
                                                       style: TextStyle(
                                                         fontSize: 12.sp,
                                                         color: ColorsConstant.textDark,
                                                       ),
                                                     ),
                                                   ],
                                                 ),
                                                 SizedBox(height: 1.w),
                                                 Text('  Rs. ${provider.showPrice==null||provider.showPrice==0 ? provider.totalPrice:provider.showPrice}'
                                                   ,style:(TextStyle(
                                                   fontSize: 10.sp,
                                               color: ColorsConstant.lightGreyText,
                                                   ))
                                                   ,
                                                 ),
                                               ],
                                             ),
                                           ],
                                         ),
                                         selectInsideStaffCard()
                                       ],
                                     ),
                                   ),
                             ) ??
                                     []),
                  ],
        ),
            ),
            ),
          ],
        );
      },
    );
  }

  Widget selectInsideStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
              InsideMultipleStaffExpanded = !InsideMultipleStaffExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          provider.currentBooking.artistId != null
                              ? provider.getSelectedArtistName(
                              provider.currentBooking.artistId ?? '',
                              context)
                              : StringConstant.chooseAStaff,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        SvgPicture.asset(
                          ImagePathConstant.downArrow,
                          width: 3.w,
                          color: Colors.black,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  //  singleStaffListExpanded
                   InsideMultipleStaffExpanded
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: provider.artistList.length,
                        itemBuilder: (context, index) {
                          Artist artist =
                          provider.artistList[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (provider.currentBooking.artistId ==
                                  artist.id )
                              {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: null,
                                );
                              } else {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: artist.id,
                                );
                              }
                              provider.updateIsNextButtonActive();
                              provider.resetSlotInfo();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 2.w),
                                            child: SvgPicture.asset(
                                              artist.id ==
                                                  provider
                                                      .currentBooking
                                                      .artistId
                                                  ? ImagePathConstant
                                                  .selectedOption
                                                  : ImagePathConstant
                                                  .unselectedOption,
                                              width: 5.w,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: artist.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: const Color(0xFF727272),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RatingBox(
                                    rating: artist.rating ?? 0.0,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget ForNowselectSingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: IconTextSelectorComponent(
                text: StringConstant.singleStaffText,
                iconPath: ImagePathConstant.singleStaffIcon,
                isSelected: false,
              ),
            ),
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
                singleStaffListExpanded = !singleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          provider.currentBooking.artistId != null
                              ? provider.getSelectedArtistName(
                              provider.currentBooking.artistId ?? '',
                              context)
                              : StringConstant.chooseAStaff,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        SvgPicture.asset(
                          ImagePathConstant.downArrow,
                          width: 3.w,
                          color: Colors.black,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                    singleStaffListExpanded
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        /* itemCount: context
                                  .read<HomeProvider>()
                                  .artistList
                                  .where((artist) => artist.salonId == provider.selectedSalonData.id)
                                  .length,
                              itemBuilder: (context, index) {
                                Artist artist = context
                                    .read<HomeProvider>()
                                    .artistList
                                    .where((artist) => artist.salonId == provider.selectedSalonData.id)
                                  // .where((artist) => artist.category == provider.selectedServiceCategories) // Filter by selected category
                                    .toList()[index];*/
                        itemCount: provider.serviceList.length,
                        itemBuilder: (context, index) {
                          Artist artist =
                          provider.artistList[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (provider.currentBooking.artistId ==
                                  artist.id )
                              {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: null,
                                );
                              } else {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: artist.id,
                                );
                              }
                              provider.updateIsNextButtonActive();
                              provider.resetSlotInfo();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 2.w),
                                            child: SvgPicture.asset(
                                              artist.id ==
                                                  provider
                                                      .currentBooking
                                                      .artistId
                                                  ? ImagePathConstant
                                                  .selectedOption
                                                  : ImagePathConstant
                                                  .unselectedOption,
                                              width: 5.w,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: artist.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: Color(0xFF727272),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RatingBox(
                                    rating: artist.rating ?? 0.0,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                      ),
                    )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}



class BookingOverviewPart extends StatelessWidget {
  final String value;
  final String title;

  const BookingOverviewPart({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: ColorsConstant.textLight,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: ColorsConstant.textDark,
          ),
        ),
      ],
    );
  }
}

class CreateBookingScreen2 extends StatefulWidget {
  final String? artistName;
  const CreateBookingScreen2({Key? key,this.artistName}) : super(key: key);

  @override
  State<CreateBookingScreen2> createState() => _CreateBookingScreen2State();
}

class _CreateBookingScreen2State extends State<CreateBookingScreen2> {
  bool singleStaffListExpanded = false;
  bool showArtistSlotDialogue = false;
  // Razorpay _razorpay = Razorpay();



  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().getUserDataFromUserProvider(context);
    });
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("success");
    context.read<SalonDetailsProvider>().createBooking(
      context,
      "success",
      paymentId: response.paymentId,
      orderId: response.orderId,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    context.read<SalonDetailsProvider>().createBooking(
      context,
      "error",
      errorMessage: response.message,
    );
    ReusableWidgets.showFlutterToast(context, '${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    String? walletName = response.walletName;
    ReusableWidgets.showFlutterToast(context, 'External Wallet: $walletName');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () async {
          provider.resetCurrentBooking();
          return true;
        },
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              ReusableWidgets.appScreenCommonBackground(),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
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
                              provider.resetCurrentBooking();
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
                            StringConstant.yourAppointment,
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
                          height: 100.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                          ),
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              salonOverviewCard(),
                              SizedBox(height: 2.h),
                              provider.isOnPaymentPage
                                  ? paymentComponent()
                                  : Column(
                                children: <Widget>[
                                  schedulingStatus(),
                                  SizedBox(height: 2.h),
                                  if (provider.isOnSelectStaffType)
                                    Padding(
                                      padding: EdgeInsets.all(2.h),
                                      child: selectSingleStaffCard(),
                                    ),
                                  if (provider.isOnSelectSlot)
                                    slotSelectionWidget(),
                                ],
                              ),
                              SizedBox(height: 35.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              !provider.isOnPaymentPage
                  ? Positioned(
                bottom: 3.h,
                right: 3.h,
                left: 3.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 1.h,
                    horizontal: 3.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.h),
                    boxShadow: <BoxShadow>[
                      const BoxShadow(
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
                          Text('Rs. ${provider.showPrice==null||provider.showPrice==0 ? provider.totalPrice:provider.showPrice}',
                              style: StyleConstant.appColorBoldTextStyle),
                        ],
                      ),
                      VariableWidthCta(
                        onTap: () {
                          if (provider.isOnSelectStaffType) {
                            provider.setSchedulingStatus(
                                selectStaffFinished: true);
                          } else if (provider.isOnSelectSlot) {
                            provider.setSchedulingStatus(
                                selectSlotFinished: true);
                          }
                        },
                        isActive: provider.isNextButtonActive,
                        buttonText: StringConstant.next,
                        horizontalPadding: 7.w,
                      )
                    ],
                  ),
                ),
              )
                  : Positioned(
                bottom: 2.h,
                right: 2.h,
                left: 2.h,
                child: ReusableWidgets.redFullWidthButton(
                  buttonText: StringConstant.payNow,
                  onTap: () async{
                    await context.read<SalonDetailsProvider>().createBooking(
                      context,
                      "Paid not yet", // Set your desired transaction status
                      paymentId: null,
                      orderId: null,
                      errorMessage: null,
                      // Set your desired error message or null//      );
                      // After creating the booking, navigate to the BookingConfirmedScreen
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(builder: (context) => BookingConfirmedScreen()),
                    );
                  },
                  isActive: true,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: showArtistSlotDialogue
                    ? artistSlotPickerDialogueBox()
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget paymentComponent() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(1.h),
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.h),
                color: ColorsConstant.lightAppColor,
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    BookingOverviewPart(
                      title: StringConstant.bookingFor,
                      value: context.read<HomeProvider>().userData.name ?? '',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceDate,
                      value: provider.currentBooking.selectedDate ?? '',
                    ),
                    VerticalDivider(
                      color: const Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceTime,
                      value:
                      '${provider.convertSecondsToTimeString(provider.currentBooking.startTime ?? 0)} Hrs',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h),
            CurvedBorderedCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 2.w),
                    Text(
                      StringConstant.services.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorsConstant.textLight,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(provider.currentBooking.serviceIds?.map(
                          (element) => Container(
                        margin: EdgeInsets.symmetric(vertical: 2.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          provider.getServiceDetails(
                                            serviceId: element,
                                            getGender: true,
                                          ) ==
                                              Gender.MEN
                                              ? ImagePathConstant.manIcon
                                              : ImagePathConstant.womanIcon,
                                          height: 3.h,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          provider.getServiceDetails(
                                            serviceId: element,
                                            getServiceName: true,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: ColorsConstant.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.w),
                                    Text(
                                      provider.getSelectedArtistName(
                                          provider.currentBooking.artistId ??
                                              '',
                                          context),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '+',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: ColorsConstant.textLight,
                                      ),
                                    ),
                                    Text(
                                      ' ₹ ${provider.getServiceDetails(
                                        serviceId: element,
                                        getServiceCharge: true,
                                      )}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: ColorsConstant.textDark,
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?GestureDetector(
                                      onTap: () => provider.setSelectedService(
                                        element,
                                        removeService: true,
                                      ),
                                      child: SvgPicture.asset(
                                        ImagePathConstant.deleteIcon,
                                        height: 2.5.h,
                                      ),
                                    ):const SizedBox(),
                                  ],
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ) ??
                        []),
                    provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?const SizedBox():Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Text('Discount ',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            Text('(${provider.selectedSalonData.discountPercentage ?? 0}%)',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: provider.selectedSalonData.discountPercentage==0||provider.selectedSalonData.discountPercentage==null?ColorsConstant.appBackgroundColor:ColorsConstant.appColor,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '-',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: ColorsConstant.textLight,
                              ),
                            ),
                            Text(
                              ' ₹ ${provider.showPrice==null||provider.showPrice==0?"0":provider.totalPrice-provider.showPrice}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(width: 2.w),
                          ],
                        ),

                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Color(0xFFD3D3D3),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StringConstant.subtotal.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorsConstant.textDark,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorsConstant.textLight,
                                ),
                              ),
                              Text(
                                ' ₹ ${provider.showPrice==null||provider.showPrice==0?provider.totalPrice:provider.showPrice}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 2.w),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             StringConstant.tax,
                    //             style: TextStyle(
                    //               fontSize: 10.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: ColorsConstant.textDark,
                    //             ),
                    //           ),
                    //           Text(
                    //             ' ${StringConstant.gst} 18%',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: Color(0xFF47CB7C),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Text(
                    //             '+',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               color: ColorsConstant.textLight,
                    //             ),
                    //           ),
                    //           Text(
                    //             ' ₹ ${provider.totalPrice * 0.18}',
                    //             style: TextStyle(
                    //               fontSize: 12.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: ColorsConstant.textDark,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            CurvedBorderedCard(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 0,
                ),
                margin: EdgeInsets.symmetric(vertical: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.grandTotal,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                    Text(
                      ' ₹ ${provider.showPrice==null||provider.showPrice==0?provider.totalPrice:provider.showPrice}',
                      // ' ₹ ${provider.totalPrice * 0.18 + provider.totalPrice}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 3.h),
          ],
        );
      },
    );
  }

  Widget artistSlotPickerDialogueBox() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => setState(() {
            showArtistSlotDialogue = false;
          }),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0.5.h),
                      child: Container(
                        width: 80.w,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 2.h,
                          horizontal: 3.w,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${DateFormat.E().format(provider.currentBooking.selectedDateInDateTimeFormat ?? DateTime.now())}, ${DateFormat.yMMMMd().format(provider.currentBooking.selectedDateInDateTimeFormat ?? DateTime.now())}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.morning,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                  visible: element <= 43200,
                                  child: GestureDetector(
                                    onTap: () => provider
                                        .artistAvailabilityToDisplay
                                        .contains(element)
                                        ? provider.setBookingData(
                                      context,
                                      setSelectedTime: true,
                                      startTime: element,
                                    )
                                        : null,
                                    child: timeCard(element),
                                  ),
                                ),
                              )
                                  .toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.afternoon,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                  visible:
                                  element > 43200 && element <= 57600,
                                  child: GestureDetector(
                                    onTap: () => provider
                                        .artistAvailabilityToDisplay
                                        .contains(element)
                                        ? provider.setBookingData(
                                      context,
                                      setSelectedTime: true,
                                      startTime: element,
                                    )
                                        : null,
                                    child: timeCard(element),
                                  ),
                                ),
                              )
                                  .toList(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 1.w),
                              child: Text(
                                StringConstant.evening,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                            ),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => Visibility(
                                  visible: element > 57600,
                                  child: GestureDetector(
                                    onTap: () => provider
                                        .artistAvailabilityToDisplay
                                        .contains(element)
                                        ? provider.setBookingData(
                                      context,
                                      setSelectedTime: true,
                                      startTime: element,
                                    )
                                        : null,
                                    child: timeCard(element),
                                  ),
                                ),
                              )
                                  .toList(),
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () => setState(() {
                                    showArtistSlotDialogue = false;
                                  }),
                                  child: Text(
                                    "Hi ok", //StringConstant.ok,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 4.w),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget timeCard(int element) {
    return Consumer<SalonDetailsProvider>(builder: (context, provider, child) {
      return Container(
        width: 15.w,
        padding: EdgeInsets.symmetric(vertical: 1.w),
        margin: EdgeInsets.symmetric(
          horizontal: 1.w,
          vertical: 1.5.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.h),
          border: Border.all(
            width: 1,
            color: const Color.fromARGB(255, 214, 214, 214),
          ),
          color: provider.artistAvailabilityToDisplay.contains(element)
              ? element == (provider.currentBooking.startTime)  // Previous in bracket provider.currentBooking.startTime ?? 0
              ? ColorsConstant.appColor
              : Colors.white
              : Colors.grey.shade200,
        ),
        alignment: Alignment.center,
        child: Text(
          provider.convertSecondsToTimeString(element),
          style: TextStyle(
            fontSize: 9.sp,
            color: provider.artistAvailabilityToDisplay.contains(element)
                ? element == (provider.currentBooking.startTime ?? 0)
                ? Colors.white
                : ColorsConstant.textDark
                : Colors.white,
          ),
        ),
      );
    });
  }

  Widget slotSelectionWidget() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.all(2.h),
          child: Column(
            children: <Widget>[
              CurvedBorderedCard(
                removeBottomPadding: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: <Widget>[
                      Text(
                        StringConstant.selectData,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                          color: ColorsConstant.textDark,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      CurvedBorderedCard(
                        onTap: () => provider.showDialogue(
                          context,
                          SizedBox(
                            height: 35.h,
                            width: 40.h,
                            child: SfDateRangePicker(
                              view: DateRangePickerView.month,
                              selectionColor: ColorsConstant.appColor,
                              backgroundColor: Colors.white,
                              headerStyle: const DateRangePickerHeaderStyle(
                                textAlign: TextAlign.center,
                              ),
                              initialSelectedDate: provider.currentBooking
                                  .selectedDateInDateTimeFormat,
                              initialDisplayDate: DateTime.now().toLocal(),
                              showNavigationArrow: true,
                              enablePastDates: false,
                              onSelectionChanged: (date) {
                                provider.setBookingData(
                                  context,
                                  setSelectedDate: true,
                                  selectedDate: date.value,
                                );
                                provider.resetTime();
                                provider.getArtistBooking(context);
                                Navigator.pop(context);
                              },
                              selectionMode:
                              DateRangePickerSelectionMode.single,

                            ),
                          ),
                        ),
                        fillColor:
                        provider.currentBooking.selectedDate?.isNotEmpty ==
                            true
                            ? ColorsConstant.appColor
                            : null,
                        removeBottomPadding: false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImagePathConstant.calendarIcon,
                              color: provider.currentBooking.selectedDate
                                  ?.isNotEmpty ==
                                  true
                                  ? Colors.white
                                  : null,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              provider.currentBooking.selectedDate ??
                                  StringConstant.datePlaceholder,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: provider.currentBooking.selectedDate
                                    ?.isNotEmpty ==
                                    true
                                    ? Colors.white
                                    : ColorsConstant.textLight,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              ImagePathConstant.downArrow,
                              color: provider.currentBooking.selectedDate
                                  ?.isNotEmpty ==
                                  true
                                  ? Colors.white
                                  : ColorsConstant.textLight,
                              height: 1.h,
                              fit: BoxFit.fitHeight,
                            )
                          ],
                        ),
                        cardSelected: true,
                      ),
                      if (provider.currentBooking.selectedDate?.isNotEmpty ==
                          true)
                        Column(
                          children: <Widget>[
                            SizedBox(height: 4.h),
                            Text(
                              StringConstant.selectTimeSlot, // This thing need to be correct.
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11.sp,
                                color: ColorsConstant.textDark,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            CurvedBorderedCard(
                              onTap: () {
                                setState(() {
                                  showArtistSlotDialogue = true;
                                });
                              },
                              fillColor:
                              provider.currentBooking.startTime != null
                                  ? ColorsConstant.appColor
                                  : null,
                              removeBottomPadding: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    ImagePathConstant.timeIcon,
                                    color: provider.currentBooking.startTime !=
                                        null
                                        ? Colors.white
                                        : null,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    provider.currentBooking.startTime != null
                                        ? provider.convertSecondsToTimeString(
                                        provider.currentBooking
                                            .startTime ??
                                            0) +
                                        ' HRS'
                                        : StringConstant.timePlaceholder,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color:
                                      provider.currentBooking.startTime !=
                                          null
                                          ? Colors.white
                                          : ColorsConstant.textLight,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  SvgPicture.asset(
                                    ImagePathConstant.downArrow,
                                    color: provider.currentBooking.startTime !=
                                        null
                                        ? Colors.white
                                        : ColorsConstant.textLight,
                                    height: 1.h,
                                    fit: BoxFit.fitHeight,
                                  )
                                ],
                              ),
                              cardSelected: true,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget slotSelectionWidget() {
  //   return Consumer<SalonDetailsProvider>(
  //     builder: (context, provider, child) {
  //       return Padding(
  //         padding: EdgeInsets.all(2.h),
  //         child: Column(
  //           children: <Widget>[
  //             CurvedBorderedCard(
  //               removeBottomPadding: false,
  //               child: Padding(
  //                 padding: EdgeInsets.symmetric(horizontal: 5.w),
  //                 child: Column(
  //                   children: <Widget>[
  //                     Text(
  //                       StringConstant.selectData,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         fontSize: 11.sp,
  //                         color: ColorsConstant.textDark,
  //                       ),
  //                     ),
  //                     SizedBox(height: 2.h),
  //                     CurvedBorderedCard(
  //                       onTap: () => provider.showDialogue(
  //                         context,
  //                         Container(
  //                           height: 50.h,
  //                           width: 100.w,
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(5.h),
  //                             child: SfDateRangePicker(
  //                               selectionColor: ColorsConstant.appColor,
  //                               backgroundColor: Colors.white,
  //                               headerStyle: DateRangePickerHeaderStyle(
  //                                 textAlign: TextAlign.center,
  //                               ),
  //                               initialSelectedDate: provider.currentBooking
  //                                   .selectedDateInDateTimeFormat,
  //                               initialDisplayDate: DateTime.now().toLocal(),
  //                               showNavigationArrow: true,
  //                               enablePastDates: false,
  //                               onSelectionChanged: (date) {
  //                                 provider.setBookingData(
  //                                   context,
  //                                   setSelectedDate: true,
  //                                   selectedDate: date.value,
  //                                 );
  //                                 provider.resetTime();
  //                                 provider.getArtistBooking(context);
  //                                 Navigator.pop(context);
  //                               },
  //                               selectionMode:
  //                               DateRangePickerSelectionMode.single,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       fillColor:
  //                       provider.currentBooking.selectedDate?.isNotEmpty ==
  //                           true
  //                           ? ColorsConstant.appColor
  //                           : null,
  //                       removeBottomPadding: false,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: <Widget>[
  //                           SvgPicture.asset(
  //                             ImagePathConstant.calendarIcon,
  //                             color: provider.currentBooking.selectedDate
  //                                 ?.isNotEmpty ==
  //                                 true
  //                                 ? Colors.white
  //                                 : null,
  //                           ),
  //                           SizedBox(width: 3.w),
  //                           Text(
  //                             provider.currentBooking.selectedDate ??
  //                                 StringConstant.datePlaceholder,
  //                             style: TextStyle(
  //                               fontSize: 11.sp,
  //                               fontWeight: FontWeight.w500,
  //                               color: provider.currentBooking.selectedDate
  //                                   ?.isNotEmpty ==
  //                                   true
  //                                   ? Colors.white
  //                                   : ColorsConstant.textLight,
  //                             ),
  //                           ),
  //                           SizedBox(width: 3.w),
  //                           SvgPicture.asset(
  //                             ImagePathConstant.downArrow,
  //                             color: provider.currentBooking.selectedDate
  //                                 ?.isNotEmpty ==
  //                                 true
  //                                 ? Colors.white
  //                                 : ColorsConstant.textLight,
  //                             height: 1.h,
  //                             fit: BoxFit.fitHeight,
  //                           )
  //                         ],
  //                       ),
  //                       cardSelected: true,
  //                     ),
  //                     if (provider.currentBooking.selectedDate?.isNotEmpty ==
  //                         true)
  //                       Column(
  //                         children: <Widget>[
  //                           SizedBox(height: 4.h),
  //                           Text(
  //                             StringConstant.selectTimeSlot,
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w600,
  //                               fontSize: 11.sp,
  //                               color: ColorsConstant.textDark,
  //                             ),
  //                           ),
  //                           SizedBox(height: 2.h),
  //                           CurvedBorderedCard(
  //                             onTap: () {
  //                               setState(() {
  //                                 showArtistSlotDialogue = true;
  //                               });
  //                             },
  //                             fillColor:
  //                             provider.currentBooking.startTime != null
  //                                 ? ColorsConstant.appColor
  //                                 : null,
  //                             removeBottomPadding: false,
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: <Widget>[
  //                                 SvgPicture.asset(
  //                                   ImagePathConstant.timeIcon,
  //                                   color: provider.currentBooking.startTime !=
  //                                       null
  //                                       ? Colors.white
  //                                       : null,
  //                                 ),
  //                                 SizedBox(width: 3.w),
  //                                 Text(
  //                                   provider.currentBooking.startTime != null
  //                                       ? provider.convertSecondsToTimeString(
  //                                       provider.currentBooking
  //                                           .startTime ??
  //                                           0) +
  //                                       ' HRS'
  //                                       : StringConstant.timePlaceholder,
  //                                   style: TextStyle(
  //                                     fontSize: 11.sp,
  //                                     fontWeight: FontWeight.w500,
  //                                     color:
  //                                     provider.currentBooking.startTime !=
  //                                         null
  //                                         ? Colors.white
  //                                         : ColorsConstant.textLight,
  //                                   ),
  //                                 ),
  //                                 SizedBox(width: 3.w),
  //                                 SvgPicture.asset(
  //                                   ImagePathConstant.downArrow,
  //                                   color: provider.currentBooking.startTime !=
  //                                       null
  //                                       ? Colors.white
  //                                       : ColorsConstant.textLight,
  //                                   height: 1.h,
  //                                   fit: BoxFit.fitHeight,
  //                                 )
  //                               ],
  //                             ),
  //                             cardSelected: true,
  //                           ),
  //                         ],
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }



  Widget schedulingStatus() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ProcessStatusIndicatorText(
              text: StringConstant.selectStaff,
              isActive: provider.isOnSelectStaffType,
              onTap: () => provider.setSchedulingStatus(onSelectStaff: true),
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.selectSlot,
              isActive: provider.isOnSelectSlot,
              onTap: () =>
                  provider.setSchedulingStatus(selectStaffFinished: true),
            ),
            SvgPicture.asset(
              ImagePathConstant.rightArrowIcon,
              color: ColorsConstant.dropShadowColor,
            ),
            ProcessStatusIndicatorText(
              text: StringConstant.payment,
              isActive: provider.isOnPaymentPage,
              onTap: () =>
                  provider.setSchedulingStatus(selectSlotFinished: true),
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
          removeBottomPadding: false,
          onTap: () =>
              provider.setStaffSelectionMethod(selectedSingleStaff: false),
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
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: IconTextSelectorComponent(
                text: StringConstant.singleStaffText,
                iconPath: ImagePathConstant.singleStaffIcon,
                isSelected: false,
              ),
            ),
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
                singleStaffListExpanded = !singleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          provider.currentBooking.artistId != null
                              ? provider.getSelectedArtistName(
                              provider.currentBooking.artistId ?? '',
                              context)
                              : StringConstant.chooseAStaff,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        SvgPicture.asset(
                          ImagePathConstant.downArrow,
                          width: 3.w,
                          color: Colors.black,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                    singleStaffListExpanded
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: context
                            .read<HomeProvider>()
                            .artistList
                            .where((artist) => artist.salonId == provider.selectedSalonData.id)
                            .where((artist) => artist.name == widget.artistName) // Filter by selected category
                            .length,
                        itemBuilder: (context, index) {
                          Artist artist = context
                              .read<HomeProvider>()
                              .artistList
                              .where((artist) => artist.salonId == provider.selectedSalonData.id)
                              .where((artist) => artist.name == widget.artistName)// Filter by selected category
                              .toList()[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (provider.currentBooking.artistId ==
                                  artist.id )
                              {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: null,
                                );
                              } else {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: artist.id,
                                );
                              }
                              provider.updateIsNextButtonActive();
                              provider.resetSlotInfo();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 2.w),
                                            child: SvgPicture.asset(
                                              artist.id ==
                                                  provider
                                                      .currentBooking
                                                      .artistId
                                                  ? ImagePathConstant
                                                  .selectedOption
                                                  : ImagePathConstant
                                                  .unselectedOption,
                                              width: 5.w,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: artist.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: const Color(0xFF727272),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RatingBox(
                                    rating: artist.rating ?? 0.0,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ],
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
                child: Image.network(
                  provider.selectedSalonData.imageList![0].toString(),
                  height: 15.h,//15.h
                  width: 28.w,//15.w
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.salon.toUpperCase(),
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
/*
  Widget selectSingleStaffCard() {
    return Consumer<SalonDetailsProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: IconTextSelectorComponent(
                text: StringConstant.singleStaffText,
                iconPath: ImagePathConstant.singleStaffIcon,
                isSelected: false,
              ),
            ),
            SizedBox(height: 1.5.h),
            CurvedBorderedCard(
              onTap: () => setState(() {
                singleStaffListExpanded = !singleStaffListExpanded;
              }),
              child: Container(
                padding: EdgeInsets.all(1.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.h),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          provider.currentBooking.artistId != null
                              ? provider.getSelectedArtistName(
                              provider.currentBooking.artistId ?? '',
                              context)
                              : StringConstant.chooseAStaff,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                        SvgPicture.asset(
                          ImagePathConstant.downArrow,
                          width: 3.w,
                          color: Colors.black,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                    singleStaffListExpanded
                        ? Container(
                      constraints: BoxConstraints(maxHeight: 20.h),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: context
                            .read<HomeProvider>()
                            .artistList
                            .where((artist) => artist.salonId == provider.selectedSalonData.id)
                            .where((artist) => artist.name == widget.artistName) // Filter by selected category
                            .length,
                        itemBuilder: (context, index) {
                          Artist artist = context
                              .read<HomeProvider>()
                              .artistList
                              .where((artist) => artist.salonId == provider.selectedSalonData.id)
                              .where((artist) => artist.name == widget.artistName)// Filter by selected category
                              .toList()[index];
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              if (provider.currentBooking.artistId ==
                                  artist.id )
                              {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: null,
                                );
                              } else {
                                provider.setBookingData(
                                  context,
                                  setArtistId: true,
                                  artistId: artist.id,
                                );
                              }
                              provider.updateIsNextButtonActive();
                              provider.resetSlotInfo();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(
                                      children: <InlineSpan>[
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 2.w),
                                            child: SvgPicture.asset(
                                              artist.id ==
                                                  provider
                                                      .currentBooking
                                                      .artistId
                                                  ? ImagePathConstant
                                                  .selectedOption
                                                  : ImagePathConstant
                                                  .unselectedOption,
                                              width: 5.w,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: artist.name ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10.sp,
                                            color: Color(0xFF727272),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RatingBox(
                                    rating: artist.rating ?? 0.0,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(),
                      ),
                    )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
 */
