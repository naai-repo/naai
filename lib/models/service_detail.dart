import 'package:naai/utils/enums.dart';

class ServiceDetail {
  ServiceEnum? category;
  String? serviceTitle;
  double? price;
  Gender? targetGender;

  ServiceDetail({
    this.category,
    this.price,
    this.serviceTitle,
    this.targetGender,
  });
}
