import 'package:fraction/fraction.dart';

class Validations {
  Validations();

  String? outputAmountErrorText(String? ingredientAmount) {
    if (ingredientAmount == null || ingredientAmount == '') {
      return null;
    } else if (_isPositiveDouble(ingredientAmount) == false &&
        _isPositiveFraction(ingredientAmount) == false) {
      return '値が不正です';
    } else {
      return null;
    }
  }

  // 0以上かつdouble型にキャストできるか検証
  bool _isPositiveDouble(String ingredientAmount) {
    try {
      double num = double.parse(ingredientAmount);
      if (num >= 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // 0以上かつ、fraction型かmixedFraction型にキャストできるか検証
  bool _isPositiveFraction(String ingredientAmount) {
    try {
      var fraction = Fraction.fromString(ingredientAmount);
      if (fraction.toDouble() >= 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      try {
        var mixedFraction = MixedFraction.fromString(ingredientAmount);
        if (mixedFraction.toDouble() >= 0) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        return false;
      }
    }
  }
}
