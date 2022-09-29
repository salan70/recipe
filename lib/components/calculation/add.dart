import 'package:fraction/fraction.dart';
import 'package:recipe/components/calculation/check.dart';
import 'package:recipe/components/calculation/convert.dart';

class Add {
  final Convert _convert = Convert();
  final Check _check = Check();

  String calculate(String? previousAmount, String? addAmount) {
    final previousAmountType = _check.checkNumType(previousAmount);
    final addAmountType = _check.checkNumType(addAmount);
    final amountTypeList = [previousAmountType, addAmountType];

    dynamic result = '';

    // 計算しない
    if (amountTypeList.contains('blank')) {
      if (previousAmountType == 'blank') {
        return addAmount!;
      }
      if (addAmountType == 'blank') {
        return previousAmount!;
      }
      return '';
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
        return _intAddMixedFraction(previousAmount!, addAmount!);
      }
      return _mixedFractionAddMixedFraction(previousAmount!, addAmount!);
    }

    // 結果がfraction
    else if (amountTypeList.contains('fraction')) {
      if (amountTypeList.contains('int')) {
        return _intAddFraction(previousAmount!, addAmount!);
      }
      return _fractionAddFraction(previousAmount!, addAmount!);
    }

    // 結果がint
    else if (amountTypeList.contains('int')) {
      return _intAddInt(previousAmount!, addAmount!);
    } else {
      // ここまではたどり着かない想定
      return '';
    }
  }

  /// private
  double _addOfResultIsDouble(String originalNum, String addNum) {
    return _convert.toDouble(originalNum) + _convert.toDouble(addNum);
  }

  String _intAddInt(String originalNum, String addNum) {
    return (int.parse(originalNum) + int.parse(addNum)).toString();
  }

  String _intAddFraction(String originalNum, String addNum) {
    final totalAmount =
        (originalNum.toFraction() + addNum.toFraction()).toString();
    final doubleOfTotalAmount = totalAmount.toFraction().toDouble();

    if (doubleOfTotalAmount.toString().endsWith('.0')) {
      return _convert.toInt(totalAmount);
    } else if (doubleOfTotalAmount >= 1) {
      return _convert.toMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String _intAddMixedFraction(String originalNum, String addNum) {
    var totalAmount = '';

    final originalNumType = _check.checkNumType(originalNum);
    final addNumType = _check.checkNumType(addNum);

    if (originalNumType == 'int') {
      final originalNumInt = int.parse(originalNum);
      totalAmount =
          (originalNumInt.toMixedFraction() + addNum.toMixedFraction())
              .toString();

      if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
        return _convert.toInt(totalAmount);
      }
    } else if (addNumType == 'int') {
      final addNumInt = int.parse(addNum);
      totalAmount =
          (originalNum.toMixedFraction() + addNumInt.toMixedFraction())
              .toString();

      if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
        return _convert.toInt(totalAmount);
      }
    }

    return totalAmount;
  }

  // double add
  String _doubleAddDouble(String originalNum, String addNum) {
    final totalAmount =
        (double.parse(originalNum) + double.parse(addNum)).toString();

    if (totalAmount.endsWith('.0')) {
      return _convert.toInt(totalAmount);
    }

    return totalAmount;
  }

  String _doubleAddFraction(String originalNum, String addNum) {
    final originalNumType = _check.checkNumType(originalNum);
    var totalAmount = '';

    if (originalNumType == 'fraction') {
      totalAmount =
          (originalNum.toFraction().toDouble() + double.tryParse(addNum)!)
              .toString();
    } else {
      totalAmount =
          (double.tryParse(originalNum)! + addNum.toFraction().toDouble())
              .toString();
    }

    if (totalAmount.endsWith('.0')) {
      return _convert.toInt(totalAmount);
    } else {
      return _convert.toRoundedDouble(totalAmount);
    }
  }

  String _doubleAddMixedFraction(String originalNum, String addNum) {
    final originalNumType = _check.checkNumType(originalNum);
    var totalAmount = '';

    if (originalNumType == 'mixed fraction') {
      totalAmount =
          (originalNum.toMixedFraction().toDouble() + double.tryParse(addNum)!)
              .toString();
    } else {
      totalAmount =
          (double.tryParse(originalNum)! + addNum.toMixedFraction().toDouble())
              .toString();
    }

    if (totalAmount.endsWith('.0')) {
      return _convert.toInt(totalAmount);
    }
    return _convert.toRoundedDouble(totalAmount);
  }

  // fraction add
  String _fractionAddFraction(String originalNum, String addNum) {
    var totalAmount =
        (originalNum.toFraction() + addNum.toFraction()).toString();
    final doubleOfTotalAmount = totalAmount.toFraction().toDouble();

    // 約分
    totalAmount = doubleOfTotalAmount.toFraction().toString();

    if (doubleOfTotalAmount.toString().endsWith('.0')) {
      totalAmount = doubleOfTotalAmount.toString();
      return _convert.toInt(totalAmount);
    }

    if (doubleOfTotalAmount >= 1) {
      return _convert.toMixedFraction(totalAmount);
    }

    return totalAmount;
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
  String _mixedFractionAddMixedFraction(String originalNum, String addNum) {
    var totalAmount =
        (originalNum.toMixedFraction() + addNum.toMixedFraction()).toString();

    totalAmount =
        totalAmount.toMixedFraction().toDouble().toMixedFraction().toString();

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = totalAmount.toMixedFraction().toDouble().toString();
      return _convert.toInt(totalAmount);
    }

    return totalAmount;
  }
}
