import 'package:fraction/fraction.dart';

class Validation {
  Validation();

  String? errorText(String? text) {
    String? errorText;

    if (text != null && text != '') {
      if (checkDoubleAndPlus(text) == false) {
        if (checkFractionAndPlus(text) == false) {
          errorText = '値が不正です';
        }
      }
    }
    return errorText;
  }

  bool checkDoubleAndPlus(String text) {
    bool isOk = true;

    try {
      double num = double.parse(text);
      if (num <= 0) {
        isOk = false;
      }
    } catch (e) {
      isOk = false;
    }

    return isOk;
  }

  bool checkFractionAndPlus(String text) {
    bool isOk = true;

    try {
      var fraction = Fraction.fromString(text);
      if (fraction.toDouble() <= 0) {
        isOk = false;
      }
    } catch (e) {
      isOk = false;
      try {
        MixedFraction.fromString(text);
        isOk = true;
      } catch (e) {
        isOk = false;
      }
    }

    return isOk;
  }
}
