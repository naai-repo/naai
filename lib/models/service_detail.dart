import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:naai/utils/enums.dart';

class ServiceDetail {
  ServiceEnum? category;
  String? serviceTitle;
  double? price;
  Gender? targetGender;
  String? id;
  String? salonId;

  ServiceDetail({
    this.category,
    this.serviceTitle,
    this.price,
    this.targetGender,
    this.salonId,
    this.id,
  });

  factory ServiceDetail.fromDocumentSnapshot(DocumentSnapshot docData) {
    Map<String, dynamic> data = docData.data() as Map<String, dynamic>;

    return ServiceDetail(
      id: data['id'],
      salonId: data['salonId'],
      category: ServiceEnum.values[(ServiceEnum.values.indexWhere(
          (category) => category.name.toLowerCase() == data['category']))],
      serviceTitle: data['serviceTitle'],
      price: data['price'].toDouble(),
      targetGender: data['targetGender'] == 'male'
          ? Gender.MEN
          : data['targetGender'] == 'female'
              ? Gender.WOMEN
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category?.index,
      'serviceTitle': serviceTitle,
      'price': price,
      'targetGender': targetGender?.index,
    };
  }
}
