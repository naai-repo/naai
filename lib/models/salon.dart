import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/models/user.dart';

class SalonData {
  String? id;
  HomeLocation? address;
  double? rating, originalRating;
  String? name;
  String? imagePath;
  List<String>? imageList;
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
    this.imageList = const[
      'https://firebasestorage.googleapis.com/v0/b/naai-5d31f.appspot.com/o/barber1_dp.jpg?alt=media&token=e08cd8ee-dba1-495a-bfcb-7487148315cb&_gl=1*v3r8j5*_ga*MTQ0NjM3MTQzMy4xNjk2Njg1MTk3*_ga_CW55HF8NVT*MTY5Njg1NDU5My4xMC4xLjE2OTY4NTkwOTQuNTguMC4w',
      'https://firebasestorage.googleapis.com/v0/b/naai-5d31f.appspot.com/o/barber1_dp.jpg?alt=media&token=e08cd8ee-dba1-495a-bfcb-7487148315cb&_gl=1*v3r8j5*_ga*MTQ0NjM3MTQzMy4xNjk2Njg1MTk3*_ga_CW55HF8NVT*MTY5Njg1NDU5My4xMC4xLjE2OTY4NTkwOTQuNTguMC4w',
      'https://firebasestorage.googleapis.com/v0/b/naai-5d31f.appspot.com/o/barber1_dp.jpg?alt=media&token=e08cd8ee-dba1-495a-bfcb-7487148315cb&_gl=1*v3r8j5*_ga*MTQ0NjM3MTQzMy4xNjk2Njg1MTk3*_ga_CW55HF8NVT*MTY5Njg1NDU5My4xMC4xLjE2OTY4NTkwOTQuNTguMC4w',
    ],
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
      imageList: docData['imageList'],
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
