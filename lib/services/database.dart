import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> setUserData({
    String? name,
    String? phoneNumber,
    String? gmailId,
    String? appleId,
  }) async {
    return await userCollection.doc(uid).set(UserModel(
          name: name,
          phoneNumber: phoneNumber,
          gmailId: gmailId,
          appleId: appleId,
        ).toJson());
  }

  Future<void> updateUserData({required Map<String, dynamic> data}) async {
    return await userCollection.doc(uid).update(data);
  }

  Future<void> readUserData({String? documentId}) async {
    return await userCollection.doc(uid).get().then((document) {
      print(document['name']);
    });
  }
}
