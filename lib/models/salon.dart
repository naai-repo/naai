import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/review.dart';
import 'package:naai/models/service_detail.dart';

class SalonData {
  String? address;
  double? rating;
  String? name;
  String? imagePath;
  String? salonType;
  List<Artist>? artist;
  List<Review>? reviewList;
  List<ServiceDetail>? services;
  List<Timing>? timing;

  SalonData({
    this.address,
    this.rating,
    this.name,
    this.imagePath = 'https',
    this.salonType,
    this.artist,
    this.reviewList,
    this.services,
    this.timing,
  });

  factory SalonData.fromDocumentSnapshot(DocumentSnapshot data) {
    Map<String, dynamic> docData = data.data() as Map<String, dynamic>;

    return SalonData(
      address: docData['address'],
      name: docData['name'],
      rating: docData['rating'],
      imagePath: 'assets/images/salon_dummy_image.png',
      salonType: docData['salonType'],
      artist: docData['artist'].length > 0
          ? docData['artist'].map<Artist>((artist) {
              return Artist.fromFirestore(artist);
            }).toList()
          : null,
      reviewList: docData['reviews'].length > 0
          ? docData['reviews'].map<Review>((review) {
              return Review.fromFirestore(review);
            }).toList()
          : null,
      services: docData['services'].length > 0
          ? docData['services'].map<ServiceDetail>((serviceDetail) {
              return ServiceDetail.fromFirestore(serviceDetail);
            }).toList()
          : null,
      timing: docData['timing'] != null
          ? docData['timing'].map<Timing>((time) {
              return Timing.fromFirestore(time);
            }).toList()
          : null,
    );
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

class Timing {
  Weekday? weekday;
  bool? open;
  String? openingTime;
  String? closingTime;

  Timing({
    this.weekday,
    this.open,
    this.openingTime,
    this.closingTime,
  });

  factory Timing.fromFirestore(Map<String, dynamic>? data) {
    return Timing(
      weekday: Weekday.values[Weekday.values.indexWhere(
        (weekdayEnum) => weekdayEnum.name.toString() == data?['weekday'],
      )],
      open: data?['open'] ?? false,
      openingTime: data?['openingTime'] ?? '',
      closingTime: data?['closingTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'weekday': weekday?.index,
        'open': open,
        'openingTime': openingTime,
        'closingTime': closingTime,
      };
}
