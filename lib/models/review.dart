import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? userName;
  String? imagePath;
  int? rating;
  DateTime? createdAt;
  String? reviewText;

  Review({
    this.userName,
    this.imagePath,
    this.rating,
    this.createdAt,
    this.reviewText,
  });

  factory Review.fromFirestore(Map<String, dynamic> json) {
    return Review(
      userName: json['userName'],
      imagePath: 'assets/images/artist_dummy_image.svg',
      rating: json['rating'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      reviewText: json['reviewText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'imagePath': imagePath,
      'rating': rating,
      'createdAt': createdAt,
      'reviewText': reviewText,
    };
  }
}