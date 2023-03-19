import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/models/artist.dart';
import 'package:naai/models/review.dart';
import 'package:naai/models/service_detail.dart';
import 'package:naai/utils/enums.dart';

class SalonData {
  String? address;
  double? rating;
  String? name;
  String? imagePath;
  String? salonType;
  List<Artist>? artist;
  List<Review>? reviewList;
  List<ServiceDetail>? services;
  Map<String, bool>? timing;

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

  SalonData.fromDocumentSnapshot(DocumentSnapshot docData)
      : address = docData['address'],
        name = docData['name'],
        rating = docData['rating'],
        imagePath = 'assets/images/salon_dummy_image.png',
        salonType = docData['salonType'],
        artist = docData['artist'].map<Artist>((artist) {
          return Artist(
            imagePath: 'assets/images/artist_dummy_image.svg',
            name: artist['name'],
            rating: artist['rating'],
          );
        }).toList(),
        reviewList = docData['reviews'].length > 0
            ? docData['reviews'].map<Review>((review) {
                return Review(
                  userName: review['userName'],
                  imagePath: 'assets/images/artist_dummy_image.svg',
                  rating: review['rating'],
                  createdAt: (review['createdAt'] as Timestamp).toDate(),
                  reviewText: review['reviewText'],
                );
              }).toList()
            : null,
        services = docData['services'].length > 0
            ? docData['services'].map<ServiceDetail>((service) {
                return ServiceDetail(
                  category: ServiceEnum.values.elementAt(ServiceEnum.values
                      .indexWhere((category) =>
                          category.name.toLowerCase() == service['category'])),
                  price: service['price'].toDouble(),
                  serviceTitle: service['serviceTitle'],
                  targetGender: service['targetGender'] == 'male'
                      ? Gender.MEN
                      : service['targetGender'] == 'female'
                          ? Gender.WOMEN
                          : null,
                );
              }).toList()
            : null;
  // timing = docData['timing'];
}
