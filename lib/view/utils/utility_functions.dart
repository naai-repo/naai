import 'package:naai/view/utils/string_constant.dart';

class UtilityFunctions {
  static String getImagePath({required String imageTitle}) {
    return StringConstant.imageBaseDirectory + imageTitle;
  }
}
