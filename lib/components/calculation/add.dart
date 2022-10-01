import 'package:fraction/fraction.dart';
import 'package:recipe/components/calculation/check.dart';
import 'package:recipe/components/calculation/convert.dart';

class Add {
  final Convert _convert = Convert();
  final Check _check = Check();

  //TODO 引数の型をString?じゃなくてStringにできないか検討する
  String calculate(String? previousAmount, String? addAmount) {
    final previousAmountType = _check.checkNumType(previousAmount);
    final addAmountType = _check.checkNumType(addAmount);
    final amountTypeList = [previousAmountType, addAmountType];

    // 計算しない
    if (amountTypeList.contains('blank')) {
      return previousAmount! + addAmount!;
    }

    // 結果がdouble
    else if (amountTypeList.contains('double')) {
      var result = _addOfResultIsDouble(previousAmount!, addAmount!);
      result = _convert.toRoundedDouble2(result);
      return _convert.toInt2(result);
    }

    // 結果がmixed fraction
    else if (amountTypeList.contains('mixed fraction')) {
      if (amountTypeList.contains('fraction')) {
        final result = _fractionAddMixedFraction(previousAmount!, addAmount!);
        if (result.toDouble() % 1 == 0) {
          return _convert.toInt2(result.toDouble());
        }
        return result.toString();
      }
      if (amountTypeList.contains('int')) {
        return _intAddMixedFraction(previousAmount!, addAmount!).toString();
      }

      //TODO 以下の処理もっときれいに書きたい
      final result =
          _mixedFractionAddMixedFraction(previousAmount!, addAmount!);

      if (result.toDouble() % 1 == 0) {
        return _convert.toInt2(result.toDouble());
      }
      return result.toString();
    }

    // 結果がfraction
    else if (amountTypeList.contains('fraction')) {
      final result = _fractionAddFraction(previousAmount!, addAmount!);

      // intへ変換
      //TODO 関数化したい
      if (result.toDouble() % 1 == 0) {
        return _convert.toInt2(result.toDouble());
      }
      // MixedFractionへ変換
      //TODO 関数化したい
      if (result.toDouble() >= 1) {
        return result.toMixedFraction().toString();
      }
      return result.toString();
    }

    // 結果がint
    else if (amountTypeList.contains('int')) {
      return _intAddInt(previousAmount!, addAmount!).toString();
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

  MixedFraction _intAddMixedFraction(String originalNum, String addNum) {
    // int.parseをtryするのがいいやり方かはわからない
    // if文より簡潔に書けるためtrhで実装
    try {
      return int.parse(originalNum).toMixedFraction() +
          addNum.toMixedFraction();
    } on Exception {
      return originalNum.toMixedFraction() +
          int.parse(addNum).toMixedFraction();
    }
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
    final totalAmount = (Rational.tryParse(originalNum)!.toDouble() +
            Rational.tryParse(addNum)!.toDouble())
        .toMixedFraction();

    return totalAmount;
  }

  // mixedFraction add
  MixedFraction _mixedFractionAddMixedFraction(
    String originalNum,
    String addNum,
  ) {
    // toDouble()を一度入れることで、約分できる
    // '3 3/3'のようば場合には、'4 0/1'になる（整数にはならない）ので注意
    return (originalNum.toMixedFraction() + addNum.toMixedFraction())
        .toDouble()
        .toMixedFraction();
  }
}
