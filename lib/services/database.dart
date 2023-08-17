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
  final CollectionReference artistCollection =
      FirebaseFirestore.instance.collection('artist');
  final CollectionReference bookingCollection =
      FirebaseFirestore.instance.collection('booking');
  final CollectionReference servicesCollection =
      FirebaseFirestore.instance.collection('services');
  final CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');

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
  Future<List<SalonData>> getSalonList() async {
    QuerySnapshot querySnapshot = await salonCollection.get().onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );
    return querySnapshot.docs
        .map((docData) => SalonData.fromDocumentSnapshot(docData))
        .toList();
  }

  Future<SalonData> getSalonData(String salonId) async {
    QuerySnapshot querySnapshot =
        await salonCollection.where('id', isEqualTo: salonId).get().onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );
    return SalonData.fromDocumentSnapshot(querySnapshot.docs.first);
  }

  /// Fetch the services list for a given salon from [FirebaseFirestore]
  Future<List<ServiceDetail>> getServiceList(String? salonId) async {
    QuerySnapshot querySnapshot = await servicesCollection
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

  /// Add review
  Future<void> addReview({required Review reviewData}) async {
    final DocumentReference reference = reviewsCollection.doc();
    reviewData.id = reference.id;

    await reference.set(reviewData.toJson()).onError(
          (error, stackTrace) => throw Exception(error),
        );
  }

  /// Fetch the artist's reviews from [FirebaseFirestore]
  Future<List<Review>> getArtistReviewList(String? artistId) async {
    QuerySnapshot querySnapshot = await reviewsCollection
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

  /// Fetch the artist list of a given salon from [FirebaseFirestore]
  Future<List<Artist>> getArtistListOfSalon(String? salonId) async {
    QuerySnapshot querySnapshot = await artistCollection
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
    QuerySnapshot querySnapshot = await artistCollection.get().onError(
      (error, stackTrace) {
        throw Exception(error);
      },
    );

    return querySnapshot.docs
        .map((docData) => Artist.fromDocumentSnapshot(docData))
        .toList();
  }

  /// Fetch all bookings made by user from [FirebaseFirestore]
  Future<List<Booking>> getUserBookings({required String userId}) async {
    QuerySnapshot querySnapshot = await bookingCollection
        .where('userId', isEqualTo: userId)
        .orderBy('bookingCreatedFor')
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

  /// Fetch all the services from [FirebaseFirestore]
  Future<List<ServiceDetail>> getAllServices() async {
    QuerySnapshot querySnapshot = await servicesCollection.get();

    return querySnapshot.docs
        .map((docData) => ServiceDetail.fromDocumentSnapshot(docData))
        .toList();
  }

  /// Fetch the artist's booking list from [FirebaseFirestore]
  Future<List<Booking>> getArtistBookingList(
    String? artistId,
    String bookingDate,
  ) async {
    QuerySnapshot querySnapshot = await bookingCollection
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

  /// Fetch the salon's reviews list from [FirebaseFirestore]
  Future<List<Review>> getSalonReviewsList(String? salonId) async {
    QuerySnapshot querySnapshot = await reviewsCollection
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
    return UserModel.fromSnapshot(
      querySnapshot.docs.firstWhere((docData) => docData.id == uid),
    );
  }

  /// Create a booking
  Future<void> createBooking(
      {required Map<String, dynamic> bookingData}) async {
    await bookingCollection.add(bookingData).onError(
          (error, stackTrace) => throw Exception(error),
        );
  }

  Future<List<Review>> getUserReviewsList(String? userId) async {
    QuerySnapshot querySnapshot = await reviewsCollection
        // .where('userId', isEqualTo: userId)
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

  Future<List<SalonData>> getPreferredSalon(
      List<String> preferredSalonIds) async {
    if (preferredSalonIds.isEmpty) {
      return [];
    }
    QuerySnapshot querySnapshot = await salonCollection
        .where('id', whereIn: preferredSalonIds)
        .get()
        .onError((error, stackTrace) => throw Exception(error));
    return querySnapshot.docs
        .map((salonData) => SalonData.fromDocumentSnapshot(salonData))
        .toList();
  }
}
