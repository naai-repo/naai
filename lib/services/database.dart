import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/booking.dart';
import 'package:naai/models/review.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/models/user.dart';
import 'package:naai/utils/shared_preferences/shared_preferences_helper.dart';

class DatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference salonCollection =
      FirebaseFirestore.instance.collection('salon');

  /// Set the user data to the [FirebaseFirestore] as a new entry
  Future<void> setUserData({
    required Map<String, dynamic> userData,
    required String docId,
  }) async {
    await userCollection.doc(docId).set(userData).onError(
          (error, stackTrace) => throw Exception(error),
        );
  }

  /// Updates an existing entry on [FirebaseFirestore] for a given [uid]
  Future<void> updateUserData({required Map<String, dynamic> data}) async {
    String uid = await SharedPreferenceHelper.getUserId();
    return await userCollection.doc(uid).update(data).onError(
          (error, stackTrace) => throw Exception(error),
        );
  }

  /// Check if a document with this userId exists or not.
  /// Returns [true] if the document exists, otherwise returns [false]
  Future<bool> checkUserExists({required String uid}) {
    return userCollection
        .doc(uid)
        .get()
        .then((value) => value.exists ? true : false)
        .onError(
          (error, stackTrace) => throw Exception(error),
        );
  }

  /// Fetch the salon list from [FirebaseFirestore]
  Future<List<SalonData>> getSalonData() async {
    QuerySnapshot querySnapshot = await salonCollection.get().onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );
    return querySnapshot.docs
        .map((docData) => SalonData.fromDocumentSnapshot(docData))
        .toList();
  }

  /// Fetch the salon list from [FirebaseFirestore]
  Future<List<ServiceDetail>> getServiceList(String? salonId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('services')
        .where('salonId', isEqualTo: salonId)
        .get()
        .onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );
    return querySnapshot.docs
        .map((docData) => ServiceDetail.fromDocumentSnapshot(docData))
        .toList();
  }

  /// Fetch the salon list from [FirebaseFirestore]
  Future<List<Review>> getArtistReviewList(String? artistId) async {
    print(artistId);
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('artistId', isEqualTo: artistId)
        .get()
        .onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );
    return querySnapshot.docs
        .map((docData) => Review.fromDocumentSnapshot(docData))
        .toList();
  }

  /// Fetch the salon list from [FirebaseFirestore]
  Future<List<Artist>> getArtistList(String? salonId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('artist')
        .where('salonId', isEqualTo: salonId)
        .get()
        .onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );

    return querySnapshot.docs
        .map((docData) => Artist.fromDocumentSnapshot(docData))
        .toList();
  }

  /// Fetch all artists from [FirebaseFirestore]
  Future<List<Artist>> getAllArtists() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('artist').get().onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );

    return querySnapshot.docs
        .map((docData) => Artist.fromDocumentSnapshot(docData))
        .toList();
  }

  /// Fetch the salon list from [FirebaseFirestore]
  Future<List<Booking>> getArtistBookingList(
    String? artistId,
    String bookingDate,
  ) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('booking')
        .where('artistId', isEqualTo: artistId)
        .where('bookingCreatedFor', isEqualTo: bookingDate)
        .get()
        .onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );

    return querySnapshot.docs
        .map((docData) => Booking.fromDocumentSnapshot(docData))
        .toList();
  }

  /// Fetch the salon list from [FirebaseFirestore]
  Future<List<Review>> getSalonReviewsList(String? salonId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('salonId', isEqualTo: salonId)
        .get()
        .onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );

    return querySnapshot.docs
        .map((docData) => Review.fromDocumentSnapshot(docData))
        .toList();
  }

  /// Fetch the user details from [FirebaseFirestore]
  Future<UserModel> getUserDetails() async {
    QuerySnapshot querySnapshot = await userCollection.get().onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );

    String uid = await SharedPreferenceHelper.getUserId();
    print(uid);
    return UserModel.fromSnapshot(
      querySnapshot.docs.firstWhere((docData) => docData.id == uid),
    );
  }

  Future<void> createBooking(
      {required List<Map<String, dynamic>> bookingData}) async {
    final batch = FirebaseFirestore.instance.batch();
    for (var booking in bookingData) {
      DocumentReference dbCollection =
          FirebaseFirestore.instance.collection('booking').doc();

      batch.set(dbCollection, booking);
    }
    await batch.commit();
  }
}
