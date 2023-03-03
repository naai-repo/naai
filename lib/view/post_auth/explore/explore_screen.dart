import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naai/view/utils/colors_constant.dart';
import 'package:naai/view/utils/image_path_constant.dart';
import 'package:naai/view/utils/routing/named_routes.dart';
import 'package:naai/view/utils/string_constant.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late TabController homeScreenController;

  @override
  void initState() {
    homeScreenController = TabController(length: 1, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ExploreProvider>().getSalonList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ExploreProvider>(builder: (context, provider, child) {
        return NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              elevation: 10,
              backgroundColor: Colors.white,
              pinned: true,
              floating: true,
              title: Padding(
                padding: EdgeInsets.only(top: 3.h),
                child: Text(
                  StringConstant.exploreSalons,
                  style: TextStyle(
                    color: ColorsConstant.appColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              centerTitle: false,
              bottom: searchBarWithLocation(),
            ),
          ],
          body: TabBarView(
            controller: homeScreenController,
            children: <Widget>[
              salonList(),
            ],
          ),
        );
      }),
    );
  }

  Widget salonList() {
    return Consumer<ExploreProvider>(builder: (context, provider, child) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        color: Colors.white,
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: provider.filteredSalonData.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              provider.setSelectedSalonIndex(context, index: index);
              Navigator.pushNamed(context, NamedRoutes.salonDetailsRoute);
            },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Hero(
                        tag: 'Salon$index',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                              provider.filteredSalonData[index].imagePath ??
                                  ''),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            provider.filteredSalonData[index].name ?? '',
                            style: TextStyle(
                              color: ColorsConstant.textDark,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.5.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2.h),
                              color: ColorsConstant.graphicFill,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${provider.filteredSalonData[index].rating}',
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorsConstant.textDark,
                                  ),
                                ),
                                SizedBox(width: 1.w),
                                SvgPicture.asset(
                                  ImagePathConstant.starIcon,
                                  height: 2.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(ImagePathConstant.locationIconAlt),
                          SizedBox(width: 1.w),
                          Text(
                            '1.3 Km',
                            style: TextStyle(
                              color: ColorsConstant.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.2.h),
                      Text(
                        '${provider.filteredSalonData[index].address}',
                        style: TextStyle(
                          color: Color(0xFFA4A4A4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                  index == (provider.filteredSalonData.length - 1)
                      ? SizedBox()
                      : Divider(
                          thickness: 1,
                          color: ColorsConstant.divider,
                        ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  PreferredSizeWidget searchBarWithLocation() {
    return PreferredSize(
      preferredSize: Size.fromHeight(10.h),
      child: Consumer<ExploreProvider>(builder: (context, provider, child) {
        return TabBar(
          controller: homeScreenController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 50.w,
                    height: 5.h,
                    child: TextFormField(
                      controller: provider.salonSearchController,
                      cursorColor: ColorsConstant.appColor,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      textInputAction: TextInputAction.done,
                      onChanged: (searchText) =>
                          provider.filterSalonList(searchText),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorsConstant.graphicFillDark,
                        contentPadding: EdgeInsets.symmetric(horizontal: 3.5.w),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 3.5.w),
                          child: SvgPicture.asset(
                            ImagePathConstant.searchIcon,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(minWidth: 11.w),
                        hintText: StringConstant.search,
                        hintStyle: TextStyle(
                          color: ColorsConstant.textLight,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Flexible(
                          flex: 0,
                          child: Container(
                            padding: EdgeInsets.all(1.2.h),
                            margin: EdgeInsets.only(right: 1.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2, 2),
                                  color: Colors.grey.shade300,
                                  spreadRadius: 0.5,
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              ImagePathConstant.locationIcon,
                              color: ColorsConstant.appColor,
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Delhi, India",
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                StringConstant.changeLocation,
                                style: TextStyle(
                                  color: ColorsConstant.appColor,
                                  fontSize: 9.sp,
                                  decoration: TextDecoration.underline,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
