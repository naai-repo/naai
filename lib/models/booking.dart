import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String? artistId;
  int? startTime;
  String? serviceId;
  int? endTime;
  String? salonId;
  String? userId;

  Booking({
    this.artistId,
    this.startTime,
    this.endTime,
    this.salonId,
    this.userId,
    this.serviceId,
  });

  factory Booking.fromDocumentSnapshot(DocumentSnapshot docData) {
    Map<String, dynamic> data = docData.data() as Map<String, dynamic>;

    return Booking(
      artistId: data['artistId'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      salonId: data['salonId'],
      userId: data['userId'],
      serviceId: data['serviceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artistId': artistId,
      'startTime': startTime,
      'endTime': endTime,
      'salonId': salonId,
      'userId': userId,
      'serviceId': serviceId,
    };
  }
}
