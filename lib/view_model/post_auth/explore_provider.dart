import 'package:flutter/material.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/services/database.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';

class ExploreProvider with ChangeNotifier {
  bool _isLoadingSalonList = false;

  List<SalonData> _salonData = [];

  List<SalonData> get salonData => _salonData;
  bool get isLoadingSalonList => _isLoadingSalonList;

  void getSalonList(BuildContext context) async {
    _isLoadingSalonList = true;

    try {
      _salonData = await DatabaseService().getSalonData();
      _isLoadingSalonList = false;
    } catch (e) {
      _isLoadingSalonList = false;
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }
}
