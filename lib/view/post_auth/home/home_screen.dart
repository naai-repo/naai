import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/image_path_constant.dart';
import 'package:naai/utils/string_constant.dart';
import 'package:naai/utils/style_constant.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<UserProvider>().getUserDetails(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ReusableWidgets.appScreenCommonBackground(),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              ReusableWidgets.transparentFlexibleSpace(),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 2.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3.h),
                          topRight: Radius.circular(3.h),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SvgPicture.asset(
                                ImagePathConstant.inAppLogo,
                                height: 5.h,
                              ),
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    height: 5.h,
                                    width: 30.w,
                                    child: TextFormField(
                                      cursorColor: ColorsConstant.appColor,
                                      style: StyleConstant.searchTextStyle,
                                      textInputAction: TextInputAction.done,
                                      onChanged: (searchText) =>
                                          print(searchText),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            ColorsConstant.graphicFillDark,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 3.5.w),
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.only(left: 2.w),
                                          child: SvgPicture.asset(
                                            ImagePathConstant.searchIcon,
                                            height: 2.h,
                                          ),
                                        ),
                                        prefixIconConstraints:
                                            BoxConstraints(minWidth: 9.w),
                                        hintText: StringConstant.search,
                                        hintStyle: TextStyle(
                                          color: ColorsConstant.textLight,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.h),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    padding: EdgeInsets.all(1.h),
                                    decoration: BoxDecoration(
                                      color: ColorsConstant.graphicFillDark,
                                      borderRadius: BorderRadius.circular(4.h),
                                    ),
                                    child: SvgPicture.asset(
                                        ImagePathConstant.appointmentIcon),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4.h, bottom: 2.h),
                            padding: EdgeInsets.all(0.5.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.h),
                              color: ColorsConstant.graphicFillDark,
                            ),
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              bool _shouldScroll = (TextPainter(
                                    text: TextSpan(
                                        text: Provider.of<UserProvider>(context,
                                                    listen: true)
                                                .userData
                                                .homeLocation
                                                ?.addressString ??
                                            "",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    maxLines: 1,
                                    textScaleFactor:
                                        MediaQuery.of(context).textScaleFactor,
                                    textDirection: TextDirection.ltr,
                                  )..layout())
                                      .size
                                      .width >
                                  constraints.maxWidth * 7 / 10;

                              return Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(1.5.h),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: SvgPicture.asset(
                                        ImagePathConstant.homeLocationIcon),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 2.w),
                                    width: 73.w,
                                    height: 4.h,
                                    alignment: Alignment.centerLeft,
                                    child: _shouldScroll
                                        ? Marquee(
                                            text:
                                                "${context.read<UserProvider>().getHomeAddressText()}",
                                            velocity: 40.0,
                                            pauseAfterRound:
                                                const Duration(seconds: 1),
                                            blankSpace: 30.0,
                                            style: TextStyle(
                                              color: ColorsConstant.textLight,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : Text(
                                            "${context.read<UserProvider>().getHomeAddressText()}",
                                            style: TextStyle(
                                              color: ColorsConstant.textLight,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                  ),
                                  Spacer(),
                                  SvgPicture.asset(
                                    ImagePathConstant.downArrow,
                                    color: ColorsConstant.textDark,
                                    width: 2.5.w,
                                  ),
                                  SizedBox(width: 1.w),
                                ],
                              );
                            }),
                          ),
                          dummyDeal(),
                          SizedBox(height: 1.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                StringConstant.viewMore,
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorsConstant.textDark,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                size: 2.h,
                              ),
                            ],
                          ),
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
  }

  Widget dummyDeal() {
    return Container(
      height: 20.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.h),
        color: Color(0xFF3F64E6),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: 95.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image.asset(
                    'assets/images/dummy_deal_background.png',
                    height: 10.h,
                  ),
                  Image.asset(
                    'assets/images/dummy_deal_woman.png',
                    height: 17.h,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 2.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '50%',
                  style: TextStyle(
                    fontSize: 35.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'WOMAN HAIRCUT',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
