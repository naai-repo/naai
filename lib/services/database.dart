import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/models/salon.dart';
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
    return querySnapshot.docs
        .map((docData) => SalonData.fromDocumentSnapshot(docData))
        .toList();
  }
}
