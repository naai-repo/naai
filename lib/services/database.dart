import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  /// Set the user data to the [FirebaseFirestore] as a new entry
  Future<void> setUserData({required Map<String, dynamic> userData}) async {
    return await userCollection.doc(uid).set(userData);
  }

  /// Updates an existing entry on [FirebaseFirestore] for a given [uid]
  Future<void> updateUserData({required Map<String, dynamic> data}) async {
    return await userCollection.doc(uid).update(data);
  }

  /// Check if a document with this userId exists or not.
  /// Returns [true] if the document exists, otherwise returns [false]
  Future<bool> checkUserExists() {
    return userCollection
        .doc(uid)
        .get()
        .then((value) => value.exists ? true : false);
  }
}
