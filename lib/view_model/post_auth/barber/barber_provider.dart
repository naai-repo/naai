import 'package:flutter/material.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/review.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';

class BarberProvider with ChangeNotifier {
  int _selectedArtistIndex = 0;

  List<Review> _artistReviewList = [];

  Artist _artist = Artist();

  //============= GETTERS =============//
  int get selectedArtistIndex => _selectedArtistIndex;

  List<Review> get artistReviewList => _artistReviewList;

  Artist get artist => _artist;

  void initArtistData(BuildContext context) async {
    setArtistData(context);
    await getArtistReviewList(context);
  }

  /// Set the data of the selected [_artist]
  void setArtistData(BuildContext context) {
    _artist =
        context.read<SalonDetailsProvider>().artistList[_selectedArtistIndex];
    notifyListeners();
  }

  /// Get the list of salons and save it in [_salonData] and [_filteredSalonData]
  Future<void> getArtistReviewList(BuildContext context) async {
    Loader.showLoader(context);
    try {
      _artistReviewList =
          await DatabaseService().getArtistReviewList(_artist.id);
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(context, '$e');
    }
    notifyListeners();
  }

  /// Set the index of selected artist
  void setSelectedArtistIndex(int artistIndex) {
    _selectedArtistIndex = artistIndex;
    notifyListeners();
  }
}