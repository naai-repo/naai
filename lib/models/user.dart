/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class UserModel {
  String? name;
  String? phoneNumber;
  String? gmailId;
  String? appleId;
  String? gender;
  String? image;
  List<String>? preferredSalon;
  List<String>? preferredArtist;
  HomeLocation? homeLocation;
  String? id;
  DateTime? loginTime;

  UserModel({
    this.name,
    this.phoneNumber,
    this.gmailId,
    this.appleId,
    this.preferredSalon,
    this.preferredArtist,
    this.gender,
    this.homeLocation,
    this.id,
    this.image,
    this.loginTime
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'gmailId': gmailId,
      'appleId': appleId,
      'preferredSalon': preferredSalon,
      'preferredArtist': preferredArtist,
      'homeLocation': homeLocation == null ? null : homeLocation?.toMap(),
      'id': id,
      'gender': gender,
      'image':image,
      'loginTime': DateTime.now()
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
    image = map['image'];
    preferredSalon = List<String>.from(map['preferredSalon'] ?? []);
    preferredArtist = List<String>.from(map['preferredArtist'] ?? []);
    if (map['homeLocation'] == null) {
      // Set default coordinates for a dummy location (Delhi Rohini)
      homeLocation = HomeLocation(
        addressString: "Delhi Rohini",
        geoLocation: HomeLocation.getDummyGeoPoint(28.7094645,77.134957),
      );
    } else {
      homeLocation = HomeLocation.fromFirestore(map['homeLocation'] ?? {});
    }
    id = map['id'];
    loginTime = map['loginTime'];
  }
}

class HomeLocation {
  String? addressString;
  GeoPoint? geoLocation;

  static GeoPoint getDummyGeoPoint(double latitude, double longitude) {
    return GeoPoint(latitude, longitude);
  }
  HomeLocation({
    this.addressString,
    this.geoLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'geoLocation': geoLocation ??
          HomeLocation.getDummyGeoPoint(28.7094645,77.134957), // Default coordinates (Delhi)
    };
  }

  HomeLocation.fromFirestore(Map<String, dynamic> map) {
    GeoPoint? geoPoint = map['geoLocation'];
    addressString = map['addressString'];
    if (geoPoint == null) {
       geoLocation = HomeLocation.getDummyGeoPoint(28.7094645,77.134957);
    } else {
      geoLocation = GeoPoint(geoPoint.latitude, geoPoint.longitude);
    }
  }

  double calculateDistance(
      double startLat,
      double startLng,
      double endLat,
      double endLng,
      ) {
    const int radiusOfEarth = 6371;

    double latDifference = radians(endLat - startLat);
    double lngDifference = radians(endLng - startLng);

    double a = sin(latDifference / 2) * sin(latDifference / 2) +
        cos(radians(startLat)) *
            cos(radians(endLat)) *
            sin(lngDifference / 2) *
            sin(lngDifference / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = radiusOfEarth * c;
    return distance;
  }

  double radians(double degrees) {
    return degrees * (pi / 180);
  }
}
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class UserModel {
  String? name;
  String? phoneNumber;
  String? gmailId;
  String? appleId;
  String? gender;
  String? image;
  List<String>? preferredSalon;
  List<String>? preferredArtist;
  HomeLocation? homeLocation;
  String? id;

  UserModel({
    this.name,
    this.phoneNumber,
    this.gmailId,
    this.appleId,
    this.preferredSalon,
    this.preferredArtist,
    this.gender,
    this.homeLocation,
    this.id,
    this.image
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'gmailId': gmailId,
      'appleId': appleId,
      'preferredSalon': preferredSalon,
      'preferredArtist': preferredArtist,
      'homeLocation': homeLocation == null ? null : homeLocation?.toMap(),
      'id': id,
      'gender': gender,
      'image':image,
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
    image = map['image'] ;
    preferredSalon = List<String>.from(map['preferredSalon'] ?? []);
    preferredArtist = List<String>.from(map['preferredArtist'] ?? []);
    homeLocation = map['homeLocation'] == null
        ? null
        : HomeLocation.fromFirestore(map['homeLocation'] ?? {});
    id = map['id'];
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
    GeoPoint? geoPoint = map['geoLocation'];

    addressString = map['addressString'];
    geoLocation = geoPoint != null
        ? GeoPoint(geoPoint.latitude, geoPoint.longitude)
        : null;
  }

  double calculateDistance(
      double startLat,
      double startLng,
      double endLat,
      double endLng,
      ) {
    const int radiusOfEarth = 6371;

    double latDifference = radians(endLat - startLat);
    double lngDifference = radians(endLng - startLng);

    double a = sin(latDifference / 2) * sin(latDifference / 2) +
        cos(radians(startLat)) *
            cos(radians(endLat)) *
            sin(lngDifference / 2) *
            sin(lngDifference / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = radiusOfEarth * c;
    return distance;
  }

  double radians(double degrees) {
    return degrees * (pi / 180);
  }
}