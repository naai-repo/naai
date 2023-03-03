import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/review.dart';
import 'package:naai/models/salon.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/view/utils/enums.dart';
import 'package:naai/view/utils/shared_preferences/shared_preferences_helper.dart';

class DatabaseService {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference salonCollection =
      FirebaseFirestore.instance.collection('salons');

  /// Set the user data to the [FirebaseFirestore] as a new entry
  Future<void> setUserData({required Map<String, dynamic> userData}) async {
    String uid = await SharedPreferenceHelper.getUserId();
    return await userCollection.doc(uid).set(userData).onError(
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
          (error, stackTrace) => throw Exception(error),
        );

    final List<SalonData> allData = querySnapshot.docs.map((docData) {
      return SalonData(
        address: docData['address'],
        name: docData['name'],
        rating: docData['rating'],
        imagePath: 'assets/images/salon_dummy_image.png',
        salonType: docData['salonType'],
        artist: docData['artist'].map<Artist>((artist) {
          return Artist(
            imagePath: 'assets/images/artist_dummy_image.svg',
            name: artist['name'],
            rating: artist['rating'],
          );
        }).toList(),
        reviewList: docData['reviews'].length > 0
            ? docData['reviews'].map<Review>((review) {
                return Review(
                  userName: review['userName'],
                  imagePath: 'assets/images/artist_dummy_image.svg',
                  rating: review['rating'],
                  createdAt: (review['createdAt'] as Timestamp).toDate(),
                  reviewText: review['reviewText'],
                );
              }).toList()
            : null,
        services: docData['services'].length > 0
            ? docData['services'].map<ServiceDetail>((service) {
                return ServiceDetail(
                  category: service['category'],
                  price: service['price'].toDouble(),
                  serviceTitle: service['serviceTitle'],
                  targetGender: service['targetGender'] == 'male'
                      ? Gender.MALE
                      : service['targetGender'] == 'female'
                          ? Gender.FEMALE
                          : Gender.OTHERS,
                );
              }).toList()
            : null,
      );
    }).toList();

    return allData;
  }
}
