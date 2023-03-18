import 'package:naai/utils/string_constant.dart';

class UtilityFunctions {
  static String getImagePath({required String imageTitle}) {
    return StringConstant.imageBaseDirectory + imageTitle;
  }
}
