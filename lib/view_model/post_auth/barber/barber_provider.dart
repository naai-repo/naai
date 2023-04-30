import 'package:flutter/material.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';

class BarberProvider with ChangeNotifier {
  int _selectedArtistIndex = 0;

  Artist _artist = Artist();

  //============= GETTERS =============//
  int get selectedArtistIndex => _selectedArtistIndex;

  Artist get artist => _artist;

  /// Set the data of the selected [_artist]
  void setArtistData(BuildContext context) {
    _artist = context
            .read<SalonDetailsProvider>()
            .selectedSalonData
            .artist?[_selectedArtistIndex] ??
        Artist();
    print(_artist.toJson());
    notifyListeners();
  }

  /// Set the index of selected artist
  void setSelectedArtistIndex(int artistIndex) {
    _selectedArtistIndex = artistIndex;
    notifyListeners();
  }
}
