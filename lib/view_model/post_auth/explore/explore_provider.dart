import 'dart:async';

import 'package:flutter/material.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/services/database.dart';
import 'package:naai/view/utils/loading_indicator.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';

class ExploreProvider with ChangeNotifier {
  TextEditingController _salonSearchController = TextEditingController();

  List<SalonData> _salonData = [];
  List<SalonData> _filteredSalonData = [];
  TextEditingController get salonSearchController => _salonSearchController;

  List<SalonData> get salonData => _salonData;
  List<SalonData> get filteredSalonData => _filteredSalonData;

  void getSalonList(BuildContext context) async {
    Loader.showLoader(context);
    try {
      _salonData = await DatabaseService().getSalonData();
      _filteredSalonData.clear();
      _filteredSalonData.addAll(_salonData);
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  void filterSalonList(String searchText) {
    _filteredSalonData.clear();
    _salonData.forEach((salon) {
      if (salon.name!.toLowerCase().contains(searchText.toLowerCase())) {
        _filteredSalonData.add(salon);
      }
    });
    notifyListeners();
  }

  void setSelectedSalonIndex(BuildContext context, {int index = 0}) {
    context.read<SalonDetailsProvider>().setSelectedSalonIndex(index);
  }
}
