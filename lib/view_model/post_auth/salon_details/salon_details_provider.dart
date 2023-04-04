import 'package:flutter/material.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/utils/colors_constant.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SalonDetailsProvider with ChangeNotifier {
  List<Color> colors = [
    ColorsConstant.reviewStarGreyColor,
    ColorsConstant.reviewStarGreyColor,
    ColorsConstant.reviewStarGreyColor,
    ColorsConstant.reviewStarGreyColor,
    ColorsConstant.reviewStarGreyColor,
  ];

  List<String> imagePaths = [
    'assets/images/salon_dummy_image.png',
    'assets/images/salon_dummy_image.png',
    'assets/images/salon_dummy_image.png',
  ];

  int _selectedSalonIndex = 0;

  List<Gender> _selectedGendersFilter = [];
  List<ServiceEnum> _selectedServiceCategories = [];
  List<ServiceDetail> _filteredServiceList = [];

  SalonData _selectedSalonData = SalonData();

  TextEditingController _searchController = TextEditingController();

  PageController _salonImageCarouselController = PageController();

  //============= GETTERS =============//
  int get selectedSalonIndex => _selectedSalonIndex;

  List<Gender> get selectedGendersFilter => _selectedGendersFilter;
  List<ServiceEnum> get selectedServiceCategories => _selectedServiceCategories;
  List<ServiceDetail> get filteredServiceList => _filteredServiceList;

  SalonData get selectedSalonData => _selectedSalonData;

  TextEditingController get searchController => _searchController;

  PageController get salonImageCarouselController =>
      _salonImageCarouselController;

  /// Set the value of selected [SalonData] instance in [SalonDetailsProvider]
  void setSelectedSalonData(BuildContext context) {
    _selectedSalonData =
        context.read<ExploreProvider>().filteredSalonData[_selectedSalonIndex];

    _filteredServiceList.clear();
    _filteredServiceList.addAll(_selectedSalonData.services ?? []);
  }

  /// Save the index of selected [SalonData] instance in [SalonDetailsProvider]
  void setSelectedSalonIndex(int value) {
    _selectedSalonIndex = value;
    notifyListeners();
  }

  /// Filter the [_filteredServiceList] according to the filters that the user
  /// has chosen
  void filterSalonServices({
    bool genderFiltersApplied = false,
    bool serviceCategoryFiltersApplied = false,
  }) {
    _filteredServiceList.clear();
    if (_selectedGendersFilter.isEmpty && _selectedServiceCategories.isEmpty) {
      _filteredServiceList.addAll(_selectedSalonData.services ?? []);
    }

    if (_selectedGendersFilter.isNotEmpty) {
      _filteredServiceList.addAll(_selectedSalonData.services?.where(
              (service) =>
                  (_selectedGendersFilter.contains(service.targetGender))) ??
          []);
    }

    if (_selectedServiceCategories.isNotEmpty) {
      _filteredServiceList.addAll(_selectedSalonData.services?.where(
              (service) =>
                  _selectedServiceCategories.contains(service.category)) ??
          []);
    }
    notifyListeners();
  }

  /// Set the value of [_selectedGendersFilter] according to the gender filter selected
  /// by user
  void setSelectedGendersFilter({required Gender selectedGender}) {
    _selectedGendersFilter.contains(selectedGender)
        ? _selectedGendersFilter
            .removeWhere((gender) => gender == selectedGender)
        : _selectedGendersFilter.add(selectedGender);

    filterSalonServices(genderFiltersApplied: true);
    notifyListeners();
  }

  /// Set the value of [_selectedServiceCategories] according to the service categories selected
  /// by the user
  void setSelectedServiceCategories(
      {required ServiceEnum selectedServiceCategory}) {
    _selectedServiceCategories.contains(selectedServiceCategory)
        ? _selectedServiceCategories.removeWhere(
            (serviceCategory) => serviceCategory == selectedServiceCategory)
        : _selectedServiceCategories.add(selectedServiceCategory);
    filterSalonServices(serviceCategoryFiltersApplied: true);
    notifyListeners();
  }

  /// Filter the [_filteredServiceList] according to the entered
  /// search text by the user
  void filterOnSearchText(String searchText) {
    _filteredServiceList.clear();
    _selectedSalonData.services?.forEach((service) {
      if (service.serviceTitle!
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        _filteredServiceList.add(service);
      }
    });
    notifyListeners();
  }

  /// Clear the value of [_selectedGendersFilter]
  void clearSelectedGendersFilter() {
    _selectedGendersFilter.clear();
    notifyListeners();
  }

  /// Clear the value of [_searchController]
  void clearSearchController() {
    _searchController.clear();
    notifyListeners();
  }

  /// Clear the value of [_selectedServiceCategories]
  void clearSelectedServiceCategories() {
    _selectedServiceCategories.clear();
    notifyListeners();
  }

  void setColor(double x) {
    if (x > 25.w) {
      colors[0] = Colors.red;
      notifyListeners();
    }
    if (x > 35.w) {
      colors[1] = Colors.red;
      notifyListeners();
    }
    if (x > 50.w) {
      colors[2] = Colors.red;
      notifyListeners();
    }
    if (x > 65.w) {
      colors[3] = Colors.red;
      notifyListeners();
    }
    if (x >= 80.w) {
      colors[4] = Colors.red;
      notifyListeners();
    }
  }
}
