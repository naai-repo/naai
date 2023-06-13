import 'package:flutter/material.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/booking.dart';
import 'package:naai/models/review.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/barber/barber_provider.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:provider/provider.dart';

class SalonDetailsProvider with ChangeNotifier {
  List<String> imagePaths = [
    'assets/images/salon_dummy_image.png',
    'assets/images/salon_dummy_image.png',
    'assets/images/salon_dummy_image.png',
  ];

  int _selectedSalonIndex = 0;

  double _totalPrice = 0;

  List<Gender> _selectedGendersFilter = [];
  List<Services> _selectedServiceCategories = [];
  List<ServiceDetail> _serviceList = [];
  List<Review> _salonReviewList = [];
  List<ServiceDetail> _filteredServiceList = [];
  List<Artist> _artistList = [];

  Booking _currentBooking = Booking();
  bool _selectedSingleStaff = false;
  bool _selectedMultipleStaff = false;

  List<String> _selectedServices = [];

  bool _isOnSelectStaffType = true;
  bool _isOnSelectSlot = false;
  bool _isOnPaymentPage = false;

  SalonData _selectedSalonData = SalonData();

  TextEditingController _searchController = TextEditingController();

  PageController _salonImageCarouselController = PageController();

  //============= GETTERS =============//
  int get selectedSalonIndex => _selectedSalonIndex;

  double get totalPrice => _totalPrice;

  List<Gender> get selectedGendersFilter => _selectedGendersFilter;
  List<Services> get selectedServiceCategories => _selectedServiceCategories;

  List<ServiceDetail> get serviceList => _serviceList;
  List<ServiceDetail> get filteredServiceList => _filteredServiceList;
  List<Artist> get artistList => _artistList;
  List<Review> get salonReviewList => _salonReviewList;

  List<String> get selectedServices => _selectedServices;

  bool get isOnSelectStaffType => _isOnSelectStaffType;
  bool get isOnSelectSlot => _isOnSelectSlot;
  bool get isOnPaymentPage => _isOnPaymentPage;
  bool get selectedSingleStaff => _selectedSingleStaff;
  bool get selectedMultipleStaff => _selectedMultipleStaff;

  SalonData get selectedSalonData => _selectedSalonData;

  TextEditingController get searchController => _searchController;

  PageController get salonImageCarouselController =>
      _salonImageCarouselController;

  void setStaffSelectionMethod({required bool selectedSingleStaff}) {
    _selectedSingleStaff = selectedSingleStaff;
    _selectedMultipleStaff = !selectedSingleStaff;
    notifyListeners();
  }

  void setSchedulingStatus({
    bool onSelectStaff = false,
    bool selectStaffFinished = false,
    bool selectSlotFinished = false,
  }) {
    if (onSelectStaff) {
      _isOnSelectStaffType = true;
      _isOnSelectSlot = false;
      _isOnPaymentPage = false;
    } else if (selectStaffFinished) {
      _isOnSelectStaffType = false;
      _isOnSelectSlot = true;
      _isOnPaymentPage = false;
    } else if (selectSlotFinished) {
      _isOnSelectStaffType = false;
      _isOnSelectSlot = false;
      _isOnPaymentPage = true;
    }
    notifyListeners();
  }

  /// Set the value of selected [SalonData] instance in [SalonDetailsProvider]
  void setSelectedSalonData(BuildContext context) {
    _selectedSalonData =
        context.read<ExploreProvider>().filteredSalonData[_selectedSalonIndex];

    _filteredServiceList.clear();
    _filteredServiceList.addAll(_serviceList);
  }

  void setSelectedService(String id) {
    if (_selectedServices.contains(id)) {
      _selectedServices.remove(id);
      var service = _serviceList.firstWhere((element) => element.id == id);
      _totalPrice -= service.price ?? 0;
    } else {
      _selectedServices.add(id);
      var service = _serviceList.firstWhere((element) => element.id == id);
      _totalPrice += service.price ?? 0;
    }

    notifyListeners();
  }

  void initSalonDetailsData(BuildContext context) async {
    Loader.showLoader(context);
    setSelectedSalonData(context);
    await getServiceList(context);
    await getArtistList(context);
    await getSalonReviewsList(context);
    Loader.hideLoader(context);
  }

  /// Get the list of salons and save it in [_salonData] and [_filteredSalonData]
  Future<void> getServiceList(BuildContext context) async {
    try {
      _serviceList =
          await DatabaseService().getServiceList(_selectedSalonData.id);
      _filteredServiceList.clear();
      _filteredServiceList.addAll(_serviceList);
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Get the list of salons and save it in [_salonData] and [_filteredSalonData]
  Future<void> getSalonReviewsList(BuildContext context) async {
    try {
      _salonReviewList =
          await DatabaseService().getSalonReviewsList(_selectedSalonData.id);
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Get the list of salons and save it in [_salonData] and [_filteredSalonData]
  Future<void> getArtistList(BuildContext context) async {
    try {
      _artistList =
          await DatabaseService().getArtistList(_selectedSalonData.id);
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
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
      _filteredServiceList.addAll(_serviceList);
    }

    if (_selectedGendersFilter.isNotEmpty) {
      _filteredServiceList.addAll(
        _serviceList.where(
          (service) => (_selectedGendersFilter.contains(service.targetGender)),
        ),
      );
    }

    if (_selectedServiceCategories.isNotEmpty) {
      _filteredServiceList.addAll(
        _serviceList.where(
          (service) => _selectedServiceCategories.contains(service.category),
        ),
      );
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
      {required Services selectedServiceCategory}) {
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
    _serviceList.forEach((service) {
      if (service.serviceTitle!
          .toLowerCase()
          .contains(searchText.toLowerCase())) {
        _filteredServiceList.add(service);
      }
    });
    notifyListeners();
  }

  /// Set the index of selected artist in [BarberProvider]
  void setSelectedArtistIndex(BuildContext context, {required int index}) {
    context.read<BarberProvider>().setSelectedArtistIndex(index);
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
}
