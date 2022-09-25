import 'package:fraction/fraction.dart';

class Calculation {
  /// execute
  String executeMultiply(int countInCart, String? amount) {
    final amountType = _checkNumType(amount);

    switch (amountType) {
      case 'int':
        return _multiplyInt(countInCart, amount!);
      case 'double':
        return _multiplyDouble(countInCart, amount!);
      case 'fraction':
        return _multiplyFraction(countInCart, amount!);
      case 'mixed fraction':
        return _multiplyMixedFraction(countInCart, amount!);
      default:
        return '';
    }
  }

  String executeAdd(String? previousAmount, String? addAmount) {
    final previousAmountType = _checkNumType(previousAmount);
    final addAmountType = _checkNumType(addAmount);
    final amountTypeList = [previousAmountType, addAmountType];

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
    if (amountTypeList.contains('double')) {
      if (amountTypeList.contains('fraction')) {
        return _doubleAddFraction(previousAmount!, addAmount!);
      }
      if (amountTypeList.contains('mixed fraction')) {
        return _doubleAddMixedFraction(previousAmount!, addAmount!);
      }
      return _doubleAddDouble(previousAmount!, addAmount!);
    }

    // 結果がmixed fraction
    if (amountTypeList.contains('mixed fraction')) {
      if (amountTypeList.contains('fraction')) {
        return _fractionAddMixedFraction(previousAmount!, addAmount!);
      }
      if (amountTypeList.contains('int')) {
        return _intAddMixedFraction(previousAmount!, addAmount!);
      }
      return _mixedFractionAddMixedFraction(previousAmount!, addAmount!);
    }

    // 結果がfraction
    if (amountTypeList.contains('fraction')) {
      if (amountTypeList.contains('int')) {
        return _intAddFraction(previousAmount!, addAmount!);
      }
      return _fractionAddFraction(previousAmount!, addAmount!);
    }

    // 結果がint
    if (amountTypeList.contains('int')) {
      return _intAddInt(previousAmount!, addAmount!);
    }

    // ここまではたどり着かない想定
    return '';
  }

  /// check
  String _checkNumType(String? num) {
    if (num == null) {
      return 'null';
    } else if (num == '') {
      return 'blank';
    }
    // fraction or mixedFraction
    else if (num.contains('/')) {
      try {
        num.toFraction();
        return 'fraction';
      } on Exception {
        try {
          num.toMixedFraction();
          return 'mixed fraction';
        } on Exception {
          return 'error';
        }
      }
    }
    // double or int
    else {
      try {
        final doubleNum = double.tryParse(num).toString();
        if (doubleNum.endsWith('.0')) {
          return 'int';
        } else {
          return 'double';
        }
      } on Exception {
        return 'error';
      }
    }
  }

  /// add
  // int add
  String _intAddInt(String originalNum, String addNum) {
    return (int.parse(originalNum) + int.parse(addNum)).toString();
  }

  String _intAddFraction(String originalNum, String addNum) {
    final totalAmount =
        (originalNum.toFraction() + addNum.toFraction()).toString();
    final doubleOfTotalAmount = totalAmount.toFraction().toDouble();

    if (doubleOfTotalAmount.toString().endsWith('.0')) {
      return _toInt(totalAmount);
    } else if (doubleOfTotalAmount >= 1) {
      return _toMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String _intAddMixedFraction(String originalNum, String addNum) {
    var totalAmount = '';

    final originalNumType = _checkNumType(originalNum);
    final addNumType = _checkNumType(addNum);

    if (originalNumType == 'int') {
      final originalNumInt = int.parse(originalNum);
      totalAmount =
          (originalNumInt.toMixedFraction() + addNum.toMixedFraction())
              .toString();

      if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
        return _toInt(totalAmount);
      }
    } else if (addNumType == 'int') {
      final addNumInt = int.parse(addNum);
      totalAmount =
          (originalNum.toMixedFraction() + addNumInt.toMixedFraction())
              .toString();

      if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
        return _toInt(totalAmount);
      }
    }

    return totalAmount;
  }

  // double add
  String _doubleAddDouble(String originalNum, String addNum) {
    final totalAmount =
        (double.parse(originalNum) + double.parse(addNum)).toString();

    if (totalAmount.endsWith('.0')) {
      return _toInt(totalAmount);
    }

    return totalAmount;
  }

  String _doubleAddFraction(String originalNum, String addNum) {
    final originalNumType = _checkNumType(originalNum);
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
      return _toInt(totalAmount);
    } else {
      return _toRoundedDouble(totalAmount);
    }
  }

  String _doubleAddMixedFraction(String originalNum, String addNum) {
    final originalNumType = _checkNumType(originalNum);
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
      return _toInt(totalAmount);
    }
    return _toRoundedDouble(totalAmount);
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
      return _toInt(totalAmount);
    }

    if (doubleOfTotalAmount >= 1) {
      return _toMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String _fractionAddMixedFraction(String originalNum, String addNum) {
    final originalNumType = _checkNumType(originalNum);

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

    totalAmount = _toMixedFraction(totalAmount);

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      totalAmount = totalAmount.toMixedFraction().toDouble().toString();
      return _toInt(totalAmount);
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
      return _toInt(totalAmount);
    }

    return totalAmount;
  }

  /// multiply
  String _multiplyInt(int countInCart, String num) {
    return (countInCart * double.parse(num).toInt()).toString();
  }

  String _multiplyDouble(int countInCart, String num) {
    final totalAmount = (countInCart * double.parse(num)).toString();

    if (totalAmount.endsWith('.0')) {
      return _toInt(totalAmount);
    }

    return totalAmount;
  }

  String _multiplyFraction(int countInCart, String num) {
    final totalAmount =
        (countInCart.toFraction() * num.toFraction()).toString();

    if (totalAmount.toFraction().toDouble().toString().endsWith('.0')) {
      return _toInt(totalAmount.toFraction().toDouble().toString());
    } else if (totalAmount.toFraction().toDouble() >= 1) {
      return _toMixedFraction(totalAmount);
    }

    return totalAmount;
  }

  String _multiplyMixedFraction(int countInCart, String num) {
    final totalAmount =
        (countInCart.toMixedFraction() * num.toMixedFraction()).toString();

    if (totalAmount.toMixedFraction().toDouble().toString().endsWith('.0')) {
      return _toInt(totalAmount.toMixedFraction().toDouble().toString());
    }
    return totalAmount;
  }

  /// cast
  String _toMixedFraction(String num) {
    return MixedFraction.fromFraction(num.toFraction()).toString();
  }

  String _toInt(String num) {
    if (num.endsWith('.0')) {
      return double.parse(num).toInt().toString();
    }

    return num;
  }

  // 四捨五入
  String _toRoundedDouble(String num) {
    const baseNum = 100;
    return ((double.tryParse(num)! * baseNum).round() / baseNum).toString();
  }
}
