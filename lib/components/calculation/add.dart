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

    final sum = _addOfDoubles(amountA, amountB);

    if (amountTypeList.contains('double')) {
      return _formatDouble(sum);
    }

    if (amountTypeList.contains('mixed fraction')) {
      return _formantMixedFraction(sum);
    }

    if (amountTypeList.contains('fraction')) {
      return _formantFraction(sum);
    }

    if (amountTypeList.contains('int')) {
      return _formatInt(sum);
    }
    // ここまではたどり着かない想定
    return '';
  }

  double _addOfDoubles(String amountA, String amountB) {
    return _convert.toDouble(amountA) + _convert.toDouble(amountB);
  }

  /// format
  String _formatInt(double amount) {
    return amount.toInt().toString();
  }

  String _formatDouble(double amount) {
    final amountOfRoundedDouble = _convert.toRoundedDouble(amount);
    return _convert.toIntFromDouble(amountOfRoundedDouble);
  }

  String _formantFraction(double amount) {
    final amountOfFraction = amount.toFraction();
    // Fix 定数名イケてない
    // MixedFractionに変換されてからDoubleに変換されたということがわからないため
    final amountOfDouble = amountOfFraction.toDouble();

    if (amountOfDouble % 1 == 0) {
      return _convert.toIntFromDouble(amountOfDouble);
    }
    if (amountOfDouble > 1) {
      return amountOfDouble.toMixedFraction().toString();
    }
    return amountOfFraction.toString();
  }

  String _formantMixedFraction(double amount) {
    final amountOfMixedFraction = amount.toMixedFraction();
    // Fix 定数名イケてない
    // MixedFractionに変換されてからDoubleに変換されたということがわからないため
    final amountOfDouble = amountOfMixedFraction.toDouble();

    if (amountOfDouble % 1 == 0) {
      return _convert.toIntFromDouble(amountOfDouble);
    }
    return amountOfMixedFraction.toString();
  }
}
