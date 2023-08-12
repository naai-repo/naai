import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:naai/models/user.dart';

class SalonData {
  String? id;
  HomeLocation? address;
  double? rating;
  String? name;
  String? imagePath;
  String? salonType;
  Timing? timing;

  SalonData({
    this.id,
    this.address,
    this.rating,
    this.name,
    this.imagePath = 'assets/images/salon_dummy_image.png',
    this.salonType,
    this.timing,
  });

  factory SalonData.fromDocumentSnapshot(DocumentSnapshot data) {
    Map<String, dynamic> docData = data.data() as Map<String, dynamic>;

    return SalonData(
      id: docData['id'],
      address: HomeLocation.fromFirestore(docData['address'] ?? {}),
      name: docData['name'],
      rating: docData['rating'],
      imagePath: 'assets/images/salon_dummy_image.png',
      salonType: docData['salonType'],
      timing: Timing.fromFirestore(docData['timing'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address!.toMap(),
      'name': name,
      'rating': rating,
      'salonType': salonType,
      'timing': timing!.toJson(),
    };
  }

  String getDistanceAsString(LatLng? userLatLng) {
    if (address == null || userLatLng == null || address!.geoLocation == null)
      return 'NA';
    return address!
        .calculateDistance(
          userLatLng.latitude,
          userLatLng.longitude,
          address!.geoLocation!.latitude,
          address!.geoLocation!.longitude,
        )
        .toStringAsFixed(2);
  }
}

class Timing {
  int? opening;
  int? closing;

  Timing({
    this.closing,
    this.opening,
  });

  factory Timing.fromFirestore(Map<String, dynamic> data) {
    return Timing(
      opening: data['opening'],
      closing: data['closing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'opening': opening,
      'closing': closing,
    };
  }
}

enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}
