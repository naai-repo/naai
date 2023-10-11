import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/models/user.dart';

class SalonData {
  String? id;
  HomeLocation? address;
  double? rating, originalRating;
  String? name;
  String? imagePath;
  List? imageList;
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
    this.imageList,
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
      imagePath: docData['imagePath'] ?? 'https://firebasestorage.googleapis.com/v0/b/naai-5d31f.appspot.com/o/salon_images%2Fsample_salon_img.jpg?alt=media&token=fa1a55ab-41a6-47e0-aefb-1546b3597a20&_gl=1*1380abk*_ga*MTQ0NjM3MTQzMy4xNjk2Njg1MTk3*_ga_CW55HF8NVT*MTY5NjkwNTQ5OS4xNC4xLjE2OTY5MDU5OTIuMjYuMC4w',
      imageList: docData['imageList'] ?? const[
        'https://firebasestorage.googleapis.com/v0/b/naai-5d31f.appspot.com/o/salon_images%2Fsample_salon_img.jpg?alt=media&token=fa1a55ab-41a6-47e0-aefb-1546b3597a20&_gl=1*1380abk*_ga*MTQ0NjM3MTQzMy4xNjk2Njg1MTk3*_ga_CW55HF8NVT*MTY5NjkwNTQ5OS4xNC4xLjE2OTY5MDU5OTIuMjYuMC4w',
        'https://firebasestorage.googleapis.com/v0/b/naai-5d31f.appspot.com/o/salon_images%2Fsample_salon_img.jpg?alt=media&token=fa1a55ab-41a6-47e0-aefb-1546b3597a20&_gl=1*1380abk*_ga*MTQ0NjM3MTQzMy4xNjk2Njg1MTk3*_ga_CW55HF8NVT*MTY5NjkwNTQ5OS4xNC4xLjE2OTY5MDU5OTIuMjYuMC4w',
        'https://firebasestorage.googleapis.com/v0/b/naai-5d31f.appspot.com/o/salon_images%2Fsample_salon_img.jpg?alt=media&token=fa1a55ab-41a6-47e0-aefb-1546b3597a20&_gl=1*1380abk*_ga*MTQ0NjM3MTQzMy4xNjk2Njg1MTk3*_ga_CW55HF8NVT*MTY5NjkwNTQ5OS4xNC4xLjE2OTY5MDU5OTIuMjYuMC4w',
      ],
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
      'imageList': imageList,
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
