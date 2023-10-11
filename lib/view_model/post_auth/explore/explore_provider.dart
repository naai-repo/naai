import 'package:flutter/material.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/utils/shared_preferences/shared_keys.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';

class ExploreProvider with ChangeNotifier {
  TextEditingController _salonSearchController = TextEditingController();
  TextEditingController _artistSearchController = TextEditingController();

  List<FilterType> _selectedFilterTypeList = [];
  List<SalonData> _salonData = [];
  List<SalonData> _filteredSalonData = [];
  List<ServiceDetail> _currentSalonServices = [];
  List<Artist> _artistList = [];

  bool _applyServiceFilter = false;
  Services _appliedServiceFilter = Services.HAIR;

  //============= GETTERS =============//
  TextEditingController get salonSearchController => _salonSearchController;
  TextEditingController get artistSearchController => _artistSearchController;

  List<FilterType> get selectedFilterTypeList => _selectedFilterTypeList;
  List<SalonData> get salonData => _salonData;
  List<SalonData> get filteredSalonData => _filteredSalonData;
  List<Artist> get artistList => _artistList;

  String formatTime(int timeInSeconds) {
    int hours = (timeInSeconds ~/ 3600) % 12;
    int minutes = ((timeInSeconds % 3600) ~/ 60);
    String amPm = (timeInSeconds ~/ 43200) == 0 ? 'AM' : 'PM';

    if (hours == 0) {
      hours = 12;
    }

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $amPm';
    return formattedTime;
  }

  /// Reset [_artistSearchController]
  void resetStylistSearchBar() {
    _artistSearchController.clear();
    notifyListeners();
  }

  /// Set selected filter
  void setSelectedFilter(FilterType filterType) {
    if (_selectedFilterTypeList.contains(filterType)) {
      _selectedFilterTypeList.remove(filterType);
      _filteredSalonData = _salonData;
    } else {
      _selectedFilterTypeList.add(filterType);
      _filteredSalonData.sort((a, b) {
        return b.rating!.compareTo(a.rating!);
      });
    }

    notifyListeners();
  }

  /// Method to initialize values of Explore screen viz. [_salonData] and [_userCurrentLatLng]
  void initExploreScreen(BuildContext context) async {
    Loader.showLoader(context);
    await getSalonList(context);
    artistList.forEach((artist) {
      artist.distanceFromUser = salonData
          .firstWhere((element) => element.id == artist.salonId)
          .distanceFromUser;
    });
    artistList.sort(
      (first, second) =>
          first.distanceFromUser!.compareTo(second.distanceFromUser!),
    );

    if (_applyServiceFilter) {
      filterSalonListByService(selectedServiceCategory: _appliedServiceFilter);
    }

    setApplyServiceFilter(value: false);

    Loader.hideLoader(context);
    notifyListeners();
  }

  /// Get all artist list from home screen
  void setArtistList(List<Artist> artists) {
    _artistList = artists;
    notifyListeners();
  }

