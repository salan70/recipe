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
        return _fractionAddMixedFraction(previousAmount!, addAmount!);
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
      Fraction result;

      if (amountTypeList.contains('int')) {
        result = _intAddFraction(previousAmount!, addAmount!);
      }

      result = _fractionAddFraction(previousAmount!, addAmount!);

      // intへ変換
      if (result.toDouble() % 1 == 0) {
        return _convert.toInt2(result.toDouble());
      }
      // MixedFractionへ変換
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

  Fraction _intAddFraction(String originalNum, String addNum) {
    return originalNum.toFraction() + addNum.toFraction();
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
  Fraction _fractionAddFraction(String originalNum, String addNum) {
    // toDouble()を一度入れることで、約分できる
    return (originalNum.toFraction() + addNum.toFraction())
        .toDouble()
        .toFraction();
  }

  String _fractionAddMixedFraction(String originalNum, String addNum) {
    final originalNumType = _check.checkNumType(originalNum);

    var totalAmount = '';

    if (originalNumType == 'mixed fraction') {
      // 帯分数を整数と小数に分割
      final originalNumList = originalNum.split(' ');
      final originalNumInt = originalNumList[0];
      final originalNumFraction = originalNumList[1];

      totalAmount = (originalNumInt.toFraction() +
              originalNumFraction.toFraction() +
              addNum.toFraction())
          .toString();
    } else {
      // 帯分数を整数と小数に分割
      final addNumList = addNum.split(' ');
      final addNumInt = addNumList[0];
      final addNumFraction = addNumList[1];

      totalAmount = (originalNum.toFraction() +
              addNumInt.toFraction() +
              addNumFraction.toFraction())
          .toString();
    }
    // 約分
    totalAmount = totalAmount.toFraction().toDouble().toFraction().toString();

    totalAmount = _convert.toMixedFraction(totalAmount);

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = totalAmount.toMixedFraction().toDouble().toString();
      return _convert.toInt(totalAmount);
    }

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
