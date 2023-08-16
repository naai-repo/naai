import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? artistId;
  String? comment;
  String? id;
  String? salonId;
  String? userId;
  DateTime? createdAt;
  String? imagePath;
  String? userName;
  num? rating;

  Review({
    this.artistId,
    this.comment,
    this.id,
    this.createdAt,
    this.salonId,
    this.userId,
    this.imagePath,
    this.userName,
    this.rating,
  });

  factory Review.fromDocumentSnapshot(DocumentSnapshot docData) {
    Map<String, dynamic> json = docData.data() as Map<String, dynamic>;

    return Review(
      artistId: json['artistId'],
      comment: json['comment'],
      id: json['id'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      salonId: json['salonId'],
      userId: json['userId'],
      imagePath: json['imagePath'] ?? 'assets/images/salon_dummy_image.png',
      userName: json['userName'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artistId': artistId,
      'comment': comment,
      'id': id,
      'createdAt': Timestamp.fromDate(createdAt ?? DateTime.now()),
      'salonId': salonId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
    };
  }
}
