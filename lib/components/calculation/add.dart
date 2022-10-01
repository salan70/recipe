import 'package:fraction/fraction.dart';
import 'package:recipe/components/calculation/check.dart';
import 'package:recipe/components/calculation/convert.dart';

class Add {
  final Convert _convert = Convert();
  final Check _check = Check();

  //TODO 引数の型をString?じゃなくてStringにできないか検討する
  String calculate(String? amountA, String? amountB) {
    final amountAType = _check.checkNumType(amountA);
    final amountBType = _check.checkNumType(amountB);
    final amountTypeList = [amountAType, amountBType];

    // 計算しない
    if (amountTypeList.contains('blank')) {
      return amountA! + amountB!;
    }

    // 結果がdouble
    else if (amountTypeList.contains('double')) {
      var totalAmount = _addOfResultIsDouble(amountA!, amountB!);
      totalAmount = _convert.toRoundedDouble2(totalAmount);
      return _convert.toInt2(totalAmount);
    }

    // 結果がmixed fraction
    else if (amountTypeList.contains('mixed fraction')) {
      if (amountTypeList.contains('fraction')) {
        final totalAmount = _fractionAddMixedFraction(amountA!, amountB!);
        if (totalAmount.toDouble() % 1 == 0) {
          return _convert.toInt2(totalAmount.toDouble());
        }
        return totalAmount.toString();
      }
      if (amountTypeList.contains('int')) {
        return _fractionAddMixedFraction(amountA!, amountB!).toString();
      }

      //TODO 以下の処理もっときれいに書きたい
      final totalAmount = _fractionAddMixedFraction(amountA!, amountB!);

      if (totalAmount.toDouble() % 1 == 0) {
        return _convert.toInt2(totalAmount.toDouble());
      }
      return totalAmount.toString();
    }

    // 結果がfraction
    else if (amountTypeList.contains('fraction')) {
      final totalAmount = _fractionAddFraction(amountA!, amountB!);

      // intへ変換
      //TODO 関数化したい
      if (totalAmount.toDouble() % 1 == 0) {
        return _convert.toInt2(totalAmount.toDouble());
      }
      // MixedFractionへ変換
      //TODO 関数化したい
      if (totalAmount.toDouble() >= 1) {
        return totalAmount.toMixedFraction().toString();
      }
      return totalAmount.toString();
    }

    // 結果がint
    else if (amountTypeList.contains('int')) {
      return _intAddInt(amountA!, amountB!).toString();
    }

    // ここまではたどり着かない想定
    else {
      return '';
    }
  }

  /// private
  double _addOfResultIsDouble(String originalNum, String addNum) {
    return _convert.toDouble(originalNum) + _convert.toDouble(addNum);
  }

  int _intAddInt(String originalNum, String addNum) {
    return int.parse(originalNum) + int.parse(addNum);
  }

  // fraction add
  //TODO 関数名変える
  Fraction _fractionAddFraction(String originalNum, String addNum) {
    // toDouble()を一度入れることで、約分できる
    return (originalNum.toFraction() + addNum.toFraction())
        .toDouble()
        .toFraction();
  }

  MixedFraction _fractionAddMixedFraction(String originalNum, String addNum) {
    return (Rational.tryParse(originalNum)!.toDouble() +
            Rational.tryParse(addNum)!.toDouble())
        .toMixedFraction();
  }
}
