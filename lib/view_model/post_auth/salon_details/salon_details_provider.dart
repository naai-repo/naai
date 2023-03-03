import 'package:flutter/material.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/view_model/post_auth/explore/explore_provider.dart';
import 'package:provider/provider.dart';

class SalonDetailsProvider with ChangeNotifier {
  int _selectedSalonIndex = 0;

  SalonData _selectedSalonData = SalonData();
  List<String> imagePaths = [
    'assets/images/salon_dummy_image.png',
    'assets/images/salon_dummy_image.png',
    'assets/images/salon_dummy_image.png',
  ];

  PageController _salonImageCarouselController = PageController();

  int get selectedSalonIndex => _selectedSalonIndex;

  SalonData get selectedSalonData => _selectedSalonData;

  PageController get salonImageCarouselController =>
      _salonImageCarouselController;

  void setSelectedSalonData(BuildContext context) {
    _selectedSalonData =
        context.read<ExploreProvider>().filteredSalonData[_selectedSalonIndex];
  }

  void setSelectedSalonIndex(int value) {
    _selectedSalonIndex = value;
    notifyListeners();
  }
}
