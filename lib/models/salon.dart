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

  SalonData({
    this.address,
    this.rating,
    this.name,
    this.imagePath = 'https',
    this.salonType,
    this.artist,
    this.reviewList,
    this.services,
  });
}
