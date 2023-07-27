import 'package:flutter/material.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/enums.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';

class ExploreProvider with ChangeNotifier {
  TextEditingController _salonSearchController = TextEditingController();

  List<SalonData> _salonData = [];
  List<SalonData> _filteredSalonData = [];
  List<ServiceDetail> _currentSalonServices = [];
  List<Artist> _artistList = [];

  bool _applyServiceFilter = false;
  Services _appliedServiceFilter = Services.HAIR;

  //============= GETTERS =============//
  TextEditingController get salonSearchController => _salonSearchController;

  List<SalonData> get salonData => _salonData;
  List<SalonData> get filteredSalonData => _filteredSalonData;
  List<Artist> get artistList => _artistList;

  /// Method to initialize values of Explore screen viz. [_salonData] and [_userCurrentLatLng]
  void initExploreScreen(BuildContext context) async {
    Loader.showLoader(context);
    await getSalonList(context);

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
    print(_artistList.length);
    notifyListeners();
  }

  /// Get the list of salons and save it in [_salonData] and [_filteredSalonData]
  Future<void> getSalonList(BuildContext context) async {
    try {
      _salonData = await DatabaseService().getSalonData();
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
}
