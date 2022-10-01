import 'package:fraction/fraction.dart';
import 'package:recipe/components/calculation/check.dart';
import 'package:recipe/components/calculation/convert.dart';

class Add {
  final Convert _convert = Convert();
  final Check _check = Check();

  //TODO 引数の型をString?じゃなくてStringにできないか検討する
  String calcSum(String? amountA, String? amountB) {
    if (amountA == null || amountB == null) {
      return '';
    }

    final amountAType = _check.checkType(amountA);
    final amountBType = _check.checkType(amountB);
    final amountTypeList = [amountAType, amountBType];

    if (amountTypeList.contains('blank')) {
      return amountA + amountB;
    }

    final sum = _addOfResultIsDouble(amountA, amountB);

    if (amountTypeList.contains('double')) {
      final sumOfRoundedDouble = _convert.toRoundedDouble(sum);
      return _convert.toIntFromDouble(sumOfRoundedDouble);
    }

    if (amountTypeList.contains('mixed fraction')) {
      return _convert.toIntFromFractions(sum.toMixedFraction());
    }

    if (amountTypeList.contains('fraction')) {
      return _formantFraction(sum.toFraction());
    }

    if (amountTypeList.contains('int')) {
      return sum.toInt().toString();
    }
    // ここまではたどり着かない想定
    return '';
  }

  double _addOfResultIsDouble(String amountA, String amountB) {
    return _convert.toDouble(amountA) + _convert.toDouble(amountB);
  }

  String _formantFraction(Fraction amount) {
    final amountOfDouble = amount.toDouble();
    if (amountOfDouble % 1 == 0) {
      return _convert.toIntFromDouble(amountOfDouble);
    }
    if (amountOfDouble > 1) {
      return amount.toMixedFraction().toString();
    }
    return amount.toString();
  }
}
