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
      return _convert.toInt2(sumOfRoundedDouble);
    }

    if (amountTypeList.contains('mixed fraction')) {
      final sumOfMixedFraction = sum.toMixedFraction();

      if (sumOfMixedFraction.toDouble() % 1 == 0) {
        return _convert.toInt2(sumOfMixedFraction.toDouble());
      }
      return sumOfMixedFraction.toString();
    }

    if (amountTypeList.contains('fraction')) {
      final sumOfFraction = sum.toFraction();

      // intへ変換
      //TODO 関数化したい
      if (sumOfFraction.toDouble() % 1 == 0) {
        return _convert.toInt2(sumOfFraction.toDouble());
      }
      // MixedFractionへ変換
      if (sumOfFraction.toDouble() >= 1) {
        return sumOfFraction.toMixedFraction().toString();
      }
      return sumOfFraction.toString();
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
}
