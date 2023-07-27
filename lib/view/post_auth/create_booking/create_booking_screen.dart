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
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class CreateBookingScreen extends StatefulWidget {
  const CreateBookingScreen({super.key});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  bool singleStaffListExpanded = false;
  bool showArtistSlotDialogue = false;

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
                                : CurvedBorderedCard(
                                  removeBottomPadding: false,
                                    child: Column(
                                      children: <Widget>[
                                        schedulingStatus(),
                                        SizedBox(height: 2.h),
                                        if (provider.isOnSelectStaffType)
                                          Padding(
                                            padding: EdgeInsets.all(2.h),
                                            child: Column(
                                              children: <Widget>[
                                                selectSingleStaffCard(),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.h),
                                                  child: Text(
                                                    StringConstant.or,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ),
                                                selectMultipleStaffCard(),
                                              ],
                                            ),
                                          ),
                                        if (provider.isOnSelectSlot)
                                          slotSelectionWidget(),
                                      ],
                                    ),
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
                                style: StyleConstant.appColorBoldTextStyle
                              ),
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
                      buttonText: StringConstant.confirm,
                      onTap: () => provider.createBooking(context),
                      // onTap: () => Navigator.pushNamed(
                      //   context,
                      //   NamedRoutes.paymentRoute,
                      // ),
                      isActive: true,
                    ),
                  ),
            Align(
              alignment: Alignment.center,
              child: showArtistSlotDialogue
                  ? artistSlotPickerDialogueBox()
                  : SizedBox(),
            ),
          ],
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
                      color: Color(0xFFDBDBDB),
                      thickness: 0.5.w,
                    ),
                    BookingOverviewPart(
                      title: StringConstant.serviceDate,
                      value: provider.currentBooking.selectedDate ?? '',
                    ),
                    VerticalDivider(
                      color: Color(0xFFDBDBDB),
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
                    Text(
                      StringConstant.services,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorsConstant.textLight,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(provider.currentBooking.serviceIds?.map(
                          (element) => Container(
                            margin: EdgeInsets.symmetric(vertical: 2.w),
                            child: Row(
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
                                              ''),
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
                                    GestureDetector(
                                      onTap: () => provider.setSelectedService(
                                        element,
                                        removeService: true,
                                      ),
                                      child: SvgPicture.asset(
                                        ImagePathConstant.deleteIcon,
                                        height: 2.5.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ) ??
                        []),
                    Divider(
                      thickness: 1,
                      color: Color(0xFFD3D3D3),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StringConstant.subtotal.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12.sp,
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
                                ' ₹ ${provider.totalPrice}',
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
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                StringConstant.tax,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                              Text(
                                ' ${StringConstant.gst} 18%',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF47CB7C),
                                ),
                              ),
                            ],
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
                                ' ₹ ${provider.totalPrice * 0.18}',
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            CurvedBorderedCard(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  3.w,
                  0,
                  3.w,
                  1.7.w,
                ),
                margin: EdgeInsets.symmetric(vertical: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstant.grandTotal,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsConstant.textDark,
                      ),
                    ),
                    Text(
                      ' ₹ ${provider.totalPrice * 0.18 + provider.totalPrice}',
                      style: TextStyle(
                        fontSize: 16.sp,
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
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${DateFormat.E().format(DateFormat('dd-MM-yyyy').parse(provider.currentBooking.selectedDate ?? ''))}, ${DateFormat.yMMMMd().format(DateFormat('dd-MM-yyyy').parse(provider.currentBooking.selectedDate ?? ''))}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Wrap(
                              children: provider.initialAvailability
                                  .map(
                                    (element) => GestureDetector(
                                      onTap: () => provider
                                              .artistAvailabilityToDisplay
                                              .contains(element)
                                          ? provider.setBookingData(
                                              context,
                                              setSelectedTime: true,
                                              startTime: element,
                                            )
                                          : null,
                                      child: Container(
                                        width: 17.w,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.w),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 1.w,
                                          vertical: 1.5.w,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2.h),
                                          border: Border.all(
                                            width: 1,
                                            color: Color(0xFFF5F5F5),
                                          ),
                                          color: provider
                                                  .artistAvailabilityToDisplay
                                                  .contains(element)
                                              ? element ==
                                                      (provider.currentBooking
                                                              .startTime ??
                                                          0)
                                                  ? ColorsConstant.appColor
                                                  : Colors.white
                                              : Colors.grey.shade200,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          provider.convertSecondsToTimeString(
                                              element),
                                          style: TextStyle(
                                            fontSize: 9.sp,
                                            color: provider
                                                    .artistAvailabilityToDisplay
                                                    .contains(element)
                                                ? element ==
                                                        (provider.currentBooking
                                                                .startTime ??
                                                            0)
                                                    ? Colors.white
                                                    : ColorsConstant.textDark
                                                : Colors.white,
                                          ),
                                        ),
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
                                    StringConstant.cancel.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorsConstant.appColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    showArtistSlotDialogue = false;
                                  }),
                                  child: Text(
                                    StringConstant.ok,
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
                        onTap: () {
                          provider.showDialogue(
                            context,
                            Container(
                              height: 40.h,
                              width: 40.h,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.h),
                                child: SfDateRangePicker(
                                  selectionColor: ColorsConstant.appColor,
                                  todayHighlightColor: ColorsConstant.appColor,
                                  backgroundColor: Colors.white,
                                  headerStyle: DateRangePickerHeaderStyle(
                                    textAlign: TextAlign.center,
                                  ),
                                  initialDisplayDate: DateTime.now().toLocal(),
                                  showNavigationArrow: true,
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
                          );
                        },
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
                              StringConstant.selectTimeSlot,
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
        return CurvedBorderedCard(
          removeBottomPadding: false,
          onTap: () =>
              provider.setStaffSelectionMethod(selectedSingleStaff: true),
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
              provider.selectedSingleStaff
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          singleStaffListExpanded = !singleStaffListExpanded;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(1.2.h),
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
                                          provider.currentBooking.artistId ??
                                              '')
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
                                    constraints:
                                        BoxConstraints(maxHeight: 20.h),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: provider.artistList.length,
                                      itemBuilder: (context, index) {
                                        Artist artist =
                                            provider.artistList[index];
                                        return GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            provider.setBookingData(
                                              context,
                                              setArtistId: true,
                                              artistId: artist.id,
                                            );
                                            provider.resetSlotInfo();
                                            provider.updateIsNextButtonActive();
                                            setState(() {
                                              singleStaffListExpanded = false;
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 2.w,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  artist.name ?? '',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10.sp,
                                                    color: Color(0xFF727272),
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
                                      separatorBuilder: (context, index) =>
                                          Divider(),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    )
                  : Container(
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
