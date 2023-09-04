import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClient {
  static Future<DocumentSnapshot> getDocument(
    String path,
    CollectionReference collection,
  ) async {
    return collection.doc(path).get();
  }

  static Future<void> setDocument(
    String path,
    Map<String, dynamic> data,
    CollectionReference collection,
  ) async {
    return collection.doc(path).set(data);
  }

  static Future<void> updateDocument(
    String path,
    Map<String, dynamic> data,
    CollectionReference collection,
  ) async {
    return collection.doc(path).update(data);
  }

  static Future<void> deleteDocument(
    String path,
    CollectionReference collection,
  ) async {
    return collection.doc(path).delete();
  }
}
