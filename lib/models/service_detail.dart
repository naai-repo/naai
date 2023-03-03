import 'package:naai/view/utils/enums.dart';

class ServiceDetail {
  String? category;
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
