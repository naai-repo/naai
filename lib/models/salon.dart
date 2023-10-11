import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/models/user.dart';

class SalonData {
  String? id;
  HomeLocation? address;
  double? rating, originalRating;
  String? name;
  String? imagePath;
  String? salonType;
  Timing? timing;
  String? distanceFromUserAsString;
  double? distanceFromUser;
  String? instagramLink;
  String? googleMapsLink;
  String? closingDay;

  SalonData({
    this.id,
    this.address,
    this.rating,
    this.originalRating,
    this.name,
    this.imagePath,
    this.salonType,
    this.timing,
    this.distanceFromUserAsString,
    this.distanceFromUser,
    this.instagramLink,
    this.googleMapsLink,
    this.closingDay,
  });

  factory SalonData.fromDocumentSnapshot(DocumentSnapshot data) {
    Map<String, dynamic> docData = data.data() as Map<String, dynamic>;

    return SalonData(
      id: docData['id'],
      address: HomeLocation.fromFirestore(docData['address'] ?? {}),
      name: docData['name'],
      rating: docData['rating'],
      originalRating: docData['rating'],
      imagePath: docData['imagePath'] ?? 'assets/images/salon_dummy_image.png',
      salonType: docData['salonType'],
      timing: Timing.fromFirestore(docData['timing'] ?? {}),
      instagramLink: docData['instagramLink'],
      googleMapsLink: docData['googleMapsLink'],
      closingDay: docData['closingDay']
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