  /// Get the list of salons and save it in [_salonData] and [_filteredSalonData]
  Future<void> getSalonList(BuildContext context,
      {bool justDistance = false}) async {
    try {
      if (!justDistance) _salonData = await DatabaseService().getSalonList(SharedKeys.userId);
      // print(context.read<HomeProvider>().userData.toMap());
      final latitude =
          context.read<HomeProvider>().userData.homeLocation != null
              ? context
                  .read<HomeProvider>()
                  .userData
                  .homeLocation!
                  .geoLocation!
                  .latitude
              : context.read<HomeProvider>().userCurrentLatLng.latitude;
      final longitude =
          context.read<HomeProvider>().userData.homeLocation != null
              ? context
                  .read<HomeProvider>()
                  .userData
                  .homeLocation!
                  .geoLocation!
                  .longitude
              : context.read<HomeProvider>().userCurrentLatLng.longitude;

      _salonData.forEach((element) {
        element.distanceFromUserAsString = "NA";
        if (element.address!.geoLocation != null) {
          element.distanceFromUser = element.address!.calculateDistance(
            latitude,
            longitude,
            element.address!.geoLocation!.latitude,
            element.address!.geoLocation!.longitude,
          );
          element.distanceFromUserAsString =
              '${element.address!.calculateDistance(
                    latitude,
                    longitude,
                    element.address!.geoLocation!.latitude,
                    element.address!.geoLocation!.longitude,
                  ).toStringAsFixed(2)}km';
        }
      });
      _salonData.sort((first, second) =>
          first.distanceFromUser!.compareTo(second.distanceFromUser!));
      _filteredSalonData.clear();
      _filteredSalonData.addAll(_salonData);
    } catch (e) {
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Set the value of [_filteredSalonData] according to the search query entered by user.
  void filterSalonList(String searchText) {
    _filteredSalonData.clear();
    _salonData.forEach((salon) {
      if (salon.name!.toLowerCase().contains(searchText.toLowerCase())) {
        _filteredSalonData.add(salon);
      }
    });
    notifyListeners();
  }

  /// Set the value of [_filteredSalonData] according to the selected service.
  void filterSalonListByService({required Services selectedServiceCategory}) {
    _filteredSalonData.clear();
    _salonData.forEach((salon) {
      _currentSalonServices.forEach((salonService) {
        if (salonService.category == selectedServiceCategory) {
          _filteredSalonData.add(salon);
        }
      });
    });
    notifyListeners();
  }

  /// Set the value of [_filteredSalonData] according to the selected service.
  // void filterSalonListByDistance({required Services selectedServiceCategory}) {
  //   _filteredSalonData.sort((first, second) => );
  //   notifyListeners();
  // }

  /// Save the index of the selected salon from the list of salons
  void setSelectedSalonIndex(BuildContext context, {int index = 0}) {
    context.read<SalonDetailsProvider>().setSelectedSalonIndex(index);
  }

  /// Search the index of selected salon and set the index value
  void setSalonIndexByData(
    BuildContext context,
    SalonData clickedSalonData,
  ) {
    int indexOfSalon =
        _salonData.indexWhere((salon) => salon.id == clickedSalonData.id);
    setSelectedSalonIndex(context, index: indexOfSalon);
  }

  /// Clear the value of [_salonSearchController]
  void clearSalonSearchController() {
    _salonSearchController.clear();
    notifyListeners();
  }

  void setApplyServiceFilter({
    required bool value,
    Services? service,
  }) {
    _applyServiceFilter = value;
    _appliedServiceFilter = service ?? Services.HAIR;
    notifyListeners();
  }

  Future<void> addPreferedSalon(BuildContext context, String? salonId) async {
    if (salonId == null) return;
    context.read<HomeProvider>().userData.preferredSalon!.add(salonId);
    await DatabaseService().updateUserData(
      data: context.read<HomeProvider>().userData.toMap(),
    );
    notifyListeners();
  }

  Future<void> removePreferedSalon(
      BuildContext context, String? salonId) async {
    context.read<HomeProvider>().userData.preferredSalon!.remove(salonId);
    await DatabaseService().updateUserData(
      data: context.read<HomeProvider>().userData.toMap(),
    );
    notifyListeners();
  }

  Future<void> addPreferedArtist(BuildContext context, String? artistId) async {
    if (artistId == null) return;
    context.read<HomeProvider>().userData.preferredArtist!.add(artistId);
    await DatabaseService().updateUserData(
      data: context.read<HomeProvider>().userData.toMap(),
    );
    notifyListeners();
  }

  Future<void> removePreferedArtist(
      BuildContext context, String? artistId) async {
    context.read<HomeProvider>().userData.preferredArtist!.remove(artistId);
    await DatabaseService().updateUserData(
      data: context.read<HomeProvider>().userData.toMap(),
    );
    notifyListeners();
  }
}
