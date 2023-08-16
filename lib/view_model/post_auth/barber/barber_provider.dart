import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/review.dart';
import 'package:naai/services/database.dart';
import 'package:naai/utils/exception/exception_handling.dart';
import 'package:naai/utils/loading_indicator.dart';
import 'package:naai/view/post_auth/home/home_screen.dart';
import 'package:naai/view/widgets/reusable_widgets.dart';
import 'package:naai/view_model/post_auth/home/home_provider.dart';
import 'package:naai/view_model/post_auth/salon_details/salon_details_provider.dart';
import 'package:provider/provider.dart';

class BarberProvider with ChangeNotifier {
  int _selectedArtistIndex = 0;

  List<Review> _artistReviewList = [];

  Artist _artist = Artist();

  bool _shouldSetArtistData = true;

  //============= GETTERS =============//
  int get selectedArtistIndex => _selectedArtistIndex;

  List<Review> get artistReviewList => _artistReviewList;

  Artist get artist => _artist;

  bool get shouldSetArtistData => _shouldSetArtistData;

  void initArtistData(BuildContext context) async {
    if (_shouldSetArtistData) {
      setArtistData(context);
    }
    await getArtistReviewList(context);
    _shouldSetArtistData = true;
  }

  /// Set the data of the selected [_artist]
  void setArtistData(
    BuildContext context, {
    Artist? artistData,
  }) {
    _artist =
        context.read<SalonDetailsProvider>().artistList[_selectedArtistIndex];
    notifyListeners();
  }

  /// Set the data of the selected [_artist] if the user selects the artist
  /// from [HomeScreen]
  void setArtistDataFromHome(Artist artistData) {
    _artist = artistData;
    _shouldSetArtistData = false;
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

  Future<void> submitReview(
    BuildContext context, {
    required int stars,
    required String text,
  }) async {
    if (stars < 1) {
      ReusableWidgets.showFlutterToast(context, "Please add stars");
      return;
    }
    Loader.showLoader(context);
    Review review = Review(
      artistId: artist.id,
      comment: text,
      createdAt: DateTime.now(),
      userId: context.read<HomeProvider>().userData.id,
      userName: context.read<HomeProvider>().userData.name,
      rating: stars.toDouble(),
    );

    try {
      await DatabaseService().addReview(reviewData: review).onError(
            (FirebaseException error, stackTrace) =>
                throw ExceptionHandling(message: error.message ?? ""),
          );
      _artistReviewList.add(review);
      Loader.hideLoader(context);
    } catch (e) {
      Loader.hideLoader(context);
      ReusableWidgets.showFlutterToast(
        context,
        '$e',
      );
    }
    notifyListeners();
  }

  /// Set the index of selected artist
  void setSelectedArtistIndex(int artistIndex) {
    _selectedArtistIndex = artistIndex;
    notifyListeners();
  }
}
