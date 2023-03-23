import 'package:naai/utils/enums.dart';

class ServiceDetail {
  ServiceEnum? category;
  String? serviceTitle;
  double? price;
  Gender? targetGender;

  ServiceDetail({
    this.category,
    this.serviceTitle,
    this.price,
    this.targetGender,
  });

  factory ServiceDetail.fromFirestore(Map<String, dynamic> data) {
    return ServiceDetail(
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
