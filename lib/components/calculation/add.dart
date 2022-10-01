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

    final amountAType = _check.checkNumType(amountA);
    final amountBType = _check.checkNumType(amountB);
    final amountTypeList = [amountAType, amountBType];

    if (amountTypeList.contains('blank')) {
      return amountA + amountB;
    }

    final totalAmount = _addOfResultIsDouble(amountA, amountB);

    if (amountTypeList.contains('double')) {
      //TODO 定数名変えたい
      final totalAmountOfRoundedDouble = _convert.toRoundedDouble(totalAmount);
      return _convert.toInt2(totalAmountOfRoundedDouble);
    }

    if (amountTypeList.contains('mixed fraction')) {
      //TODO 定数名変えたい
      final totalAmountOfMixedFraction = totalAmount.toMixedFraction();

      if (totalAmountOfMixedFraction.toDouble() % 1 == 0) {
        return _convert.toInt2(totalAmountOfMixedFraction.toDouble());
      }
      return totalAmountOfMixedFraction.toString();
    }

    if (amountTypeList.contains('fraction')) {
      final totalAmountOfFraction = totalAmount.toFraction();

      // intへ変換
      //TODO 関数化したい
      if (totalAmountOfFraction.toDouble() % 1 == 0) {
        return _convert.toInt2(totalAmountOfFraction.toDouble());
      }
      // MixedFractionへ変換
      //TODO 関数化したい
      if (totalAmountOfFraction.toDouble() >= 1) {
        return totalAmountOfFraction.toMixedFraction().toString();
      }
      return totalAmountOfFraction.toString();
    }

    if (amountTypeList.contains('int')) {
      return totalAmount.toInt().toString();
    }

    // ここまではたどり着かない想定
    return '';
  }

  double _addOfResultIsDouble(String amountA, String amountB) {
    return _convert.toDouble(amountA) + _convert.toDouble(amountB);
  }
}
