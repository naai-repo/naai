import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? phoneNumber;
  String? gmailId;
  String? appleId;
  String? gender;
  List<String>? preferredSalon;
  HomeLocation? homeLocation;

  UserModel({
    this.name,
    this.phoneNumber,
    this.gmailId,
    this.appleId,
    this.preferredSalon,
    this.gender,
    this.homeLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'gmailId': gmailId,
      'appleId': appleId,
      'preferredSalon': preferredSalon,
      'homeLocation': homeLocation?.toMap(),
      'gender': gender,
    };
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String, dynamic>);

  UserModel.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    phoneNumber = map['phoneNumber'];
    gmailId = map['gmailId'];
    appleId = map['appleId'];
    gender = map['gender'];
    preferredSalon = List<String>.from(map['preferredSalon'] ?? []);
    homeLocation = HomeLocation.fromFirestore(map['homeLocation'] ?? {});
  }

}

class HomeLocation {
  String? addressString;
  GeoPoint? geoLocation;

  HomeLocation({
    this.addressString,
    this.geoLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'addressString': addressString,
      'geoLocation': geoLocation,
    };
  }

  HomeLocation.fromFirestore(Map<String, dynamic> map) {
    GeoPoint geoPoint = map['geoLocation'];

    addressString = map['addressString'];
    geoLocation = map['geoLocation'] != null
        ? GeoPoint(geoPoint.latitude, geoPoint.longitude)
        : null;
  }
}
