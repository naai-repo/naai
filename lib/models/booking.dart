import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String? id;
  String? artistId;
  int? startTime;
  int? endTime;
  // List<String>? serviceId;
  String? serviceId;
  String? salonId;
  String? userId;
  String? selectedDate;
  String? bookingCreatedOn;
  String? bookingCreatedFor;

  Booking({
    this.id,
    this.artistId,
    this.startTime,
    this.endTime,
    this.salonId,
    this.userId,
    this.serviceId,
    this.bookingCreatedFor,
    this.bookingCreatedOn,
  });

  factory Booking.fromDocumentSnapshot(DocumentSnapshot docData) {
    Map<String, dynamic> data = docData.data() as Map<String, dynamic>;

    return Booking(
      id: data['id'],
      artistId: data['artistId'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      salonId: data['salonId'],
      userId: data['userId'],
      // serviceId: data['serviceId'].cast<String>(),
      serviceId: data['serviceId'],
      bookingCreatedOn: data['bookingCreatedOn'],
      bookingCreatedFor: data['bookingCreatedFor'],
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
      'bookingCreatedOn': bookingCreatedOn,
      'bookingCreatedFor': bookingCreatedFor,
    };
  }
}
