import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String? id;
  String? artistId;
  int? startTime;
  int? endTime;
  List<String>? serviceIds;
  String? salonId;
  String? userId;
  String? selectedDate;
  String? bookingCreatedOn;
  String? bookingCreatedFor;

  /// These are additional parameters. Not being fetched/sent from/to Firebase
  /// This is being used to display the booking related data on the app only.
  String? salonName;
  String? artistName;
  String? serviceTitle;

  Booking({
    this.id,
    this.artistId,
    this.startTime,
    this.endTime,
    this.salonId,
    this.userId,
    this.serviceIds,
    this.bookingCreatedFor,
    this.bookingCreatedOn,
    this.salonName,
    this.artistName,
    this.serviceTitle,
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
      serviceIds: data['serviceIds'].cast<String>(),
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
      'serviceIds': serviceIds,
      'bookingCreatedOn': bookingCreatedOn,
      'bookingCreatedFor': bookingCreatedFor,
    };
  }
}
